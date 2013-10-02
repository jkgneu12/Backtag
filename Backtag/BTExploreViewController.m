//
//  BTExploreViewController.m
//  Backtag
//
//  Created by James George on 9/28/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import "BTExploreViewController.h"

#import <Parse/Parse.h>

@interface BTExploreViewController ()
{
    NSMutableArray *_popular;
    NSMutableArray *_friends;
    NSMutableArray *_new;
    
    enum {
        kPopular = 0,
        kFriends = 1,
        kNew = 2
    } Section;
}

@end

@implementation BTExploreViewController

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
    
    [self refreshPopularList];
}

- (void) refreshPopularList{
    
    PFQuery *gameQuery = [PFQuery queryWithClassName:@"Game"];
    [gameQuery whereKey:@"createdAt" greaterThan:[NSDate dateWithTimeIntervalSinceNow:-(60*60*24)]];
    [gameQuery whereKey:@"global" equalTo:[NSNumber numberWithBool:YES]];
    [gameQuery orderByDescending:@"numPhotos"];
    [gameQuery includeKey:@"creator"];
    [gameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error){
            _popular = [[NSMutableArray alloc] initWithArray:objects];
            
            [self.tableView reloadData];
        }
    }];
}

- (void) refreshFriendsList{
    
    PFQuery *gameQuery = [PFQuery queryWithClassName:@"Game"];
    [gameQuery whereKey:@"createdAt" greaterThan:[NSDate dateWithTimeIntervalSinceNow:-(60*60*24)]];
    [gameQuery whereKey:@"global" equalTo:[NSNumber numberWithBool:YES]];
    [gameQuery orderByAscending:@"createdAt"];
    [gameQuery includeKey:@"creator"];
    [gameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error){
            _friends = [[NSMutableArray alloc] initWithArray:objects];
            
            [self.tableView reloadData];
        }
    }];
}

- (void) refreshNewList{
    
    PFQuery *gameQuery = [PFQuery queryWithClassName:@"Game"];
    [gameQuery whereKey:@"createdAt" greaterThan:[NSDate dateWithTimeIntervalSinceNow:-(60*60*24)]];
    [gameQuery whereKey:@"global" equalTo:[NSNumber numberWithBool:YES]];
    [gameQuery orderByDescending:@"createdAt"];
    [gameQuery includeKey:@"creator"];
    [gameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error){
            _new = [[NSMutableArray alloc] initWithArray:objects];
            
            [self.tableView reloadData];
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self arrayForSegment] count] + 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0) {
        return 200;
    }
    if(indexPath.row == [[self arrayForSegment] count] + 1) {
        return 50;
    }
    return 80;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 65)];
    }
    if(indexPath.row == [[self arrayForSegment] count] + 1){
        return [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExploreCell"];
    
    if(cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BTExploreCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    UILabel *gameName = [cell viewWithTag:1];
    UILabel *gameName = [cell viewWithTag:1];
    
    PFObject *game = [[self arrayForSegment] objectAtIndex:indexPath.row - 1];
    
    [gameName setText:[game objectForKey:@"keyword"]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSMutableArray *)arrayForSegment
{
    switch ([self.segment selectedSegmentIndex]) {
        case kPopular:
            return _popular;
        case kFriends:
            return _friends;
        case kNew:
            return _new;
            
        default:
            return nil;
    }
}

- (void)refreshListForSegment
{
    switch ([self.segment selectedSegmentIndex]) {
        case kPopular:
            [self refreshPopularList];
            break;
        case kFriends:
            [self refreshFriendsList];
            break;
        case kNew:
            [self refreshNewList];
            break;
            
        default:
            break;
    }
}


- (IBAction)segmentChanged:(id)sender {
    if([self arrayForSegment] == nil){
        [self refreshListForSegment];
    } else {
        [self.tableView reloadData];
    }
}
@end
