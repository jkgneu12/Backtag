//
//  BTPlayersViewController.h
//  Backtag
//
//  Created by James George on 9/28/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTPlayersViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *buttonBackground;
- (IBAction)findFacebookFriends:(id)sender;
- (IBAction)findTwitterFriends:(id)sender;

@end
