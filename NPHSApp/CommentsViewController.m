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
#import "ProfileTableViewController.h"
#import "YALSunnyRefreshControl.h"
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "LiveScoresVC.h"
#import "JHTickerView.h"
#import "DGActivityIndicatorView.h"
#import "DGActivityIndicatorAnimationProtocol.h"
#import "AppDelegate.h"
@interface CommentsViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MHFacebookImageViewerDatasource>

@property NSString *trueString;
@property NSArray *data;
@property NSInteger totalComments;
@property NSArray *creators;
@property PFInstallation *currentInstallation;
@property NSNumber *amountOfVotes;
@property NSNumber *rowHeight;
@property NSMutableArray *preData1;
@property NSMutableArray *preData2;
@property NSArray *imagesPreData;
@property NSMutableArray *finalCommentsArray;
@property NSString *hotObjectId;
@property NSString *dogTagString;
@property NSArray *hotObjectArray;
@property NSArray *otherCommentsArray;
@property (nonatomic,strong) YALSunnyRefreshControl *sunnyRefreshControl;
@property UIImage *cellImage;
@property PFObject *hotObject;
@property DGActivityIndicatorView *activityIndicatorView;
@end

@implementation CommentsViewController
@synthesize commentPointer, back, promptLabel, totalComments, creators, currentInstallation, amountOfVotes, data, rowHeight, finalCommentsArray, preData1, preData2, hotObjectId, sunnyRefreshControl, dogTagString, imagesPreData, promptView, cellImage, activityIndicatorView, hotObject, hotObjectArray, otherCommentsArray;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.parseClassName = @"Comments";
        self.paginationEnabled = NO;
        self.pullToRefreshEnabled = NO;
        
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
-(void)viewDidAppear:(BOOL)animated
{
    [self refreshMe];
    //activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeRotatingSquares tintColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1] size:60.0f];
    [super viewDidAppear:NO];
}
-(void)viewDidLoad
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.currentInstallation = [PFInstallation currentInstallation];
    self.navigationItem.title = commentPointer[@"topic"];
    [super viewDidLoad];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.scrollsToTop = YES;
    
    self.tableView.tableFooterView = [UIView new];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    
    UIBarButtonItem *beepButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"new@3x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(comment)];
    UIBarButtonItem *liveScoreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notepadicon@3x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(updateScore)];
    
    if([self isSponsor])
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    [self setUpRefresh];
    self.navigationItem.rightBarButtonItem = beepButton;
    
   
        self.navigationItem.rightBarButtonItems = @[beepButton, liveScoreButton];
    
    
    self.tableView.estimatedRowHeight = 105; // for example. Set your average height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView reloadData];
}
-(void)updateScore
{
    if(([[[PFUser currentUser] username] isEqualToString:@"athletics"] ||[[[PFUser currentUser] username] isEqualToString:@"appclub"] || [[[PFUser currentUser] username] isEqualToString:@"appclub"]) && commentPointer[@"sportGame"] == [NSNumber numberWithBool:YES])
        [self performSegueWithIdentifier:@"UpdateScore" sender:self];
    
    else
    {
        [self performSegueWithIdentifier:@"GoToRules" sender:self];
    }
}
-(void)setUpRefresh
{
    self.sunnyRefreshControl = [YALSunnyRefreshControl attachToScrollView:self.tableView
                                                                   target:self
                                                            refreshAction:@selector(didStartRefreshing)];
}
-(void)didStartRefreshing
{
    
    [self performSelector:@selector(endAnimationHandle) withObject:nil afterDelay:1];
}
-(void)endAnimationHandle{
    
    [self.sunnyRefreshControl endRefreshing];
    [self.commentPointer fetchInBackground];
    [self loadObjects];
}
-(void)refreshMe
{
    [self.commentPointer fetchInBackground];
    [self loadObjects];
    //[self loadObjects];
}
-(void)backToThreads
{
    [self performSegueWithIdentifier:@"backToThreads" sender:self];
}

