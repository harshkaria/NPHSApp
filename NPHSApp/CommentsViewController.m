//
//  CommentsViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 6/18/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentsCell.h"
#import <Parse/Parse.h>
#import "BeepSendVC.h"
#import "UIScrollView+EmptyDataSet.h"
@interface CommentsViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property NSString *trueString;
@property NSArray *data;
@property NSInteger totalComments;
@property NSArray *creators;
@property PFInstallation *currentInstallation;
@property NSNumber *amountOfVotes;
@end

@implementation CommentsViewController
@synthesize commentPointer, back, promptLabel, totalComments, creators, currentInstallation, amountOfVotes, data;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.parseClassName = @"Comments";
        self.paginationEnabled = NO;
        self.pullToRefreshEnabled = YES;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    [super viewWillAppear:YES];
    back = [[UIBarButtonItem alloc]initWithTitle:@"<" style:UIBarButtonItemStyleDone target:self action:@selector(backToThreads)];
    self.navigationItem.leftBarButtonItem = back;
    self.promptLabel.hidden = YES;

}
-(void)viewDidLoad
{
    self.currentInstallation = [PFInstallation currentInstallation];
    self.navigationItem.title = commentPointer[@"topic"];
    [super viewDidLoad];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    
    UIBarButtonItem *beepButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"new@3x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(comment)];
    self.navigationItem.rightBarButtonItem = beepButton;
}
-(void)backToThreads
{
    [self performSegueWithIdentifier:@"backToThreads" sender:self];
}

-(PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"topicObjectId" equalTo:commentPointer.objectId];
    [query orderByDescending:@"voteNumber"];
    
    return query;
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
    
    self.promptLabel.hidden = NO;
    self.promptLabel.text = commentPointer[@"prompt"];
    self.amountOfVotes = object[@"voteNumber"];
    NSArray *voters = object[@"voters"];
    CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Comment"];
    [self styleCell:cell];
    [self styleCellAfterVote:cell];
    [cell.countButtton setTitle:[self getAmountOfComments:amountOfVotes] forState:UIControlStateNormal];
    cell.agreeButton.tag = indexPath.row;
    cell.countButtton.layer.masksToBounds = YES;
    
    if([object[@"creator"] isEqualToString:[PFInstallation currentInstallation].objectId])
    {
        cell.customView.backgroundColor = [UIColor lightGrayColor];
        cell.commentText.textColor = [UIColor blackColor];
        cell.agreeButton.hidden = YES;
    }
    else if(![object[@"creator"] isEqualToString:[PFInstallation currentInstallation].objectId])
    {
        [cell.agreeButton setTitleColor: [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1] forState:UIControlStateNormal];
    }
    if([voters containsObject:currentInstallation.objectId])
    {
        cell.agreeButton.hidden = YES;
    }
    else if(![voters containsObject:currentInstallation.objectId] && ![object[@"creator"] isEqualToString:[PFInstallation currentInstallation].objectId])
    {
        cell.agreeButton.hidden = NO;
    }
    
    self.tableView.separatorColor = [UIColor clearColor];
    cell.customView.layer.cornerRadius = 12;
    
    [cell.customView.layer setMasksToBounds:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.commentText.text = object[@"text"];
    cell.currentComment = object.objectId;
    
    return cell;
}
-(void)styleCell:(CommentsCell *)cell
{
    cell.customView.backgroundColor = [UIColor darkGrayColor];;
    cell.commentText.textColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    
    [cell.agreeButton addTarget:self action:@selector(agreeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.agreeButton.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    cell.agreeButton.layer.cornerRadius = 4;
    cell.agreeButton.layer.borderWidth = 1;
    cell.agreeButton.layer.borderColor = cell.agreeButton.tintColor.CGColor;

}
-(void)styleCellAfterVote:(CommentsCell *)cell
{
    cell.countButtton.layer.cornerRadius = 10;
    cell.countButtton.backgroundColor = [UIColor blackColor];
    cell.countButtton.enabled = NO;
    [cell.countButtton setTitleColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1] forState:UIControlStateDisabled];
    cell.countButtton.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    cell.countButtton.layer.borderColor = cell.countButtton.tintColor.CGColor;
}

-(void)agreeButtonPressed:(id)sender
{
    UIButton *agreeButton = (UIButton *)sender;
    NSIndexPath *path = [NSIndexPath indexPathForRow:agreeButton.tag inSection:0];
    CommentsCell *cell = (CommentsCell *)[self.tableView cellForRowAtIndexPath:path];
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"Comments" objectId:cell.currentComment];
    [object addUniqueObject:currentInstallation.objectId forKey:@"voters"];
    [object incrementKey:@"voteNumber"];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if(succeeded)
        {
         amountOfVotes = object[@"voteNumber"];
         cell.agreeButton.hidden = YES;
         [cell.countButtton setTitle:[self getAmountOfComments:amountOfVotes] forState:UIControlStateNormal];
        }
     }];
    
   // [cell.agreeButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
}
-(NSString *)getAmountOfComments:(NSNumber *)amount
{
    NSNumber *numberCount = amount;
    NSString *commentCount = [NSString stringWithFormat:@"%@", numberCount];
    return commentCount;
}





-(void)comment
{
    [self performSegueWithIdentifier:@"beepComment" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"beepComment"])
    {
        BeepSendVC *beepSend = segue.destinationViewController;
        beepSend.commentObject = commentPointer;
    }
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = commentPointer[@"prompt"];
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]};
    
    return [[NSAttributedString alloc] initWithString:@"Start the Conversation" attributes:attributes];
}
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [self comment];
}

- (void)dealloc
{
    self.tableView.emptyDataSetSource = nil;
    self.tableView.emptyDataSetDelegate = nil;
}

@end
