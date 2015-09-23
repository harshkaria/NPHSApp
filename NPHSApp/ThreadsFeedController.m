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
#import "ProfileTableViewController.h"
#import "SponsorViewController.h"
#import "OnboardingContentViewController.h"
#import "OnboardingViewController.h"
#import "AppDelegate.h"
#import "SplashViewController.h"

@interface ThreadsFeedController ()
@property PFObject *correct;
@property NSArray *data;
@property NSArray *finalData;
@property NSArray *hotData;
@property NSArray *liveData;
@property NSArray *sponsoredData;
@property (nonatomic,strong) YALSunnyRefreshControl *sunnyRefreshControl;
@property PFInstallation *currentInstallation;
@property NSInteger totalCount;
@property NSArray *specialData;
@property NSArray *recentTopicsData;
@property PFObject *newestObject;
@end

@implementation ThreadsFeedController
@synthesize correct, data, finalData, hotData, liveData, sunnyRefreshControl, sponsoredData, currentInstallation, totalCount, comingBack, specialData, recentTopicsData, newestObject;

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
    
    
    currentInstallation = [PFInstallation currentInstallation];
    NSString *dogTag = [[PFInstallation currentInstallation] objectForKey:@"dogTag"];
    //[self loadObjects];
    
    
    [super viewWillAppear:YES];
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *dogTagButton = [[UIBarButtonItem alloc] initWithTitle:dogTag style:UIBarButtonItemStyleDone target:self action:@selector(goToProfile)];
    
    if([currentInstallation[@"dtOn"]boolValue] == true)
    {
        self.navigationItem.leftBarButtonItem = dogTagButton;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    //self.navigationItem.leftBarButtonItem.enabled = NO;
    
    
}
-(OnboardingViewController *)onboard
{
    OnboardingContentViewController *vcOne = [[OnboardingContentViewController alloc] initWithTitle:@"Hey." body:@"Welcome to the NPHS app. This version has great updates to everything from the Club Feed to Beep." image:nil buttonText:nil action:nil];
    vcOne.topPadding = 20;
    OnboardingContentViewController *vcTwo = [[OnboardingContentViewController alloc] initWithTitle:@"Express your views. Without being judged." body:@"On Beep, you now have the ability to anonymously express your opinions about any #Topic." image:nil buttonText:nil action:nil];
    vcTwo.topPadding = 0;
    vcTwo.bodyFontSize = 22;
    vcTwo.underIconPadding = 0;
    OnboardingContentViewController *vcThree = [[OnboardingContentViewController alloc] initWithTitle:@"Comment on the #Topics you love. Now with @ Tags." body:@"To have a better conversation, you can now post pictures in your comments. If you like a comment, Bump it to the top. Each user is given a Dog Tag (e.g. ABC) and can notify others." image:nil buttonText:nil action:nil];
    vcThree.topPadding = 0;
    vcThree.bodyFontSize = 22;
    vcThree.underIconPadding = 0;
    OnboardingContentViewController *vcFour = [[OnboardingContentViewController alloc] initWithTitle:@"LIVE #Topics & LIVE scores. Experience events as they happen." body:@"With LIVE #Topics, get the latest scores and updates from sports in an instant. Yes, even during away games." image:nil buttonText:nil action:nil];
    vcFour.topPadding = 0;
    vcFour.bodyFontSize = 22;
    vcFour.underIconPadding = 0;
    OnboardingContentViewController *vcFive = [[OnboardingContentViewController alloc] initWithTitle:@"Connect with your clubs." body:@"On the club feed, you get all your club information in one place. You'll never miss a meeting again." image:nil buttonText:nil action:nil];
    vcFive.topPadding = 30;
    vcFive.bodyFontSize = 22;
    vcFive.underIconPadding = 10;
    OnboardingContentViewController *vcSix = [[OnboardingContentViewController alloc] initWithTitle:@"Let's talk. Let's Beep." body:@"You are now a part of something really cool. Let's have great conversations." image:nil buttonText:@"Start Beeping" action:^{
        ThreadsFeedController *threadsVC = [[ThreadsFeedController alloc] init];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    vcSix.topPadding = 40;
    vcSix.bodyFontSize = 22;
    vcSix.underIconPadding = 35;
    
    if(![self has4InchDisplay])
        vcSix.bottomPadding = 130;
    else
        vcSix.bottomPadding = 50;
    
    OnboardingViewController *onboardVC = [[OnboardingViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"bg4.jpg"] contents:@[vcOne, vcTwo, vcThree, vcFour, vcFive, vcSix]];
    if(![self has4InchDisplay])
        onboardVC.underTitlePadding = 80;
    onboardVC.shouldFadeTransitions = YES;
    return onboardVC;
    
}
- (BOOL)has4InchDisplay {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0);
}
-(void)goToProfile
{
    [self performSegueWithIdentifier:@"goToProfile" sender:self];
    
}

- (void)viewDidLoad {
    
    if(!comingBack)
    {
        UIViewController *splash = [[SplashViewController alloc] init];
        [self presentViewController:splash animated:NO completion:nil];
        [self performSelector:@selector(hideMe) withObject:nil afterDelay:3];
    }
    
    
    [[UINavigationBar appearance]setTintColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]];
    self.navigationItem.title = @"Beep";
    [super viewDidLoad];
    UIBarButtonItem *newThread = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newThread)];
    self.navigationItem.rightBarButtonItem = newThread;
    [self setUpRefresh];
    
    
    
}
-(void)hideMe
{
    [self dismissViewControllerAnimated:NO completion:nil];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"BeepFirstLaunch"]) {
        NSLog(@"First launch");
        [self presentViewController:[self onboard] animated:NO completion:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BeepFirstLaunch"];
    }
    // fixes bug where objects didn't load when app was loaded for the first time
    
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
    [query whereKey:@"approved" equalTo:[NSNumber numberWithBool:YES]];
    [query orderByDescending:@"createdAt"];
    
    PFQuery *liveQuery = [PFQuery queryWithClassName:@"Topics"];
    [liveQuery whereKey:@"live" equalTo:[NSNumber numberWithBool:YES]];
    NSInteger countLive = [liveQuery countObjects];
    
    
    PFQuery *queryTwo = [PFQuery queryWithClassName:@"Topics"];
    [queryTwo orderByDescending:@"commentCount"];
    [queryTwo whereKey:@"live" equalTo:[NSNumber numberWithBool:NO]];
    [queryTwo whereKey:@"sponsor" equalTo:[NSNumber numberWithBool:NO]];
    [query whereKey:@"approved" equalTo:[NSNumber numberWithBool:YES]];
    [queryTwo setLimit:2 - countLive];
    
    NSInteger hotCount = [queryTwo countObjects];
    totalCount = countLive + hotCount;
    NSLog([NSString stringWithFormat:@"%i", totalCount]);
    
    PFQuery *recentObjectApproved = [PFQuery queryWithClassName:@"Topics"];
    [recentObjectApproved whereKey:@"approved" equalTo:[NSNumber numberWithBool:YES]];
    
    
    PFQuery *recentObjectOwn = [PFQuery queryWithClassName:@"Topics"];
    [recentObjectOwn whereKey:@"approved" equalTo:[NSNumber numberWithBool:NO]];
    [recentObjectOwn whereKey:@"creator" equalTo:[PFInstallation currentInstallation].installationId];
    
    PFQuery *finalRecentQuery = [PFQuery orQueryWithSubqueries:@[recentObjectApproved, recentObjectOwn]];
    [finalRecentQuery whereKey:@"live" equalTo:[NSNumber numberWithBool:NO]];
    [finalRecentQuery orderByDescending:@"createdAt"];
    [finalRecentQuery setLimit:1];
    
    
    PFQuery *sponsoredQuery = [PFQuery queryWithClassName:@"Topics"];
    [sponsoredQuery whereKey:@"sponsor" equalTo:[NSNumber numberWithBool:YES]];
    
    data = [query findObjects];
    hotData = [queryTwo findObjects];
    liveData = [liveQuery findObjects];
    sponsoredData = [sponsoredQuery findObjects];
    newestObject = [finalRecentQuery getFirstObject];
    
    [self sortObjects];
    return query;
    
}

