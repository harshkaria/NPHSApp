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
#import "UIImageView+MHFacebookImageViewer.h"
#import "MHFacebookImageViewer.h"

@interface BeepViewController ()
@property NSString *beepString;
@property NSString *objectID;
@property UIButton *ban;
@property NSString *banId;

@end

@implementation BeepViewController
@synthesize beepString, objectID, ban, banId, topicObject;
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
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"topicObjectId" equalTo:self.topicObject.objectId];
    [query whereKey:@"approved" equalTo:[NSNumber numberWithBool:false]];
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
    BeepCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Beeped"];
    
    if([object[@"hasImage"] boolValue])
    {
        PFFile *file = object[@"image"];
        [file getDataInBackgroundWithBlock:^(NSData *myData, NSError *error)
         {
             UIImage *image = [UIImage imageWithData:myData];
             cell.commentImageView.image = image;
             [cell.commentImageView setupImageViewer];
         }];
    }
    beepString = object[@"text"];
    
    cell.banButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cell.banButton setTitle:@"Ban" forState:UIControlStateNormal];
    [cell.banButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    cell.banButton.frame = CGRectMake(218, 4, 46, 30);
    [cell.banButton addTarget:self action:@selector(ban:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.banButton];
    cell.banButton.tag = indexPath.row;
    
    // Approve Button
    cell.approveButton.tag = indexPath.row;
    [cell.approveButton addTarget:self action:@selector(approve:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:cell.approveButton];
    
    
    cell.person = object[@"creator"];
    
    //[cell.contentView addSubview:cell.banButton];
    
        cell.titleLabel.text = object[@"dogTag"];
        cell.titleLabel.textColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    
    cell.beepText.text = beepString;
    cell.myObject = object.objectId;
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([object[@"approved"] boolValue] == true)
    {
        [cell.approveButton setTitle:@"APPROVED" forState:UIControlStateNormal];
        [cell.approveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cell.approveButton removeTarget:self action:@selector(approve:) forControlEvents:UIControlEventTouchUpInside];
        
    }

    
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
-(void)approve:(id)sender
{
    UIButton *approve = (UIButton *)sender;
    // Creates path from row
    NSIndexPath *path = [NSIndexPath indexPathForRow:approve.tag inSection:0];
    // Gets/Casts BeepCell from tableview using path
    BeepCell *cell = (BeepCell *)[self.tableView cellForRowAtIndexPath:path];
    
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"Comments" objectId:cell.myObject];
    object[@"approved"] = [NSNumber numberWithBool:YES];
    [object save];
    [self loadObjects];
    
    
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