-(PFQuery *)queryForTable
{
    preData1 = [[NSMutableArray alloc] init];
    PFQuery *mainQuery = [PFQuery queryWithClassName:@"Comments"];
    [mainQuery whereKey:@"topicObjectId" equalTo:commentPointer.objectId];
    
    
    PFQuery *queryApproved = [PFQuery queryWithClassName:@"Comments"];
    [queryApproved whereKey:@"topicObjectId" equalTo:commentPointer.objectId];
    [queryApproved whereKey:@"approved" equalTo:[NSNumber numberWithBool:YES]];
    //queryApproved.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    PFQuery *querySelf = [PFQuery queryWithClassName:@"Comments"];
    [querySelf whereKey:@"topicObjectId" equalTo:commentPointer.objectId];
    [querySelf whereKey:@"creator" equalTo:[PFInstallation currentInstallation].objectId];
    [querySelf whereKey:@"approved" equalTo:[NSNumber numberWithBool:NO]];
    //queryOneSelf.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    PFQuery *queryOne = [PFQuery orQueryWithSubqueries:@[querySelf, queryApproved]];
    [queryOne orderByDescending:@"createdAt"];
    [preData1 addObjectsFromArray:[queryOne findObjects]];
    
    PFQuery *hotQueryApproved = [PFQuery queryWithClassName:@"Comments"];
    [hotQueryApproved whereKey:@"topicObjectId" equalTo:commentPointer.objectId];
    [hotQueryApproved whereKey:@"approved" equalTo:[NSNumber numberWithBool:YES]];
    
    PFQuery *hotQuerySelf = [PFQuery queryWithClassName:@"Comments"];
    [hotQuerySelf whereKey:@"topicObjectId" equalTo:commentPointer.objectId];
    [hotQuerySelf whereKey:@"creator" equalTo:[PFInstallation currentInstallation].objectId];
    [hotQuerySelf whereKey:@"approved" equalTo:[NSNumber numberWithBool:NO]];
    
    PFQuery *hotQueryFinal = [PFQuery orQueryWithSubqueries:@[hotQueryApproved, hotQuerySelf]];
    [hotQueryFinal orderByDescending:@"voteNumber"];
    hotObject = [hotQueryFinal getFirstObject];
    [self sortComments];
    

    return queryOne;
}
-(void)sortComments
{
    if(hotObject)
    [preData1 insertObject:hotObject atIndex:0];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [preData1 count];
}

