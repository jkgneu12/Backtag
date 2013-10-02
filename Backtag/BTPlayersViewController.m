//
//  BTPlayersViewController.m
//  Backtag
//
//  Created by James George on 9/28/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import "BTPlayersViewController.h"

#import "UIImage+ImageEffects.h"

#import <Parse/Parse.h>

@interface BTPlayersViewController ()
{
     NSMutableArray *_friendsList;    
}

@end

@implementation BTPlayersViewController

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
    
    self.buttonBackground.image = [self.buttonBackground.image applyLightEffect];
    
    [self reloadFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadFriends
{
    PFQuery *query = [[[PFUser currentUser] relationforKey:@"friends"] query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error == nil) {
            _friendsList = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_friendsList count] + 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0) {
        return 200;
    }
    if(indexPath.row == [_friendsList count] + 1) {
        return 50;
    }
    return 80;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 200)];
    }
    if(indexPath.row == [_friendsList count] + 1){
        return [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    
    if(cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BTFriendCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    UIImageView *picture = [cell viewWithTag:1];
    UILabel *name = [cell viewWithTag:2];
    UILabel *points = [cell viewWithTag:3];
    
    PFUser *friend = [_friendsList objectAtIndex:indexPath.row - 1];
    
    [name setText:[friend username]];
    [points setText:[NSString stringWithFormat:@"%@ points", [friend objectForKey:@"points"]]];
    
    return cell;
}

- (UIImage *) cropImage:(UIImage *) image toFrame:(CGRect)frame {
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], frame);
    UIImage *croppedImg = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImg;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (IBAction)findFacebookFriends:(id)sender {
}

- (IBAction)findTwitterFriends:(id)sender {
}
@end
