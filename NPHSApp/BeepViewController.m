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

@end

@implementation BeepViewController
@synthesize beepString, objectID;
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
    [RKDropdownAlert title:@"Moderator: Posted" message:@"Swaggers. You've beeped it." time:4];
    [self loadObjects];
}


@end