-(PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    
    return preData1[indexPath.row];
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
    
    if([commentPointer[@"sportGame"] boolValue] == YES)
    {
        promptView = [[JHTickerView alloc] initWithFrame:[promptLabel frame]];
        promptView.layer.cornerRadius = 0;
        promptView.backgroundColor = [UIColor blackColor];
        [promptView setDirection:JHTickerDirectionLTR];
        [promptView setTickerText:@[[NSString stringWithFormat:@"%@                   Eat at Cronies", commentPointer[@"prompt"]]]];
        [promptView setTickerFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:21.0f]];
        [promptView setTickerSpeed:110];
        [promptView start];
        [self.tableView addSubview:promptView];
    }
    else
    {
        self.promptLabel.hidden = NO;
        self.promptLabel.text = commentPointer[@"prompt"];
    }
    NSMutableAttributedString *commentText;
   
    
    NSArray *voters = object[@"voters"];
    CommentsCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Comment"];
    cell.accessoryView = UITableViewCellAccessoryNone;
    [cell.commentText setContentOffset:CGPointZero];
    
    if([object[@"hasImage"] boolValue])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ImageComment"];
        PFFile *file = object[@"image"];
        //UIImage *cellImage;
        cell.commentImageView.file = file;
        [cell.commentImageView loadInBackground];
        //[cell.commentImageView setupImageViewer];
    
    }
       
    [cell.commentText sizeToFit];
    //cell.commentImageView.hidden = YES;

     BOOL staff = [object[@"staff"] boolValue];
    [self styleCell:cell];
    [self styleCellAfterVote:cell];
    
    
    cell.agreeButton.hidden = NO;
    
    [cell.countButtton setTitle:[self getAmountOfComments:object[@"voteNumber"]] forState:UIControlStateDisabled];
    
    cell.agreeButton.tag = indexPath.row;
    cell.countButtton.layer.masksToBounds = YES;
    

    if(indexPath.row == 0 )
    {
        cell.countButtton.backgroundColor = [UIColor redColor];
        //cell.countButtton.layer.borderWidth = 1;
        //cell.countButtton.layer.borderColor = [[UIColor whiteColor] CGColor];
        [cell.countButtton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        cell.fireLabel.hidden = NO;
        cell.agreeButton.hidden = YES;
        cell.customView.layer.borderWidth = 1;
        cell.customView.layer.borderColor = [[UIColor redColor] CGColor];
        cell.customView.backgroundColor = [UIColor blackColor];
        cell.deleteButton.hidden = YES;
        
    }
    if([object[@"creator"] isEqualToString:currentInstallation.objectId])
    {
        cell.customView.backgroundColor = [AppDelegate lightGrayCustom];
        cell.commentText.textColor = [UIColor blackColor];
        cell.agreeButton.hidden = YES;
        cell.deleteButton.hidden = NO;
        [cell.deleteButton addTarget:self action:@selector(deleteComment:) forControlEvents:UIControlEventTouchUpInside];
        cell.cellObject = object;
        cell.deleteButton.tag = indexPath.row;
        commentText = [self styleComment:object[@"text"] ownComment:YES];
    }
    else if(![object[@"creator"] isEqualToString:currentInstallation.objectId])
    {
        [cell.agreeButton setTitleColor: [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1] forState:UIControlStateNormal];
        commentText = [self styleComment:object[@"text"] ownComment:NO];
        cell.deleteButton.hidden = YES;
    }
    else if([voters containsObject:currentInstallation.objectId] || [object[@"creator"] isEqualToString:currentInstallation.objectId])
    {
        cell.agreeButton.hidden = YES;
    }

    if([voters containsObject:currentInstallation.objectId])
    {
        cell.agreeButton.hidden = YES;
        [cell.countButtton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [cell.countButtton setBackgroundColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]];
    }
    else if(cell.voted)
    {
        NSNumber *numberVote = [NSNumber numberWithInt:[object[@"voteNumber"]intValue]];
        cell.agreeButton.hidden = YES;
        
        [cell.countButtton setTitle:[self getAmountOfComments:numberVote] forState:UIControlStateDisabled];
        [cell.countButtton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [cell.countButtton setBackgroundColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]];
    }
    if([object[@"dogTag"] isEqualToString:@""])
    {
        cell.dogTag.hidden = YES;
        cell.tagView.hidden = YES;
        
    }
    else
    {
        [cell.dogTag setTitle:object[@"dogTag"] forState:UIControlStateNormal];
        cell.dogTag.tag = indexPath.row;
        [cell.dogTag addTarget:self action:@selector(prepareProfile:) forControlEvents:UIControlEventTouchUpInside];
        if(staff)
        {
            [self staffStyle:cell];
        }
        else if(!staff)
        {
            [self normalStyle:cell];
        }
        cell.dogTag.hidden = NO;
        cell.tagView.hidden = NO;

    }
    

    
    self.tableView.separatorColor = [UIColor clearColor];
   // cell.customView.layer.cornerRadius = 12;
    [cell.customView addSubview:cell.agreeButton];
    [cell.customView addSubview:cell.countButtton];
    
    //[cell.customView.layer setMasksToBounds:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentText.attributedText = commentText;
    cell.currentComment = object.objectId;
    [cell.contentView sizeToFit];
    

    
    return cell;
}

-(void)deleteComment:(id)sender
{
    UIButton *deleteButton = (UIButton *)sender;
    NSIndexPath *path = [NSIndexPath indexPathForRow:deleteButton.tag inSection:0];
    CommentsCell *cell = (CommentsCell *)[self.tableView cellForRowAtIndexPath:path];
    [cell.cellObject deleteInBackground];
    int decrement = -1;
    [self.commentPointer incrementKey:@"commentCount" byAmount:[NSNumber numberWithInt:decrement]];
    [self.commentPointer saveInBackground];
    cell.hidden = YES;
    [self loadObjects];
    
    
}

