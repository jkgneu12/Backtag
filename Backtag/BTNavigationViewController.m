//
//  BTNavigationViewController.m
//  Backtag
//
//  Created by James George on 9/25/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import "BTNavigationViewController.h"
#import "BTLoginViewController.h"

@interface BTNavigationViewController ()

@end

@implementation BTNavigationViewController

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

    
    BTLoginViewController *screen = [[BTLoginViewController alloc] initWithNibName:@"BTLoginViewController" bundle:nil];
    screen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self pushViewController:screen animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
