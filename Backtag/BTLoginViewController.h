//
//  BTLoginViewController.h
//  Backtag
//
//  Created by James George on 9/25/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTLoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *usernameView;

- (IBAction)facebookLogin:(id)sender;

@end