-(void)sortObjects
{
    NSLog(currentInstallation.objectId);
    NSMutableArray *preData = [[NSMutableArray alloc] init];
    NSMutableArray *hotPreData = [[NSMutableArray alloc] init];
    NSMutableArray *recentData = [[NSMutableArray alloc] init];
    NSArray *preData3 = [[NSArray alloc] init];
    
    for(PFObject *liveObject in liveData)
    {
        [preData addObject:liveObject];
        [hotPreData addObject:liveObject.objectId];
    }
    
    [preData addObject:newestObject];
    [hotPreData addObject:newestObject.objectId];
    
    for(PFObject *hotObject in hotData)
    {
        [preData addObject:hotObject];
        [hotPreData addObject:hotObject.objectId];
    }
    
    for(PFObject *sponsoredObject in sponsoredData)
    {
        [preData addObject:sponsoredObject];
        [hotPreData addObject:sponsoredObject.objectId];
    }
    
    PFQuery *queryOne = [PFQuery queryWithClassName:@"Topics"];
    [queryOne whereKey:@"objectId" notContainedIn:hotPreData];
    [queryOne whereKey:@"approved" equalTo:[NSNumber numberWithBool:YES]];
    
    PFQuery *queryTwo = [PFQuery queryWithClassName:@"Topics"];
    [queryTwo whereKey:@"objectId" notContainedIn:hotPreData];
    [queryTwo whereKey:@"approved" equalTo:[NSNumber numberWithBool:NO]];
    [queryTwo whereKey:@"creator" equalTo:[PFInstallation currentInstallation].objectId];
    
    PFQuery *queryThree = [PFQuery orQueryWithSubqueries:@[queryOne, queryTwo]];
    [queryThree orderByDescending:@"updatedAt"];
    
    recentData = [queryThree findObjects];
    
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
    if(indexPath.row < 3)
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
    if(indexPath.row < 3)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HotThread"];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Thread"];
    }
    if(!cell)
    {
        [self loadObjects];
    }
    
    
    cell.bgView.image = [UIImage imageNamed:object[@"imageName"]];
    cell.commentCountLabel.hidden = YES;
    cell.liveView.hidden = YES;
    cell.liveLabel.hidden = YES;
    [cell.custom.layer setMasksToBounds:YES];
    BOOL live = [object[@"live"]boolValue];
    BOOL sponsored = [object[@"sponsor"]boolValue];
    
    cell.custom.layer.borderWidth = 1;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSNumber *commentCount = object[@"commentCount"];
    cell.custom.layer.borderColor = [AppDelegate whiteCustom].CGColor;
    
    if([object.objectId isEqualToString:newestObject.objectId])
    {
        cell.custom.layer.borderColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1].CGColor;
        cell.liveView.hidden = NO;
        cell.liveView.backgroundColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
        
        cell.liveLabel.hidden = NO;
        cell.liveLabel.text = @"NEW";
        FBShimmeringView *shimmer = [[FBShimmeringView alloc] initWithFrame:CGRectMake(12, 17, 35, 21)];
        shimmer.contentView = cell.liveLabel;
        shimmer.shimmering = YES;
        shimmer.shimmeringSpeed = 40;
        shimmer.shimmeringOpacity = 1.0;
        [cell.contentView addSubview:shimmer];
        
    }
    
    if(indexPath.row < 3 && ![object.objectId isEqualToString:newestObject.objectId] && !live)
    {
        cell.custom.layer.borderColor = [AppDelegate redCustom].CGColor;
        cell.liveView.hidden = NO;
        cell.liveView.backgroundColor = [UIColor redColor];
        
        cell.liveLabel.hidden = NO;
        cell.liveLabel.text = @"HOT";
        
    }
    
    if (live) {
        [cell removeBlur];
        cell.bgView.hidden = YES;
        cell.custom.backgroundColor = [UIColor blackColor];
        cell.custom.layer.borderColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1].CGColor;;
        
        cell.liveView.hidden = NO;
        cell.liveView.backgroundColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
        
        cell.liveLabel.hidden = NO;
        cell.liveLabel.text = @"LIVE";
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
    if(sponsored)
    {
        cell.custom.layer.borderColor = [AppDelegate greenCustom].CGColor;
        cell.custom.layer.borderWidth = 2;
        cell.sponsoredView.hidden = NO;
        cell.sponsoredLabel.hidden = NO;
        cell.sponsor = YES;
        cell.commentCountLabel.hidden = YES;
    }
    else
    {
        cell.sponsoredView.hidden = YES;
        cell.sponsoredLabel.hidden = YES;
        cell.sponsor = NO;
    }
    
    
    
    cell.topicLabel.text = object[@"topic"];
    cell.currentThread = object;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ThreadsCell *cell = (ThreadsCell *)[tableView cellForRowAtIndexPath:indexPath];
    correct = cell.currentThread;
    if(cell.sponsor)
    {
        [self performSegueWithIdentifier:@"goToSponsor" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"showComments" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showComments"])
    {
        CommentsViewController *comments = segue.destinationViewController;
        comments.commentPointer = correct;
    }
    if([segue.identifier isEqualToString:@"goToProfile"])
    {
        ProfileTableViewController *profileVC = segue.destinationViewController;
        profileVC.dogTag = [[PFInstallation currentInstallation] objectForKey:@"dogTag"];
        
    }
    if([segue.identifier isEqualToString:@"goToSponsor"])
    {
        SponsorViewController *sponsor = segue.destinationViewController;
        sponsor.sponsoredObject = correct;
    }
}


@end