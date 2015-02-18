//
//  FeedController.m
//  NPHSApp
//
//  Created by Harsh Karia on 11/23/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "FeedController.h"
#import "FeedCell.h"
#import "SplashViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "OnboardingViewController.h"
#import "MWFeedParser.h"
#import "MWFeedInfo.h"
@interface FeedController ()
@property NSMutableArray *clubNames;
@property NSMutableArray *clubText;
@property NSInteger count;
@property PFInstallation *installation;
@property NSMutableArray *links;
@property UIWebView *wv;
@property UIBarButtonItem *prowl;
@property PFQuery *query;
@property NSArray *array;
@property UIBarButtonItem *qButton;
@property UIBarButtonItem *done;
@property UIWebView *gradesWV;
@property NSArray *removeArray;
@end


@implementation FeedController
@synthesize  clubNames, clubText, count, links, wv, prowl, query, array, qButton, done, gradesWV, removeArray, installation;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        
        self.parseClassName = @"feed";
        //self.parseClassName = @"User";
        self.paginationEnabled = NO;
        self.pullToRefreshEnabled = YES;
        //self.count = 0;
        done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneReading)];
        done.tintColor = [UIColor yellowColor];
        
        
        
        
    }
    return self;
}
- (void)viewDidLoad {
    installation = [PFInstallation currentInstallation];

    self.tableView.separatorColor = [UIColor yellowColor];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:VIEW_BG]];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    UIViewController *splash = [[SplashViewController alloc] init];
    prowl = [[UIBarButtonItem alloc]initWithTitle:@"Prowler" style:UIBarButtonItemStyleDone target:self action:@selector(getArticles)];
    [prowl setTintColor:[UIColor yellowColor]];
    
    qButton = [[UIBarButtonItem alloc] initWithTitle:@"Grades" style:UIBarButtonItemStyleDone target:self action:@selector(loadQ)];
    [qButton setTintColor:[UIColor yellowColor]];
    
    self.navigationItem.leftBarButtonItem = prowl;
    self.navigationItem.rightBarButtonItem = qButton;
    links = [[NSMutableArray alloc] init];
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.view.clipsToBounds = YES;
    
    
    [super viewDidLoad];
    [self presentViewController:splash animated:NO completion:nil];
    
    [self performSelector:@selector(hideMe) withObject:nil afterDelay:3];
    
   
    
    
    /*if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasPerformedFirstLaunch"]) {
     self.navigationItem.title = @"It's my first time...";
     
     
     OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"Welcome" body:@"This NPHS app will rock yo socks off" image:nil buttonText:nil action:nil];
     OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"Introducing Smart Notfications" body:@"Subscribe to the activites you are involved in, and follow football games, etc as they happen" image:[UIImage imageNamed:@"nphs2.jpg"] buttonText:nil action:nil];
     OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc]initWithTitle:@"Introducing Smart Reminders" body:@"Interact like never before. Now, you can view live scores for athletics, and automatically get new reminders that are tailored to suit you." image:nil buttonText:nil action:nil];
     OnboardingContentViewController *fourthPage = [[OnboardingContentViewController alloc]initWithTitle:@"Precise Design" body:@"We designed the NPHS with you in mind. In fact, most of the pictures you see in this app, including the background on the pages, will be updated with pictures you take. Tweet away to @harshkaria"  image:nil buttonText:@"Done" action:^{
     [self dismissViewControllerAnimated:YES completion: nil];
     self.navigationItem.title = @"Feed";
     [self loadObjects];
     }];
     
     
     [firstPage setUnderIconPadding:-120  ];
     secondPage.topPadding = 40;
     [thirdPage setUnderIconPadding:-175];
     [fourthPage setUnderIconPadding:-175];
     OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"nphs2.jpg"] contents:@[firstPage, secondPage, thirdPage, fourthPage]];
     onboardingVC.view.frame = [[UIScreen mainScreen]bounds];
     onboardingVC.shouldMaskBackground = YES;
     onboardingVC.allowSkipping = NO;
     // onboardingVC.shouldBlurBackground = YES;
     onboardingVC.skipHandler = ^{
     [self dismissViewControllerAnimated:YES completion:nil];
     };
     onboardingVC.shouldFadeTransitions = YES;
     
     
     // Set the "hasPerformedFirstLaunch" key so this block won't execute again
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasPerformedFirstLaunch"];
     [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"date"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     //
     [self presentViewController:onboardingVC animated:NO completion:nil];
     [self.tableView reloadData];
     
     
     }*/
    
    
    
    if(installation.badge != 0)
    {
        installation.badge = 0;
        [installation saveInBackground];
    }
    
    // DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
    
    //[self.view addSubview:draggableBackground];
    
    
    MWFeedParser *parser = [[MWFeedParser alloc] initWithFeedURL:[NSURL URLWithString:@"http://pantherprowler.org/feed/"]];
    parser.delegate = self;
    parser.connectionType = ConnectionTypeAsynchronously;
    parser.feedParseType = ParseTypeItemsOnly;
    [parser parse];
    count = 0;
    
    self.tableView.scrollsToTop = YES;
    
    
    
}
-(void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    [links addObject:item.link];
    
}
-(void)getArticles
{
    
    if(!self.tableView.isDecelerating && !self.tableView.isDragging)
    {
        //self.wv.userInteractionEnabled = YES;
        // self.tableView.userInteractionEnabled = NO;
        self.tableView.scrollsToTop = NO;
        wv = [[UIWebView alloc] initWithFrame:self.view.bounds];
        wv.scalesPageToFit = YES;
        
        
        self.wv.scrollView.scrollsToTop = YES;
        wv.scalesPageToFit = YES;
        wv.userInteractionEnabled = YES;
        NSURLRequest *url = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[links objectAtIndex:0]]];
        [wv loadRequest:url];
        [self.tableView addSubview:wv];
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneReading)];
        done.tintColor = [UIColor yellowColor];
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.title = @"Panther Prowler";
        self.navigationItem.rightBarButtonItem = done;
    }
    
    
}
-(void)loadQ
{
    if(!self.tableView.isDecelerating && !self.tableView.isDragging)
    {
        //self.gradesWV.userInteractionEnabled = YES;
        // self.tableView.userInteractionEnabled = NO;
        gradesWV = [[UIWebView alloc] initWithFrame:self.view.bounds];
        gradesWV.scalesPageToFit = YES;
        self.tableView.scrollsToTop = NO;
        self.navigationItem.title = @"Q - Grades";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://q.conejousd.org/StudentPortal/Home/Login"]];
        [gradesWV loadRequest:request];
        [self.view addSubview:gradesWV];
        
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.rightBarButtonItem = done;
    }
    
}

