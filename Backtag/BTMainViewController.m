//
//  BTMainViewController.m
//  Backtag
//
//  Created by James George on 9/28/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import "BTMainViewController.h"

#import "BTFeedViewController.h"
#import "BTExploreViewController.h"
#import "BTPlayViewController.h"
#import "BTFriendsViewController.h"
#import "BTProfileViewController.h"

@interface BTMainViewController () {
    UITabBarItem *_selectedItem;
    
    BTSubViewController *_currentViewController;
    BTFeedViewController *_feedViewController;
    BTExploreViewController *_exploreViewController;
    BTPlayViewController *_playViewController;
    BTFriendsViewController *_friendsViewController;
    BTProfileViewController *_meViewController;
}

@end

@implementation BTMainViewController

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
    
    [self selectTab:self.feedTab];

}

-(void)selectTab:(UITabBarItem *)tab
{
    [self.tabBar setSelectedItem:tab];
    [self tabBar:self.tabBar didSelectItem:tab];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item == _selectedItem) {
        return;
    }
    
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = nil;
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = nil;
    
    if(item == self.feedTab) {
        if(_feedViewController == nil) {
            _feedViewController = [[BTFeedViewController alloc] initWithNibName:@"BTFeedViewController" bundle:nil];
        } else {
            [_feedViewController viewDidAppear:NO];
        }
        _currentViewController = _feedViewController;
    }
    else if(item == self.exploreTab) {
        if(_exploreViewController == nil) {
            _exploreViewController = [[BTExploreViewController alloc] initWithNibName:@"BTExploreViewController" bundle:nil];
        } else {
            [_exploreViewController viewDidAppear:NO];
        }
        _currentViewController = _exploreViewController;
    }
    else if(item == self.playTab) {
        if(_playViewController == nil) {
            _playViewController = [[BTPlayViewController alloc] initWithNibName:@"BTPlayViewController" bundle:nil];
        } else {
            [_playViewController viewDidAppear:NO];
        }
        _currentViewController = _playViewController;
    }
    else if(item == self.friendsTab) {
        if(_friendsViewController == nil) {
            _friendsViewController = [[BTFriendsViewController alloc] initWithNibName:@"BTFriendsViewController" bundle:nil];
        } else {
            [_friendsViewController viewDidAppear:NO];
        }
        _currentViewController = _friendsViewController;
    }
    else if(item == self.meTab) {
        if(_meViewController == nil) {
            _meViewController = [[BTProfileViewController alloc] initWithNibName:@"BTProfileViewController" bundle:nil];
        } else {
            [_meViewController viewDidAppear:NO];
        }
        _currentViewController = _meViewController;
    }
    
    [_currentViewController.view setFrame:CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height)];
    
    _currentViewController.mainViewController = self;
    
    [self.mainView addSubview:_currentViewController.view];

    
    _selectedItem = item;
}

@end
