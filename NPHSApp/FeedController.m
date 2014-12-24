//
//  FeedController.m
//  NPHSApp
//
//  Created by Harsh Karia on 11/23/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "FeedController.h"
#import "FeedCell.h"
#import "SplashViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface FeedController ()
@property NSMutableArray *clubNames;
@property NSMutableArray *clubText;
@property NSInteger count;
@end

@implementation FeedController
@synthesize  clubNames, clubText, count;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //self.parseClassName = @"User";
        self.paginationEnabled = NO;
        self.pullToRefreshEnabled = YES;
        //self.count = 0;
        
        
        
    }
    return self;
}
- (void)viewDidLoad {
    
    
[super viewDidLoad];
    
}

-(PFQuery *)queryForTable
{
    PFInstallation *installation = [PFInstallation currentInstallation];
    
    PFQuery *query = [PFQuery queryWithClassName:@"feed"];
    [query whereKey:@"clubName" containedIn:installation.channels];
    [query orderByDescending:@"createdAt"];
    return query;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
#warning Potentially incomplete method implementation.
    
    // Return the number of sections.
    
    return 1;
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(FeedCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Feed" forIndexPath:indexPath];
    
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:VIEW_BG]];
    
    UIImageView *cellBG = [[UIImageView alloc] initWithFrame:cell.feedView.bounds];
    
    cellBG.image = [UIImage imageNamed:NAV_BG];
    
    cellBG.alpha = 0.4;
    
    [cell.feedView addSubview:cellBG];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{

    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feed" forIndexPath:indexPath];
    
    
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UIImageView *cellBG = [[UIImageView alloc] initWithFrame:cell.feedView.bounds];
    
    cellBG.image = [UIImage imageNamed:NAV_BG];
    
    cellBG.alpha = 0.4;
    
    [cell.feedView addSubview:cellBG];
    
    
    
    cell.clubName.text = [object objectForKey:@"clubName"];
    
    cell.clubText.text = [object objectForKey:@"feedPost"];
    
    cell.clubName.alpha = 1;
    
    cell.clubText.alpha = 1;
    
    [cell.feedView addSubview:cell.clubName];
    
    [cell.feedView addSubview:cell.clubText];
    
    
    
    cell.userInteractionEnabled = NO;
    
    return cell;
    
    
    
}
@end
