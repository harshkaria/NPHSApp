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
        ;
       
        
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
   
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
    //UITableViewCell *cellClub = [tableView cellForRowAtIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    cell.backgroundColor = [UIColor blackColor];

    
    cell.textLabel.text = [object objectForKey:@"username"];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    
    return cell;
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFInstallation *myInstall = [PFInstallation currentInstallation];
    
   // [currentInstallation refresh];
}

@end
