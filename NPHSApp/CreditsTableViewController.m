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
   
    people = [[NSMutableArray alloc] initWithObjects:@"Harsh Karia", @"Michael Weingarden", @"Claire Monro & Matthew Mangawang",  nil];
    
    
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
    

    
    cell.creditLabel.textAlignment = NSTextAlignmentCenter;
    cell.creditLabel.text = [people objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor blackColor];
    
    cell.creditLabel.textColor = [UIColor yellowColor];
    cell.biography.text = @"Team Member";
    //cell.creditLabel.textAlignment = NSTextAlignmentRight;
    //cell.biography = [UIColor yellowColor];
    //[[cell appearance]setBackgroundColor:[UIColor blackColor]];
    
    
    //tableView.userInteractionEnabled = YES;
    if([cell.creditLabel.text isEqualToString:@"Harsh Karia"])
    {
        //cell.backgroundColor = [UIColor blackColor];
        //cell.creditLabel.textColor = [UIColor whiteColor];
        cell.biography.text = @"Team Leader and Lead Developer. Overlord.";
        //cell.biography.t = [UIColor whiteColor];
        
        
    }
    if([cell.creditLabel.text isEqualToString:@"Michael Weingarden"])
    {
        cell.biography.text = @"Advisor";
        
    }
    if([cell.creditLabel.text isEqualToString:@"Claire Monro & Matthew Mangawang"])
    {
         cell.biography.text = @"Publicity and Operations";
    }
   
    
    cell.userInteractionEnabled = NO;
       return cell;
}

@end
