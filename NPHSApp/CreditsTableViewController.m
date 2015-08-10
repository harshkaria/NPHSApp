//
//  CreditsTableViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 10/12/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "CreditsTableViewController.h"
#import "CreditsCell.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "PersonViewController.h"
@interface CreditsTableViewController ()
@property NSArray *people;
@property PFQuery *credits;
@property NSInteger count;
@property NSString *person;
@end

@implementation CreditsTableViewController
@synthesize people, credits, count, person;
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
    people = [[NSArray alloc] init];
    

    
    
}
-(PFQuery *)queryForTable
{
    credits = [PFQuery queryWithClassName:@"credits"];
    [credits orderByAscending:@"number"];
    return credits;
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



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{

    tableView.scrollEnabled = YES;
    tableView.backgroundColor = [UIColor blackColor];
    tableView.bounces = YES;
    tableView.userInteractionEnabled = YES;
    CreditsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Credits" forIndexPath:indexPath];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    //cell.creditLabel.textAlignment = NSTextAlignmentCenter;
    cell.creditLabel.text = object[@"name"];
    cell.creditLabel.textAlignment = NSTextAlignmentCenter;
    cell.object = object;
    person = cell.creditLabel.text;
   // cell.biography.text = object[@"bio"];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreditsCell *cell = (CreditsCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"Person" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Person"])
    {
        PersonViewController *personVC = segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        CreditsCell *cell = (CreditsCell *)[self.tableView cellForRowAtIndexPath:path];
        personVC.name = cell.creditLabel.text;
        personVC.personObject = cell.object;
    }
    
}

@end
