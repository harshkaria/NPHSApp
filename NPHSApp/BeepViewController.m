//
//  BeepViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 3/15/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "BeepViewController.h"
#import <Parse/Parse.h>
#import "FBShimmeringView.h"
#import "BeepCell.h"
#import "RKDropdownAlert.h"

@interface BeepViewController ()
@property NSString *beepString;
@property NSString *objectID;
@property UIButton *ban;
@property NSString *banId;

@end

@implementation BeepViewController
@synthesize beepString, objectID, ban, banId;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.parseClassName = @"beep";
        self.paginationEnabled = NO;
        self.pullToRefreshEnabled = YES;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:@"firstTime"] == false)
    {
        [self performSelector:@selector(tutorial) withObject:self afterDelay:1];
        [defaults setBool:true forKey:@"firstTime"];
        [defaults synchronize];
    }*/
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.tableView reloadData];
    
    
}
/*-(void)tutorial
{
    [self performSegueWithIdentifier:@"tutorial" sender:self];
}*/
-(PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"sentBeeps"];
    [query orderByDescending:@"createdAt"];
    return query;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    BeepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Beeped"];
    beepString = object[@"beepText"];
    UIButton *check = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [check setTintColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]];
    [check addTarget:self action:@selector(sendBeep:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = check;
    [cell.contentView addSubview:check];
    
    cell.banButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cell.banButton setTitle:@"Ban" forState:UIControlStateNormal];
    [cell.banButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    cell.banButton.frame = CGRectMake(218, 4, 46, 30);
    [cell.banButton addTarget:self action:@selector(ban:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.banButton];
    cell.banButton.tag = indexPath.row;
    cell.person = object[@"person"];
    
    //[cell.contentView addSubview:cell.banButton];
    
  
    if([beepString containsString:@"/n"])
    {
        
        beepString = [beepString stringByReplacingOccurrencesOfString:@"/n" withString:@"\n \☞"];
        
    }
    if([object[@"live"]boolValue] == true)
    {
        cell.titleLabel.text = @"LIVE";
        cell.titleLabel.textColor = [UIColor redColor];
        
    }
    else
    {
        cell.titleLabel.text = @"Beep";
        cell.titleLabel.textColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    }
    cell.beepText.text = beepString;
    cell.myObject = object.objectId;
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;


    
    return cell;
}
-(void)ban:(id)sender
{

    UIButton *button = (UIButton *)sender;
    NSIndexPath *path = [NSIndexPath indexPathForRow:button.tag inSection:0];
    BeepCell *cell = (BeepCell *)[self.tableView cellForRowAtIndexPath:path];
    
    //NSLog(cell.person);
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"_Installation" objectId:cell.person];
    //PFObject *object = [query getFirstObject];
    object[@"banned"] = [NSNumber numberWithBool:YES];
    [object save];
    [RKDropdownAlert show];
    [RKDropdownAlert title:@"Banned" message:[NSString stringWithFormat:@"Banned: %@", cell.person] backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:4];

}
-(void)sendBeep:(id)sender
{
    UIButton *pressed = (UIButton *)sender;
    BeepCell *cell = (BeepCell *)pressed.superview;
    
    PFObject *post = [PFObject objectWithClassName:@"beep"];
    post[@"beepText"] = cell.beepText.text;
    [post saveInBackground];
    
    PFObject *deleteMe = [PFObject objectWithoutDataWithClassName:@"sentBeeps" objectId:cell.myObject];
    [deleteMe deleteInBackground];
    
    [RKDropdownAlert show];
    [RKDropdownAlert title:@"Moderator: Posted" message:@"Swaggers. You've bleeped it." time:4];
    [self loadObjects];
}


@end
