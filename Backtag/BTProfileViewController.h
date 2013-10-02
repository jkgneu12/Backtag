//
//  BTProfileViewController.h
//  Backtag
//
//  Created by James George on 9/25/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BTSubViewController.h"

@interface BTProfileViewController : BTSubViewController
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *usernameView;
@property (strong, nonatomic) IBOutlet UILabel *pointsView;
@property (strong, nonatomic) IBOutlet UIButton *linkFacebookButton;
@property (strong, nonatomic) IBOutlet UIButton *linkTwitterButton;


- (IBAction)linkFacebook:(id)sender;
- (IBAction)linkTwitter:(id)sender;

@end