-(void)doneReading
{
    self.tableView.userInteractionEnabled = YES;
    self.tableView.scrollsToTop = YES;
    
    [gradesWV removeFromSuperview];
    [wv removeFromSuperview];
    
    self.navigationItem.leftBarButtonItem = prowl;
    self.navigationItem.rightBarButtonItem = qButton;
    self.navigationItem.title = @"Feed";
}

-(void)hideMe
{
    [self dismissViewControllerAnimated:NO completion:nil];
    // fixes bug where objects didn't load when app was loaded for the first time
    [self performSelectorOnMainThread:@selector(loadObjects) withObject:nil waitUntilDone:NO];
}

-(PFQuery *)queryForTable
{
        if(!self.parseClassName)
    {
        self.parseClassName = @"feed";
    }
    query = [PFQuery queryWithClassName:self.parseClassName];
    if(installation.channels)
    {
    [query whereKey:@"clubName" containedIn:installation.channels];
    
    }
    if(![installation.channels containsObject:@"prowler"])
         {
             [installation addUniqueObject:@"prowler" forKey:@"channels"];
             [installation saveInBackground];
         }
    [query orderByDescending:@"createdAt"];
    count = [query countObjects];
    //array = [query findObjects];
   // [self.tableView reloadData];
    return query;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
#warning Potentially incomplete method implementation.
    
    // Return the number of sections.
    
    
    return 1;
    
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(FeedCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Feed"];
    cell.bg.image = [UIImage imageNamed:VIEW_BG];
    cell.bg.alpha = 0.4;
    cell.clubText.selectable = YES;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feed"];
    cell.bg.image = [UIImage imageNamed:VIEW_BG];
    cell.bg.alpha = 0.4;
    NSString *username = [[PFUser currentUser]username];
     cell.clubName.text = object[@"Name"];
     cell.objId = [object objectForKey:@"clubName"];
    /*if([username isEqualToString:cell.objId])
        {
            cell.removeButton.hidden = NO;
            [cell.removeButton addTarget:self action:@selector(deleteMe:) forControlEvents:UIControlEventTouchUpInside];
            [cell.feedView addSubview:cell.removeButton];
            
        }*/
    
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY, hh:mm a"];
    NSString *date = [dateFormatter stringFromDate:object.createdAt];
    
    
    
   
   
    
    
    cell.clubText.text = [object objectForKey:@"feedPost"];
    
    
    cell.dateLabel.text = date;
    cell.dateLabel.alpha = 0.6;
    
    
    cell.clubText.selectable = YES;
    
    cell.clubName.alpha = 1;
    
    
    cell.clubText.alpha = 1;
    cell.clubText.scrollsToTop = NO;
    
    
    
    
    [cell.feedView addSubview:cell.clubName];
    
    [cell.feedView addSubview:cell.clubText];
    [cell.feedView addSubview:cell.dateLabel];
    
    
    
    
    
    cell.userInteractionEnabled = YES;
    return cell;
    
    
    
}

@end
