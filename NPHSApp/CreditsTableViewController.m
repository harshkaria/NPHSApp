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
@interface CreditsTableViewController ()
@property NSMutableArray *people;
@end

@implementation CreditsTableViewController
@synthesize people;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    people = [[NSMutableArray alloc] initWithObjects:@"Harsh Karia", @"Matthew Mangawang", @"Claire Monro", @"Suraj Palaparty", @"Ernesto Ambrocio", @"Victoria Juan", @"Michael Weingarden",  nil];
    
    
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
    return [people count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.scrollEnabled = YES;
    tableView.bounces = YES;
    tableView.userInteractionEnabled = YES;
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:VIEW_BG]];
    CreditsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Credits" forIndexPath:indexPath];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    

    
    //cell.creditLabel.textAlignment = NSTextAlignmentCenter;
    cell.creditLabel.text = [people objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor blackColor];
    
    cell.creditLabel.textColor = [UIColor yellowColor];
    cell.biography.text = @"General Operations. Responible for assisting with execution & strategy, quality control, and beta testing.";
    //cell.creditLabel.textAlignment = NSTextAlignmentRight;
    //cell.biography = [UIColor yellowColor];
    //[[cell appearance]setBackgroundColor:[UIColor blackColor]];
    
    
    //tableView.userInteractionEnabled = YES;
    if([cell.creditLabel.text isEqualToString:@"Harsh Karia"])
    {
        //cell.backgroundColor = [UIColor blackColor];
        //cell.creditLabel.textColor = [UIColor whiteColor];
        cell.biography.text = @"Team Leader and Lead Developer. President of App Club. Responsible for development, general strategy, and execution.";
        //cell.biography.t = [UIColor whiteColor];
        
        
    }
    if([cell.creditLabel.text isEqualToString:@"Michael Weingarden"])
    {
        cell.biography.text = @"Teacher Advisor to App Club.";
        
    }
    if([cell.creditLabel.text isEqualToString:@"Matthew Mangawang"])
    {
         cell.biography.text = @"Leader: Operations and Publicity. Responsible for planning and coordinating general strategy, managing promotional content, creating the icon, and beta testing.";
    }
    if([cell.creditLabel.text isEqualToString:@"Claire Monro"])
    {
        cell.biography.text = @"Leader: Operations and Publicity. Responsible for coordinating general strategy, managing promotional content, the creation and successful execution of promotional strategy, and user engagement.";
    }
    
    cell.userInteractionEnabled = NO;
       return cell;
}

@end
