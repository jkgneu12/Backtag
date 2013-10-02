//
//  BTFeedViewController.m
//  Backtag
//
//  Created by James George on 9/28/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import "BTFeedViewController.h"
#import "UIImage+ImageEffects.h"

#import <Parse/Parse.h>

@interface BTFeedViewController ()
{
    NSMutableArray *_images;
}

@end

@implementation BTFeedViewController

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
    
    [self refreshGamesList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

}

- (void) refreshGamesList{
    PFQuery *userQuery = [[[PFUser currentUser] relationforKey:@"games"] query];
    
    PFQuery *imageQuery = [PFQuery queryWithClassName:@"Image"];
    [imageQuery whereKey:@"game" matchesQuery:userQuery];
    
    [imageQuery orderByDescending:@"createdAt"];
    [imageQuery includeKey:@"user"];
    //[imageQuery includeKey:@"votedPlayers"];
    [imageQuery includeKey:@"game"];
    [imageQuery includeKey:@"comments"];
    [imageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error){
            _images = [[NSMutableArray alloc] initWithArray:objects];
            
            
            
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_images count] + 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0) {
        return 65;
    }
    if(indexPath.row == [_images count] + 1) {
        return 50;
    }
    return 420;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 65)];
    }
    if(indexPath.row == [_images count] + 1){
        return [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
    
    if(cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BTFeedCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
//    if([_images count] > 0 && indexPath.row == [_images count] - 1){
//        [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, 420 + 65)];
//    }
//    
    UIImageView *image = [cell viewWithTag:1];
//    //        PicBorderLabel *label = [cell viewWithTag:2];
//    //        label.outlineWidth = 2.5;
//    //        label.outlineColor = [UIColor blackColor];
    UILabel *label = [cell viewWithTag:2];

//    //UIImageView *tagImage = [cell viewWithTag:3];
    UILabel *userName = [cell viewWithTag:3];
//    UILabel *date = [cell viewWithTag:6];
//    
//    //245, 146, 93
//    //        [image.layer setBorderColor:[UIColor colorWithRed:245/255.0 green:146/255.0 blue:93/255.0 alpha:1.0].CGColor];
//    //        [image.layer setBorderWidth:6.0];
//    
    PFObject *imgObj = [_images objectAtIndex:indexPath.row - 1];
    PFObject *game = [imgObj objectForKey:@"game"];
//    
//    int timePast = -[[game createdAt] timeIntervalSinceNow];
//    
//   // [date setText:[self formatDateString:timePast]];
//    
    NSMutableAttributedString *attributedString;
    attributedString = [[NSMutableAttributedString alloc] initWithString:[game objectForKey:@"keyword"]];
//     [attributedString addAttribute:NSKernAttributeName value:@2 range:NSMakeRange(0, [attributedString length])];
//    
    label.attributedText = attributedString;
    userName.text = [[imgObj objectForKey:@"user"] objectForKey:@"username"];
//    
//    //[self rotateLabel:label andImage:tagImage];
//    
    PFFile *imgFile = [imgObj valueForKey:@"data"];
    [imgFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(error == nil){
            [image setImage:[UIImage imageWithData: data]];
            
            UIImageView *blurredTopImage = [cell viewWithTag:100];
            UIImageView *blurredBottomImage = [cell viewWithTag:101];
            
            UIImage *croppedTopImg = [self cropImage:image.image toFrame:blurredTopImage.frame];
            CGRect f = blurredTopImage.frame;
            f.origin.y = image.image.size.height - 35;
            UIImage *croppedBottomImg = [self cropImage:image.image toFrame:f];
            
            croppedTopImg = [croppedTopImg applyExtraLightEffect];
            croppedBottomImg = [croppedBottomImg applyExtraLightEffect];

            [blurredTopImage setImage:croppedTopImg];
            [blurredBottomImage setImage:croppedBottomImg];
        }
    } progressBlock:^(int percentDone) {
        //c
    }];
    
//    //[self addCommentsToCell:cell forImage:imgObj];
    
    return cell;
}

- (UIImage *) cropImage:(UIImage *) image toFrame:(CGRect)frame {
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], frame);
    UIImage *croppedImg = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImg;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




@end
