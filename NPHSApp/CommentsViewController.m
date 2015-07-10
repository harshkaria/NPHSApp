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
#import <CoreText/CoreText.h>
@interface CommentsViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property NSString *trueString;
@property NSArray *data;
@property NSInteger totalComments;
@property NSArray *creators;
@property PFInstallation *currentInstallation;
@property NSNumber *amountOfVotes;
@property NSNumber *rowHeight;
@property NSArray *preData1;
@property NSMutableArray *preData2;
@property NSArray *finalCommentsArray;
@property NSString *hotObjectId;
@end

@implementation CommentsViewController
@synthesize commentPointer, back, promptLabel, totalComments, creators, currentInstallation, amountOfVotes, data, rowHeight, finalCommentsArray, preData1, preData2, hotObjectId;
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
    //self.navigationItem.hidesBackButton = YES;
    [super viewWillAppear:YES];
   // back = [[UIBarButtonItem alloc]initWithTitle:@"<" style:UIBarButtonItemStyleDone target:self action:@selector(backToThreads)];
   // self.navigationItem.leftBarButtonItem = back;
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
    PFQuery *queryOne = [PFQuery queryWithClassName:@"Comments"];
    [queryOne whereKey:@"topicObjectId" equalTo:commentPointer.objectId];
    [queryOne orderByDescending:@"createdAt"];
    queryOne.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    PFQuery *queryTwo = [PFQuery queryWithClassName:@"Comments"];
    [queryTwo whereKey:@"topicObjectId" equalTo:commentPointer.objectId];
    [queryTwo orderByDescending:@"voteNumber"];
    [queryTwo setLimit:1];
    
    //PFObject *hotComment = [queryTwo getFirstObject];
    //preData1 = [query findObjects];1
    preData1 = [queryOne findObjects];
    preData2 = [[NSMutableArray alloc] initWithObjects:[queryTwo getFirstObject], nil];
    //preData2[0] = [queryTwo getFirstObject];
   // hotObjectId = hotComment.objectId;
    [self sortComments];
    
    return queryOne;
}
-(void)sortComments
{
        NSArray *finalArray = [preData2 arrayByAddingObjectsFromArray:preData1];
       // NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:finalArray];
         finalCommentsArray = finalArray;
}
-(PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return finalCommentsArray[indexPath.row];
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
    
    NSMutableAttributedString *commentText;
    self.promptLabel.hidden = NO;
    self.promptLabel.text = commentPointer[@"prompt"];
    NSArray *voters = object[@"voters"];
    CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Comment"];
    cell.agreeButton.hidden = NO;
    
    [cell.countButtton setTitle:[self getAmountOfComments:object[@"voteNumber"]] forState:UIControlStateDisabled];
    
    [self styleCell:cell];
    [self styleCellAfterVote:cell];
    cell.agreeButton.tag = indexPath.row;
    cell.countButtton.layer.masksToBounds = YES;
    
    if(indexPath.row == 0)
    {
        cell.countButtton.backgroundColor = [UIColor redColor];
        cell.countButtton.layer.borderWidth = 1;
        cell.countButtton.layer.borderColor = [[UIColor whiteColor] CGColor];
        [cell.countButtton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        cell.fireLabel.hidden = NO;
        cell.agreeButton.hidden = YES;
        cell.customView.layer.borderWidth = 1;
        cell.customView.layer.borderColor = [[UIColor redColor] CGColor];
        
    }
    
    if([object[@"creator"] isEqualToString:currentInstallation.objectId])
    {
        cell.customView.backgroundColor = [UIColor lightGrayColor];
        cell.commentText.textColor = [UIColor blackColor];
        cell.agreeButton.hidden = YES;
        commentText = [self styleComment:object[@"text"] ownComment:YES];
    }
    else if(![object[@"creator"] isEqualToString:currentInstallation.objectId])
    {
        [cell.agreeButton setTitleColor: [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1] forState:UIControlStateNormal];
        commentText = [self styleComment:object[@"text"] ownComment:NO];
    }
    else if([voters containsObject:currentInstallation.objectId] || [object[@"creator"] isEqualToString:currentInstallation.objectId])
    {
        cell.agreeButton.hidden = YES;
    }
    if([voters containsObject:currentInstallation.objectId])
    {
        cell.agreeButton.hidden = YES;
    }
    if([object[@"staff"] boolValue] == YES)
    {
        [self staffStyle:cell];
    }
    if(cell.voted)
    {
        NSNumber *numberVote = [NSNumber numberWithInt:[object[@"voteNumber"]intValue]];
        [cell.countButtton setTitle:[self getAmountOfComments:numberVote] forState:UIControlStateDisabled];
    }
    
    
    self.tableView.separatorColor = [UIColor clearColor];
   // cell.customView.layer.cornerRadius = 12;
    
    //[cell.customView.layer setMasksToBounds:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentText.attributedText = commentText;
    cell.currentComment = object.objectId;
    cell.dogTag.text = object[@"dogTag"];
    return cell;
}
-(void)styleCell:(CommentsCell *)cell
{
    cell.customView.layer.borderWidth = 0;
    cell.customView.backgroundColor = [UIColor darkGrayColor];;
    
    [cell.agreeButton addTarget:self action:@selector(agreeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.agreeButton.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    cell.agreeButton.layer.cornerRadius = 2;
    cell.agreeButton.layer.borderWidth = 1;
    cell.agreeButton.layer.borderColor = cell.agreeButton.tintColor.CGColor;
    cell.fireLabel.hidden = YES;
    
    
}
-(void)styleCellAfterVote:(CommentsCell *)cell
{
    cell.countButtton.layer.borderWidth = 0;
    cell.countButtton.layer.cornerRadius = 10;
    cell.countButtton.backgroundColor = [UIColor blackColor];
    cell.countButtton.enabled = NO;
    [cell.countButtton setTitleColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1] forState:UIControlStateDisabled];
   
}
-(void)staffStyle:(CommentsCell *)cell
{
    cell.tagView.backgroundColor = [UIColor redColor];
    cell.dogTag.textColor = [UIColor whiteColor];
    cell.dogTag.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
}

-(NSMutableAttributedString *)styleComment:(NSString *)comment ownComment:(BOOL)own
{
    NSArray *words = [comment componentsSeparatedByString:@" "];
    NSMutableAttributedString *formattedString = [[NSMutableAttributedString alloc] initWithString:comment];
    
    if(own)
    {
        [formattedString setAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName] range:[comment rangeOfString:comment]];
    }
    else
    {
        [formattedString setAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1] forKey:NSForegroundColorAttributeName] range:[comment rangeOfString:comment]];
    }
    for(NSString *word in words)
    {
        if([word hasPrefix:@"@"])
        {
            NSRange range = [comment rangeOfString:word];
            [formattedString setAttributes:[NSDictionary dictionaryWithObject:[UIColor blueColor] forKey:NSForegroundColorAttributeName] range:range];
            if(!own)
            {
               [formattedString setAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName] range:range];
            }
            
        }

    }
    return formattedString;
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
         cell.voted = YES;
         [cell.countButtton setTitle:[self getAmountOfComments:amountOfVotes] forState:UIControlStateDisabled];
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
