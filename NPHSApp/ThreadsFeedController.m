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
#import "YALSunnyRefreshControl.h"
#import "FBShimmeringView.h"

@interface ThreadsFeedController ()
@property PFObject *correct;
@property NSArray *data;
@property NSArray *finalData;
@property NSArray *hotData;
@property NSArray *liveData;
@property (nonatomic,strong) YALSunnyRefreshControl *sunnyRefreshControl;

@end

@implementation ThreadsFeedController
@synthesize correct, data, finalData, hotData, liveData, sunnyRefreshControl;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.parseClassName = @"Topics";
        self.paginationEnabled = NO;
        self.pullToRefreshEnabled = NO;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
     //[self loadObjects];
    [super viewWillAppear:YES];
    self.navigationItem.hidesBackButton = YES;

    
    
}

- (void)viewDidLoad {
    [[UINavigationBar appearance]setTintColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]];
    [super viewDidLoad];
    UIBarButtonItem *newThread = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newThread)];
    self.navigationItem.rightBarButtonItem = newThread;
    [self setUpRefresh];
    
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
    [self loadObjects];
}
-(PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"Topics"];
    [query orderByDescending:@"createdAt"];
    PFQuery *queryTwo = [PFQuery queryWithClassName:@"Topics"];
    [queryTwo orderByDescending:@"commentCount"];
    [queryTwo whereKey:@"live" equalTo:[NSNumber numberWithBool:false]];
    [queryTwo setLimit:3];
    
    PFQuery *liveQuery = [PFQuery queryWithClassName:@"Topics"];
    [liveQuery whereKey:@"live" equalTo:[NSNumber numberWithBool:YES]];
    
    data = [query findObjects];
    hotData = [queryTwo findObjects];
    liveData = [liveQuery findObjects];
    [self sortObjects];
    return query;

}

-(void)sortObjects
{
    
    NSMutableArray *preData = [[NSMutableArray alloc] init];
    NSMutableArray *hotPreData = [[NSMutableArray alloc] init];
    NSMutableArray *recentData = [[NSMutableArray alloc] init];
    NSArray *preData3 = [[NSArray alloc] init];
    
    for(PFObject *liveObject in liveData)
    {
        [preData addObject:liveObject];
        [hotPreData addObject:liveObject.objectId];
    }
    
    for(PFObject *hotObject in hotData)
    {
        [preData addObject:hotObject];
        [hotPreData addObject:hotObject.objectId];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Topics"];
    [query whereKey:@"objectId" notContainedIn:hotPreData];
    [query orderByDescending:@"createdAt"];
    //query.cachePolicy = kp;
    recentData = [query findObjects];
    
    preData3 = [preData arrayByAddingObjectsFromArray:recentData];
    NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:preData3];
    NSArray *preData4 = [set array];
    
    //NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:preData];
    finalData = preData4;
    

}



-(PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath
{
   // [self sortObjects];
    PFObject *object = finalData[indexPath.row];
    return object;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [finalData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row <= 2)
    {
        return 115;
    }
    else
    {
        return 90;
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    self.tableView.separatorColor = [UIColor clearColor];
    ThreadsCell *cell;
    if(indexPath.row <= 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HotThread"];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Thread"];
    }
    cell.bgView.image = [UIImage imageNamed:object[@"imageName"]];
    cell.commentCountLabel.hidden = YES;
    cell.liveView.hidden = YES;
    cell.liveLabel.hidden = YES;
    [cell.custom.layer setMasksToBounds:YES];
    BOOL live = [object[@"live"]boolValue];
    
    cell.custom.layer.borderWidth = 1;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSNumber *commentCount = object[@"commentCount"];
    if(indexPath.row <= 2)
    cell.custom.layer.borderColor = [[UIColor redColor]CGColor];
    else
    {
        cell.custom.layer.borderColor = [[UIColor whiteColor]CGColor];
    }
    if (live) {
        cell.liveView.hidden = NO;
        cell.liveLabel.hidden = NO;
        FBShimmeringView *shimmer = [[FBShimmeringView alloc] initWithFrame:CGRectMake(12, 17, 35, 21)];
        shimmer.contentView = cell.liveLabel;
        shimmer.shimmering = YES;
        shimmer.shimmeringSpeed = 60;
        shimmer.shimmeringOpacity = 1.0;
        [cell.contentView addSubview:shimmer];
        
    }
    
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