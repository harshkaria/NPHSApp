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
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor yellowColor]};
    people = [[NSMutableArray alloc] initWithObjects:@"Harsh Karia", @"Michael Weingarden", @"Claire Monro", @"Matthew Mangawang", @"😍 James Lin", @"Victoria Juan", @"👳 Adam Aziz", @"👨 Ernesto Ambrocio", @"😍 Suraj Palaparty",  nil];
    
    
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
    
    static NSString *cellIdentifier = @"Person";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    

    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.text = [people objectAtIndex:indexPath.row];
    
    cell.textLabel.textColor = [UIColor yellowColor];
    cell.detailTextLabel.text = @"Team Member";
    //cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.textColor = [UIColor yellowColor];
    //[[cell appearance]setBackgroundColor:[UIColor blackColor]];
    
    
    //tableView.userInteractionEnabled = YES;
    if([cell.textLabel.text isEqualToString:@"Harsh Karia"])
    {
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.text = @"Team Leader and Lead Developer. Overlord.";
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        
        
    }
    if([cell.textLabel.text isEqualToString:@"Michael Weingarden"])
    {
        cell.detailTextLabel.text = @"Advisor";
        
    }
    if([cell.textLabel.text isEqualToString:@"👳 Adam Aziz"])
    {
        cell.detailTextLabel.text = @"ISIS Affiliate";
    }
    if([cell.textLabel.text isEqualToString:@"👨 Ernesto Ambrocio"])
    {
        cell.detailTextLabel.text = @"Cartel Affiliate";
    }
    if([cell.textLabel.text isEqualToString:@"😍 Suraj Palaparty"])
    {
        cell.detailTextLabel.text = @"Bae";
    }
    if([cell.textLabel.text isEqualToString:@"😍 James Lin"])
    {
        cell.detailTextLabel.text = @"Soulmate";
    }
    
    cell.userInteractionEnabled = NO;
       return cell;
}

@end
