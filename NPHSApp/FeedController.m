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
@property (nonatomic) PFInstallation *installation;
@property NSMutableArray *links;
@property UIWebView *wv;
@property UIBarButtonItem *prowl;
@end

@implementation FeedController
@synthesize  clubNames, clubText, count, links, wv, prowl;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        //self.parseClassName = @"User";
        self.paginationEnabled = NO;
        self.pullToRefreshEnabled = YES;
        //self.count = 0;
        
        
        
    }
    return self;
}
- (void)viewDidLoad {
    
    self.tableView.separatorColor = [UIColor yellowColor];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:VIEW_BG]];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    UIViewController *splash = [[SplashViewController alloc] init];
    prowl = [[UIBarButtonItem alloc]initWithTitle:@"Prowler" style:UIBarButtonItemStyleDone target:self action:@selector(getArticles)];
    [prowl setTintColor:[UIColor yellowColor]];
    self.navigationItem.leftBarButtonItem = prowl;
    links = [[NSMutableArray alloc] init];
    
    

    [super viewDidLoad];
    
        _installation = [PFInstallation currentInstallation];
        
        
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasPerformedFirstLaunch"]) {
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
            
            
        }
        else
        {
            
            if(_installation.badge != 0)
            {
                _installation.badge = 0;
                [_installation saveInBackground];
            }
        
            // DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
            
            //[self.view addSubview:draggableBackground];

    
            MWFeedParser *parser = [[MWFeedParser alloc] initWithFeedURL:[NSURL URLWithString:@"http://pantherprowler.org/feed/"]];
            parser.delegate = self;
            parser.connectionType = ConnectionTypeAsynchronously;
            parser.feedParseType = ParseTypeItemsOnly;
            [parser parse];
        [self.tableView reloadData];
        self.tableView.scrollsToTop = YES;
    [self presentViewController:splash animated:NO completion:nil];
    [self loadObjects];
    [self performSelector:@selector(hideMe) withObject:nil afterDelay:3];
        }
    
}
-(void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    [links addObject:item.link];
    
}
-(void)getArticles
{
    wv = [[UIWebView alloc] initWithFrame:self.view.bounds];
    wv.scalesPageToFit = YES;
    NSURLRequest *url = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[links objectAtIndex:0]]];
    [wv loadRequest:url];
    [self.view addSubview:wv];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneReading)];
    done.tintColor = [UIColor yellowColor];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"Panther Prowler";
    self.navigationItem.rightBarButtonItem = done;
    
    
}

-(void)doneReading
{
    
    [wv removeFromSuperview];
    self.navigationItem.leftBarButtonItem = prowl;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.title = @"Feed";
}

-(void)hideMe
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(PFQuery *)queryForTable
{
    PFInstallation *installation = [PFInstallation currentInstallation];
    
    PFQuery *query = [PFQuery queryWithClassName:@"feed"];
    [query whereKey:@"clubName" containedIn:installation.channels];
    [query orderByDescending:@"createdAt"];
    count = [query countObjects];
    
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
    
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY, hh:mm a"];
    NSString *date = [dateFormatter stringFromDate:object.createdAt];
    
    
    
    cell.clubName.text = object[@"Name"];
    
    
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
