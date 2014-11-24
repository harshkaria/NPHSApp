//
//  FeedController.m
//  NPHSApp
//
//  Created by Harsh Karia on 11/23/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "FeedController.h"
#import "FeedCell.h"
#import "AppDelegate.h"
@interface FeedController ()
@property NSMutableArray *clubNames;
@property NSMutableArray *clubText;
@end

@implementation FeedController
@synthesize  clubNames, clubText;
- (void)viewDidLoad {
    [super viewDidLoad];
 
    clubNames = [[NSMutableArray alloc] initWithObjects:@"App Club", @"ASG",  nil];
    clubText = [[NSMutableArray alloc]initWithObjects:@"You have a meeting next Friday", @"Remember to show up to ASG on Thanksgiving day", nil];
     self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor yellowColor]};
    
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
    FeedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Feed" forIndexPath:indexPath];
    
    cell.clubName.text = [clubNames objectAtIndex:indexPath.row];
    cell.clubText.text = [clubText objectAtIndex:indexPath.row];
    cell.userInteractionEnabled = NO;
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:VIEW_BG]];
    return cell;
}

@end
