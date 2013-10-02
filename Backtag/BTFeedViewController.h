//
//  BTFeedViewController.h
//  Backtag
//
//  Created by James George on 9/28/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BTSubViewController.h"

@interface BTFeedViewController : BTSubViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
