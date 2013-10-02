//
//  BTProfileViewController.m
//  Backtag
//
//  Created by James George on 9/25/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import "BTProfileViewController.h"

#import <Parse/Parse.h>

@interface BTProfileViewController ()

@end

@implementation BTProfileViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self setupPicture];
    [self setupUsername];
    [self setupPoints];
    [self setupLinkFacebookButton];
    [self setupLinkTwitterButton];
}

- (void)setupUsername
{
    [self.usernameView setText:[[PFUser currentUser] username]];
}

- (void)setupPoints
{
    [self.pointsView setText:[NSString stringWithFormat:@"%@ points", [[PFUser currentUser] objectForKey:@"points"]]];
}

- (void)setupPicture
{
    NSString *linkedPicutre = [[PFUser currentUser] objectForKey:@"linkedProfilePicture"];
    if([@"twitter" isEqualToString:linkedPicutre] && [PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSURL *url = [NSURL URLWithString:[@"http://api.twitter.com/1.1/users/show.json?screen_name=" stringByAppendingString:[[PFUser currentUser] objectForKey:@"twitterId"]]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [[PFTwitterUtils twitter] signRequest:request];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if(error == nil){
                NSDictionary *user =
                [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingAllowFragments
                                                  error:NULL];
                
                NSString *profileImageUrl = [user objectForKey:@"profile_image_url"];
                
                //  As an example we could set an image's content to the image
                dispatch_async
                (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *imageData =
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString:profileImageUrl]];
                    
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.profilePicture.image = image;
                    });
                });
            }
        }];
        
    }

}

- (void)setupLinkFacebookButton
{
    if([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        [self.linkFacebookButton setTitle:@"Unlink Facebook" forState:UIControlStateNormal];
    } else {
        [self.linkFacebookButton setTitle:@"Link Facebook" forState:UIControlStateNormal];
    }
}

- (void)setupLinkTwitterButton
{
    if([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]){
        [self.linkTwitterButton setTitle:@"Unlink Twitter" forState:UIControlStateNormal];
    } else {
        [self.linkTwitterButton setTitle:@"Link Twitter" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)linkFacebook:(id)sender {
    if([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
            [self setupLinkFacebookButton];
        }];
    } else {
        [PFFacebookUtils linkUser:[PFUser currentUser] permissions:nil block:^(BOOL succeeded, NSError *error) {
            [self setupLinkFacebookButton];
        }];
    }
}

- (IBAction)linkTwitter:(id)sender {
    if([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]){
        [PFTwitterUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
            [self setupLinkTwitterButton];
        }];
    } else {
        [PFTwitterUtils linkUser:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
            [self setupLinkTwitterButton];
        }];
    }
}
@end
