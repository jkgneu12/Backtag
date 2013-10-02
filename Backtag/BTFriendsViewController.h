//
//  BTFriendsViewController.h
//  Backtag
//
//  Created by James George on 9/28/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BTSubViewController.h"

@interface BTFriendsViewController : BTSubViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIImageView *buttonBackground;


- (IBAction)findFacebookFriends:(id)sender;
- (IBAction)findTwitterFriends:(id)sender;

@end