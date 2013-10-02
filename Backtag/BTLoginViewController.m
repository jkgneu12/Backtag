//
//  BTLoginViewController.m
//  Backtag
//
//  Created by James George on 9/25/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import "BTLoginViewController.h"
#import "BTMainViewController.h"

#import <Parse/Parse.h>

@interface BTLoginViewController (){
    UIAlertView *facebookAlertView;
}

@end

@implementation BTLoginViewController

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
    
    //TODO: remake image to have transparent background
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headerboards"] forBarMetrics:UIBarMetricsDefault];
    
    if([PFUser currentUser] != nil ) {
        [self navigateToMain];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)facebookLogin:(id)sender {
    [PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
        if(error == nil){
            [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
            [[PFInstallation currentInstallation] saveEventually];
            
            if ([user objectForKey:@"displayName"] == nil) {
                if([self.usernameView text].length == 0) {
                    facebookAlertView = [[UIAlertView alloc] initWithTitle:@"No Username" message:@"Enter a username:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                    facebookAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                    [facebookAlertView show];
                } else {
                    [self setNewFacebookUsername];
                }
                
            } else {
                [self navigateToMain];
            }
        }
    }];
}

- (void)setNewFacebookUsername {
    [[PFUser currentUser] setUsername:[self.usernameView text]];
    [[PFUser currentUser] setObject:[self.usernameView text] forKey:@"displayName"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error == nil){
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary *result, NSError *error) {
                if(error == nil) {
                    [[PFUser currentUser] setObject:[result objectForKey:@"id"] forKey:@"facebookId"];
                    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(error == nil)
                            [self navigateToMain];
                    }];
                }
            }];
        }
        
    }];
}

-(void)navigateToMain {
    BTMainViewController *view = [[BTMainViewController alloc] initWithNibName:@"BTMainViewController" bundle:nil];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[[self navigationController] viewControllers]];
    [viewControllers removeLastObject];
    [viewControllers addObject:view];
    [[self navigationController] setViewControllers:viewControllers animated:YES];
}
@end
