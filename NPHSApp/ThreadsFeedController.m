//
//  ThreadsFeedController.m
//  NPHSApp
//
//  Created by Harsh Karia on 6/15/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "ThreadsFeedController.h"
#import "ThreadsCell.h"
#import "BeepViewController.h"
#import <Parse/Parse.h>
#import "CommentsViewController.h"

@interface ThreadsFeedController ()
@property PFObject *correct;
@end

@implementation ThreadsFeedController
@synthesize correct;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.parseClassName = @"Topics";
        self.paginationEnabled = NO;
        self.pullToRefreshEnabled = YES;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadObjects];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.backBarButtonItem.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    
}

- (void)viewDidLoad {
    [[UINavigationBar appearance]setTintColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]];
    [super viewDidLoad];
    UIBarButtonItem *newThread = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newThread)];
    self.navigationItem.rightBarButtonItem = newThread;
    

}
-(PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"Topics"];
    [query orderByDescending:@"createdAt"];
    return query;
}

-(void)newThread
{
    [self performSegueWithIdentifier:@"newTopic" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    self.tableView.separatorColor = [UIColor clearColor];

    ThreadsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Thread"];
    cell.custom.layer.cornerRadius = 12;
    cell.commentCountLabel.hidden = YES;
    [cell.custom.layer setMasksToBounds:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSNumber *commentCount = object[@"commentCount"];
    
        if(commentCount > 0)
        {
            cell.commentCountLabel.hidden = NO;
            cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", commentCount];
        }
    
    cell.topicLabel.text = object[@"topic"];
    cell.currentThread = object;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThreadsCell *cell = (ThreadsCell *)[tableView cellForRowAtIndexPath:indexPath];
    correct = cell.currentThread;
    [self performSegueWithIdentifier:@"showComments" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showComments"])
    {
    CommentsViewController *comments = segue.destinationViewController;
    comments.commentPointer = correct;
    }
}


@end