-(void)prepareProfile:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSIndexPath *path = [NSIndexPath indexPathForRow:button.tag inSection:0];
    CommentsCell *cell = (CommentsCell *)[self.tableView cellForRowAtIndexPath:path];
    self.dogTagString = cell.dogTag.titleLabel.text;
    [self performSegueWithIdentifier:@"goToProfile" sender:self];
    
}
-(void)styleCell:(CommentsCell *)cell
{
    cell.customView.layer.borderWidth = 0;
    cell.customView.backgroundColor = [AppDelegate darkGrayCustom];;
    
    [cell.agreeButton addTarget:self action:@selector(agreeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.agreeButton.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    cell.agreeButton.layer.cornerRadius = 4;
    cell.agreeButton.layer.borderWidth = 1;
    cell.agreeButton.layer.borderColor = cell.agreeButton.tintColor.CGColor;
    cell.fireLabel.hidden = YES;
    cell.tagView.backgroundColor = [UIColor blackColor];
    

    
    
}
-(void)styleCellAfterVote:(CommentsCell *)cell
{
    cell.countButtton.layer.borderWidth = 0;
    cell.countButtton.layer.cornerRadius = 6;
    cell.countButtton.backgroundColor = [UIColor blackColor];
    cell.countButtton.enabled = NO;
    [cell.countButtton setTitleColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1] forState:UIControlStateDisabled];
   
}
-(void)staffStyle:(CommentsCell *)cell
{
    cell.tagView.backgroundColor = [UIColor redColor];
    
    [cell.dogTag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.dogTag.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
}
-(void)normalStyle:(CommentsCell *)cell
{
    cell.tagView.backgroundColor = [UIColor blackColor];
    
    [cell.dogTag setTitleColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1] forState:UIControlStateNormal];
    cell.dogTag.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:9];
}
-(NSMutableAttributedString *)styleComment:(NSString *)comment ownComment:(BOOL)own
{
    NSArray *words = [comment componentsSeparatedByString:@" "];
    NSMutableAttributedString *formattedString = [[NSMutableAttributedString alloc] initWithString:comment];
    
    //[formattedString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14]} range:[comment rangeOfString:comment]];
    

        [formattedString setAttributes:[NSDictionary dictionaryWithObjects:@[[AppDelegate whiteCustom], [UIFont fontWithName:@"HelveticaNeue" size:14]] forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]] range:[comment rangeOfString:comment]];
        
    
    
    for(NSString *word in words)
    {
        if([word hasPrefix:@"@"])
        {
            NSRange range = [comment rangeOfString:word];
           [formattedString setAttributes:[NSDictionary dictionaryWithObjects:@[[UIColor blueColor], [UIFont fontWithName:@"HelveticaNeue" size:12]] forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]] range:range];
            if(!own)
            {
               [formattedString setAttributes:[NSDictionary dictionaryWithObjects:@[[UIColor whiteColor], [UIFont fontWithName:@"HelveticaNeue" size:12]] forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]] range:range];
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
    cell.agreeButton.hidden = YES;
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"Comments" objectId:cell.currentComment];
    [object addUniqueObject:currentInstallation.objectId forKey:@"voters"];
    [object incrementKey:@"voteNumber"];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if(succeeded)
        {
         amountOfVotes = object[@"voteNumber"];
         cell.voted = YES;
        [self sendBumpNotification:cell.dogTag.titleLabel.text];
         [cell.countButtton setTitle:[self getAmountOfComments:amountOfVotes] forState:UIControlStateDisabled];
        [cell.countButtton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [cell.countButtton setBackgroundColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]];
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

-(void)sendBumpNotification:(NSString *)bumpedTo
{
    PFPush *bumpPush = [[PFPush alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"_Installation"];
    [query whereKey:@"dogTag" equalTo:bumpedTo];
    [bumpPush setQuery:query];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%@ bumped your Beep in %@.", currentInstallation[@"dogTag"], commentPointer[@"topic"]], @"alert",
                                @"default", @"sound",
                                nil];
    [bumpPush setData:dictionary];
    [bumpPush sendPushInBackground];

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
        beepSend.hidesBottomBarWhenPushed = YES;
    }
    if([segue.identifier isEqualToString:@"goToProfile"])
    {
        ProfileTableViewController *profileVC = segue.destinationViewController;
        profileVC.dogTag = self.dogTagString;
    }
    if([segue.identifier isEqualToString:@"UpdateScore"])
    {
        LiveScoresVC *scoresVC = segue.destinationViewController;
        scoresVC.liveObject = self.commentPointer;
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
    if([self isSponsor])
    {
        return nil;
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]};
    return [[NSAttributedString alloc] initWithString:@"Start the Conversation" attributes:attributes];
}
-(BOOL)isSponsor
{
    if([commentPointer[@"sponsor"] boolValue] == true)
    {
        return true;
    }
    return false;
}
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [self comment];
}
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    self.tableView.emptyDataSetSource = nil;
    self.tableView.emptyDataSetDelegate = nil;
}

@end
