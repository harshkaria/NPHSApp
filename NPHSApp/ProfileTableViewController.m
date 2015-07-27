//
//  ProfileTableViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 7/26/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ProfileCell.h"
#import "UIScrollView+EmptyDataSet.h"
@interface ProfileTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation ProfileTableViewController
@synthesize dogTag;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.parseClassName = @"Comments";
        self.paginationEnabled = NO;
        self.pullToRefreshEnabled = YES;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = dogTag;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"dogTag" equalTo:dogTag];
    [query orderByDescending:@"createdAt"];
    return query;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
   ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Comment"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   cell.topicName.text = object[@"topic"];
   cell.commentText.text = object[@"text"];
    
    return cell;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"This user has no Beeps yet.";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}




@end
