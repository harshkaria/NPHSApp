//
//  SubscriptionsTableViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 10/12/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "SubscriptionsTableViewController.h"
#import "SubscriptionsCell.h"
#import "AppDelegate.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
@interface SubscriptionsTableViewController ()
@property (strong, nonatomic) NSArray *subscriptions;
@property (nonatomic, retain) NSDictionary *sections;
@property PFInstallation *currentInstall;
@property NSString *clubRow;
@property NSInteger count;
@property UISwitch *onOff;

@end

@implementation SubscriptionsTableViewController
@synthesize clubRow, currentInstall, onOff;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //self.parseClassName = @"User";
        self.paginationEnabled = NO;
        self.pullToRefreshEnabled = YES;
        self.count = 0;
      
        
        
    }
    return self;
}

-(void)viewDidLoad
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor yellowColor];
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [super viewDidLoad];
       
    
}
-(PFQuery *)queryForTable
{
    
    PFQuery *clubs = [PFUser query];
    self.count = [clubs countObjects];
    
    return clubs;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor yellowColor];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    UIImage *background = [UIImage imageNamed:@"nphs2.jpg"];
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:VIEW_BG]];

    PFInstallation *install = [PFInstallation currentInstallation];
    NSArray *currentChannels = install.channels;
    static NSString *CellIdentifier = @"Clubs";
    
    SubscriptionsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor blackColor];
    
  
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.clubLabel.text = [object objectForKey:@"clubName"];
    cell.clubLabel.font = [UIFont fontWithName:@"HelveticaStrong" size:20];
    cell.clubLabel.textColor = [UIColor whiteColor];
    cell.username = [object objectForKey:@"username"];
    
    
    // ADD ON OFF SWITCH
    self.onOff = [[UISwitch alloc]initWithFrame:CGRectZero];
    cell.accessoryView = onOff;
    onOff.tintColor = [UIColor whiteColor];
    onOff.thumbTintColor = [UIColor redColor];
    //onOff.backgroundColor = [UIColor whiteColor];
    [onOff addTarget:self action:@selector(actioned:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:onOff];
    
    
    [cell.contentView addSubview:cell.clubLabel];
    [cell.contentView addSubview:self.onOff];
    if([currentChannels containsObject:cell.username])
    {
        [self setOn];
        
        
        
    }
    if([cell.username isEqualToString:@"asg"] || [cell.username isEqualToString:@"admin"] || [cell.username isEqualToString:@"prowler"])
    {
        
        [self setOn];
        //[self.onOff setUserInteractionEnabled:NO];
        [self.onOff setEnabled:NO];
    }
    
    
    return cell;
   
}
-(void)setOn
{
    [onOff setOnTintColor:[UIColor blackColor]];
    [onOff setThumbTintColor:[UIColor yellowColor]];
    [self.onOff setOn:YES];

}


/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath sender:(id)sender
{
    
    PFInstallation *myInstall = [PFInstallation currentInstallation];
    if((onOff.isOn))
    {
        SubscriptionsCell *cell = (SubscriptionsCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"%ld", cell.clubLabel.text);
       
       

        
    }
    
   // [currentInstallation refresh];
}*/
-(void)actioned:(id)sender
{
    PFInstallation *myInstall = [PFInstallation currentInstallation];
    UISwitch *mySwitch = (UISwitch *)sender;
    SubscriptionsCell * cell = (SubscriptionsCell*) mySwitch.superview;
    
    
   if(!([myInstall.channels containsObject:cell.username]))
   {
       NSLog(@"on");
    [myInstall addUniqueObject:cell.username forKey:@"channels"];
    [myInstall saveInBackground];
    [self.tableView reloadData];
   }
   else
   {
       [myInstall removeObject:cell.username forKey:@"channels"];
       [myInstall save];
       [self.tableView reloadData];
   }
    
    
   
    
        
    
    
   
}
@end
