//
//  BTExploreViewController.h
//  Backtag
//
//  Created by James George on 9/28/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BTSubViewController.h"

@interface BTExploreViewController : BTSubViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;

- (IBAction)segmentChanged:(id)sender;

@end
