//
//  CreditsTableViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 10/12/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "CreditsTableViewController.h"

@interface CreditsTableViewController ()
@property NSMutableArray *people;
@end

@implementation CreditsTableViewController
@synthesize people;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    people = [[NSMutableArray alloc] initWithObjects:@"Harsh Karia", @"Michael Weingarden", @"Claire Monro", @"Matthew Mangawang", @"James Lin", @"Victoria Juan", @"👳 Adam Aziz", nil];
    
    
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
    static NSString *cellIdentifier = @"Person";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];

    tableView.userInteractionEnabled = NO;
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.text = [people objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor yellowColor];
    cell.detailTextLabel.text = @"Team Members";
    //cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.textColor = [UIColor yellowColor];
    //[[cell appearance]setBackgroundColor:[UIColor blackColor]];
    
    if([cell.textLabel.text isEqualToString:@"Harsh Karia"])
    {
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.text = @"Main Developer";
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        
        
    }
    if([cell.textLabel.text isEqualToString:@"Michael Weingarden"])
    {
        cell.detailTextLabel.text = @"Advisor";
        
    }
       return cell;
}


@end
