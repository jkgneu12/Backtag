//
//  BTCreateViewController.m
//  Backtag
//
//  Created by James George on 9/28/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import "BTCreateViewController.h"

#import "BTPlayersViewController.h"
#import "BTGameViewController.h"
#import "UIImage+ImageEffects.h"

#import <Parse/Parse.h>

@interface BTCreateViewController ()
{
    NSMutableArray *_selectedUsernames;
    enum {
        kFriends = 0,
        kGlobal = 1
    } Section;
}
@end

@implementation BTCreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.imageView setImage:[self.image applyLightEffect]];
    
    [self setupBarButtons];
}

- (void)setupBarButtons
{
    UIBarButtonItem *submitButton = nil;
    if(self.keywordView.text.length > 0) {
        submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submit:)];
    }
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = submitButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPlayer:(id)sender {
    BTPlayersViewController *playersController = [[BTPlayersViewController alloc] initWithNibName:@"BTPlayersViewController" bundle:nil];
    
    [self.navigationController pushViewController:playersController animated:YES];
}

- (IBAction)segmentChanged:(id)sender {
    if([self.segment selectedSegmentIndex] == kFriends){
        [self.addPlayerButton setHidden:NO];
        [self.playersLabel setHidden:NO];
    } else {
        [self.addPlayerButton setHidden:YES];
        [self.playersLabel setHidden:YES];
    }
}

- (IBAction)keywordChanged:(id)sender {
    [self setupBarButtons];
}

-(void)submit:(id)sender
{
    _selectedUsernames = [NSMutableArray arrayWithObject:@"JamesMurph"];//TODO: remove
    
    PFQuery *queryUsername = [PFUser query];
    [queryUsername whereKey:@"username" containedIn:_selectedUsernames];

    [queryUsername findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            PFObject *game = [[PFObject alloc] initWithClassName:@"Game"];
            [game setObject:[PFUser currentUser] forKey:@"creator"];
            [game setObject:self.keywordView.text forKey:@"keyword"];
            bool global = self.segment.selectedSegmentIndex == 1;
            [game setObject:[NSNumber numberWithBool:global] forKey:@"global"];
            [game saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(error == nil) {
                    NSMutableArray *saveables = [[NSMutableArray alloc] initWithCapacity:[objects count] + 1];
                    for (PFUser *friend in objects) {
                        [[game relationforKey:@"players"] addObject:friend];
                        PFObject *request = [PFObject objectWithClassName:@"Request"];
                        [request setObject:friend forKey:@"user"];
                        [request setObject:game forKey:@"game"];
                        [request setObject:[game objectForKey:@"keyword"] forKey:@"keyword"];
                        [request setObject:[[PFUser currentUser] username] forKey:@"creatorUsername"];
                        [request setObject:[PFUser currentUser]  forKey:@"creator"];
                        [saveables addObject:request];
                        [[[PFUser currentUser] relationforKey:@"friends"] addObject:friend];
                    }
                    [[[PFUser currentUser] relationforKey:@"games"] addObject:game];
                    [saveables addObject:[PFUser currentUser]];
                    [saveables addObject:game];
                    
                    NSData *data = UIImageJPEGRepresentation(self.image, 1);
                    
                    PFFile *file = [PFFile fileWithData:data];
                    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        PFObject *imgObj = [PFObject objectWithClassName:@"Image"];
                        
                        [imgObj setObject:file forKey:@"data"];
                        [imgObj setObject:[PFUser currentUser] forKey:@"user"];
                        [imgObj setObject:game forKey:@"game" ];
                        [game addObject:[PFUser currentUser] forKey:@"submittedPlayers"];
                        [[game relationforKey:@"players"] addObject:[PFUser currentUser]];
                        
                        [saveables addObject:imgObj];
                        [PFObject saveAllInBackground:saveables block:^(BOOL succeeded, NSError *error) {
                            //self.selectedGame = game;
                            [self sendPush:queryUsername withKeyword:[game objectForKey:@"keyword"]];
                            
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            [self.mainViewController selectTab:self.mainViewController.feedTab];
                        }];
                    } progressBlock:^(int percentDone) {
                        //code
                    }];
                }
            }];
        }
    }];
}

- (void)sendPush:(PFQuery *)query withKeyword:(NSString *) keyword {
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"deviceType" equalTo:@"ios"];
    [pushQuery whereKey:@"user" matchesQuery:query];
    
    // Send push notification to query
    [PFPush sendPushMessageToQueryInBackground:pushQuery
                                   withMessage:[NSString stringWithFormat:@"%@ sent you a request to backtag %@", [[PFUser currentUser] username], keyword]];
}
@end
