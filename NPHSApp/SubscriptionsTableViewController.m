//
//  SubscriptionsTableViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 10/12/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "SubscriptionsTableViewController.h"
#import <Parse/Parse.h>
@interface SubscriptionsTableViewController ()
@property (strong, nonatomic) NSArray *subscriptions;
@property (nonatomic, retain) NSDictionary *sections;
@property PFInstallation *currentInstall;
@property NSString *clubRow;

@end

@implementation SubscriptionsTableViewController
@synthesize clubRow, currentInstall;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //self.parseClassName = @"User";
        self.paginationEnabled = NO;
        self.pullToRefreshEnabled = YES;
        
       
        
    }
    return self;
}
-(PFQuery *)queryForTable
{
    PFQuery *clubs = [PFUser query];
    return clubs;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{

    PFInstallation *install = [PFInstallation currentInstallation];
    NSArray *currentChannels = install.channels;
    
    static NSString *CellIdentifier = @"Clubs";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    clubRow = [object objectForKey:@"username"];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor yellowColor];
    cell.detailTextLabel.textColor = [UIColor redColor];
    cell.detailTextLabel.text = @"Not subscribed";
    cell.userInteractionEnabled = YES;
    cell.textLabel.text = clubRow;
    if([(NSString *)[currentChannels objectAtIndex:indexPath.row] isEqualToString:clubRow])
    {
    cell.detailTextLabel.text = @"Subscribed";
    
   
    cell.detailTextLabel.textColor = [UIColor greenColor];
   
    }
    else
    {
        
    }
    NSString *fag = (NSString *)[currentChannels objectAtIndex:indexPath.row];
    NSLog(@"%@", fag);
                     
   
   
    return cell;
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:cell.textLabel.text forKey:@"channels"];
    
    [currentInstallation saveInBackground];
    NSLog(@"%@", currentInstallation.channels);
    cell.selected = NO;
   // [currentInstallation refresh];
}

@end
