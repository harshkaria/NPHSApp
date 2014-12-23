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

@interface FeedController ()
@property NSMutableArray *clubNames;
@property NSMutableArray *clubText;
@end

@implementation FeedController
@synthesize  clubNames, clubText;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    
    clubNames = [[NSMutableArray alloc] initWithObjects:@"App Club", @"ASG", @"Interact", @"Interact",  nil];
    clubText = [[NSMutableArray alloc]initWithObjects:@"You have a meeting next Friday", @"Remember to show up to ASG on Thanksgiving day", @"You have a Fundraiser coming up on Saturday", @"We have a guest speaker at lunch on Monday, so be there!", nil];
     self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor yellowColor]};
    
}
-(void)hideMe
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [clubNames count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feed" forIndexPath:indexPath];
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:VIEW_BG]];
    
    
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UIImageView *cellBG = [[UIImageView alloc] initWithFrame:cell.feedView.bounds];
    cellBG.image = [UIImage imageNamed:VIEW_BG];
    
    
    
    cell.clubName.text = [clubNames objectAtIndex:indexPath.row];
    cell.clubText.text = [clubText objectAtIndex:indexPath.row];
    
    cellBG.alpha = 0.4;
    cell.clubName.alpha = 1;
    cell.clubText.alpha = 1;
    [cell.feedView addSubview:cellBG];
    [cell.feedView addSubview:cell.clubName];
    [cell.feedView addSubview:cell.clubText];
    cellBG.userInteractionEnabled = NO;
    cell.userInteractionEnabled = NO;
    return cell;
    
}

@end
