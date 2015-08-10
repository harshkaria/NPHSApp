//
//  MantillaViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 8/1/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "MantillaViewController.h"
#import <Parse/Parse.h>
#import "MantillaCell.h"
#import "BeepViewController.h"
@interface MantillaViewController ()

@property PFObject *transferObject;
@end

@implementation MantillaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"Topics"];
    //[query whereKey:@"approved" equalTo:[NSNumber numberWithBool:false]];
    [query orderByDescending:@"updatedAt"];
    return query;
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



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    self.tableView.separatorInset = UIEdgeInsetsZero;
    MantillaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCell"];
    
    cell.topicLabel.text = object[@"topic"];
    cell.approveButton.tag = indexPath.row;
    cell.declineButton.tag = indexPath.row;
    [cell.approveButton addTarget:self action:@selector(approveTopic:) forControlEvents:UIControlEventTouchUpInside];
    [cell.declineButton addTarget:self action:@selector(declineTopic:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.cellObject = object;
    cell.userInteractionEnabled = YES;
    
    if([object[@"approved"] boolValue] == true)
    {
        cell.approveButton.hidden = YES;
    }
    else if ([object[@"approved"]boolValue] == false)
    {
        cell.approveButton.hidden = NO;
    }
    cell.promptLabel.text = object[@"prompt"];
   // cell.commentCount.text = [NSString stringWithFormat:@"%li", [self getUnapprovedComments:object.objectId]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(NSInteger)getUnapprovedComments:(NSString *)objectId
{
    PFQuery *query = [PFQuery queryWithClassName:@"Comemnts"];
    [query whereKey:@"topicObjectId" equalTo:objectId];
    [query whereKey:@"approved" equalTo:[NSNumber numberWithBool:NO]];
    return [query countObjects];
}
-(void)approveTopic:(id)sender
{
    NSLog(@"Approved");
    UIButton *button = (UIButton *)sender;
    NSIndexPath *path = [NSIndexPath indexPathForRow:button.tag inSection:0];
    MantillaCell *cell = (MantillaCell *)[self.tableView cellForRowAtIndexPath:path];
    cell.cellObject[@"approved"] = [NSNumber numberWithBool:YES];
    [cell.cellObject saveInBackground];
    [self.tableView reloadData];
    
}
-(void)declineTopic:(id)sender
{
    NSLog(@"Declined");
    UIButton *button = (UIButton *)sender;
    NSIndexPath *path = [NSIndexPath indexPathForRow:button.tag inSection:0];
    MantillaCell *cell = (MantillaCell *)[self.tableView cellForRowAtIndexPath:path];
    cell.cellObject[@"approved"] = [NSNumber numberWithBool:NO];
    [cell.cellObject saveInBackground];
    [self.tableView reloadData];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MantillaCell *cell = (MantillaCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    self.transferObject = cell.cellObject;
    [self performSegueWithIdentifier:@"GoToCommentsMantilla" sender:self];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"GoToCommentsMantilla"])
    {
        BeepViewController *beepVC = segue.destinationViewController;
        beepVC.topicObject = self.transferObject;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
