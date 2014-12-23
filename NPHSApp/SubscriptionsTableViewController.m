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
    [super viewDidLoad];
    

    
}
-(PFQuery *)queryForTable
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    PFQuery *clubs = [PFUser query];
    self.count = [clubs countObjects];
    return clubs;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    UIImage *background = [UIImage imageNamed:@"nphs2.jpg"];
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:VIEW_BG]];

    PFInstallation *install = [PFInstallation currentInstallation];
    NSArray *currentChannels = install.channels;
    
    
    static NSString *CellIdentifier = @"Clubs";
    
    
    
    
    
    SubscriptionsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor colorWithPatternImage:background];
    
    //UITableViewCell *cellClub = [tableView cellForRowAtIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    
    // ADD ON OFF SWITCH
   self.onOff = [[UISwitch alloc]initWithFrame:CGRectZero];
    cell.accessoryView = onOff;
    
    
    [onOff addTarget:self action:@selector(actioned:)forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:onOff];
    
    
    cell.clubLabel.text = [object objectForKey:@"username"];
    cell.clubLabel.font = [UIFont fontWithName:@"HelveticaStrong" size:20];
    cell.clubLabel.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:cell.clubLabel];
    [cell.contentView addSubview:self.onOff];
    for(NSString *club in currentChannels)
    {
        if([club isEqualToString:cell.clubLabel.text])
        {
            [onOff setOn:YES];
        }
    }
    
    
    return cell;
   
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
    
    
    
    if([onOff isOn])
    {
        NSLog(@"on");
    [myInstall addUniqueObject:cell.clubLabel.text forKey:@"channels"];
    [myInstall saveInBackground];
        
    }
    else
    {
   
    
        NSLog(@"Toggled off");
        [onOff setOn:NO];
        [myInstall removeObject:cell.clubLabel.text forKey:@"channels"];
        [myInstall saveInBackground];
    }
    
        
    
    
   
}
@end
