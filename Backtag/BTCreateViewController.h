//
//  BTCreateViewController.h
//  Backtag
//
//  Created by James George on 9/28/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BTMainViewController.h"

@interface BTCreateViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *keywordView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property (strong, nonatomic) IBOutlet UIButton *addPlayerButton;
@property (strong, nonatomic) IBOutlet UILabel *playersLabel;
- (IBAction)addPlayer:(id)sender;
- (IBAction)segmentChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)keywordChanged:(id)sender;

@property (nonatomic, weak) BTMainViewController *mainViewController;

@property(nonatomic, strong) UIImage *image;
@end
