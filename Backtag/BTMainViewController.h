//
//  BTMainViewController.h
//  Backtag
//
//  Created by James George on 9/28/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTMainViewController : UIViewController<UITabBarDelegate>

@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) IBOutlet UITabBarItem *feedTab;
@property (strong, nonatomic) IBOutlet UITabBarItem *exploreTab;
@property (strong, nonatomic) IBOutlet UITabBarItem *playTab;
@property (strong, nonatomic) IBOutlet UITabBarItem *friendsTab;
@property (strong, nonatomic) IBOutlet UITabBarItem *meTab;


@property (strong, nonatomic) IBOutlet UIView *mainView;

-(void)selectTab:(UITabBarItem *)tab;

@end
