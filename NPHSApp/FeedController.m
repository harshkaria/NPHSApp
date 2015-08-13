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
//#import "OnboardingViewController.h"
#import "MWFeedParser.h"
#import "MWFeedInfo.h"
#import "FBShimmeringView.h"
#import "BeepSpotlightVC.h"
#import "UITableView+FDTemplateLayoutCell.h"
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
@property UISegmentedControl *segmentedControl;
@property NSString *beepString;
@property UISwipeGestureRecognizer *leftSwipe;
@property UISwipeGestureRecognizer *rightSwipe;
@property UIBarButtonItem *sendButton;
@property (nonatomic, assign) BOOL payload;

@end


@implementation FeedController
@synthesize  clubNames, clubText, count, links, wv, prowl, query, array, qButton, done, gradesWV, removeArray, installation, segmentedControl, beepString, leftSwipe, rightSwipe, sendButton, payload, spotlightText, comingBack;
-(id)init
{
    [self loadObjects];
    return [self initWithStyle:UITableViewStylePlain];
}

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
        done.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
        
        
        
        
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.beepText.length > 0)
    {
        spotlightText = appDelegate.beepText;
        [self showSpotlight];
        appDelegate.beepText = nil;
    }
}

- (void)viewDidLoad {
    //[self addSegmented];
    //[self addGestures];
    installation = [PFInstallation currentInstallation];

    self.tableView.separatorColor = [UIColor whiteColor];
    //self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorInset = UIEdgeInsetsZero;
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    UIViewController *splash = [[SplashViewController alloc] init];
    prowl = [[UIBarButtonItem alloc]initWithTitle:@"Prowler" style:UIBarButtonItemStyleDone target:self action:@selector(getArticles)];
    qButton = [[UIBarButtonItem alloc] initWithTitle:@"Grades" style:UIBarButtonItemStyleDone target:self action:@selector(loadQ)];
    sendButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"new@3x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(sendBeep)];
    
    
    self.navigationItem.leftBarButtonItem = prowl;
    self.navigationItem.rightBarButtonItem = qButton;
    links = [[NSMutableArray alloc] init];
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.view.clipsToBounds = YES;
    
    
    [super viewDidLoad];
        
    

   
    
    
   /* if (![[NSUserDefaults standardUserDefaults] boolForKey:@"bb"]) {
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
-(void)showSpotlight
{
    [self performSegueWithIdentifier:@"viewspotlight" sender:self];

}
-(void)addSegmented
{
    NSMutableArray *segments = [NSMutableArray arrayWithObjects:@"Clubs", @"Beep", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
    segmentedControl.selectedSegmentIndex = 0;
    
    PFConfig *liveQuery = [PFConfig getConfig];
    if ([[liveQuery objectForKey:@"lockdown"] boolValue] == true) {
        [segmentedControl removeSegmentAtIndex:1 animated:NO];
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:12]} forState:UIControlStateSelected];
        [segmentedControl setTintColor:[UIColor whiteColor]];
        [segmentedControl insertSegmentWithTitle:@"BEEP LIVE" atIndex:1 animated:YES];
         segmentedControl.selectedSegmentIndex = 1;
        
    }
    [segmentedControl addTarget:self action:@selector(onSegmentedControlChanged:)  forControlEvents:UIControlEventValueChanged];
    self.navigationItem.title = @"Club Feed";
}
-(void)addGestures
{
    
    leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedMe:)];
    leftSwipe.delegate = leftSwipe;
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.tableView addGestureRecognizer:leftSwipe];
    

    rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedMe:)];
    rightSwipe.delegate = rightSwipe;
    [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.tableView addGestureRecognizer:rightSwipe];
   

    
    
}
-(void)swipedMe:(UISwipeGestureRecognizer *)sender
{
   
    if(sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        segmentedControl.selectedSegmentIndex = (segmentedControl.selectedSegmentIndex - 1) % segmentedControl.numberOfSegments;
        [self onSegmentedControlChanged:segmentedControl];
        NSLog(@"RIGHT");
        
    }
    
    if(sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        segmentedControl.selectedSegmentIndex = (segmentedControl.selectedSegmentIndex + 1) % segmentedControl.numberOfSegments;
        [self onSegmentedControlChanged:segmentedControl];
        NSLog(@"LEFT");
    }
    
    //NSLog(@"swiped");
    
    
}
-(void)onSegmentedControlChanged:(UISegmentedControl *)sender
{
        [self loadObjects];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}
-(void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
    [links addObject:item.link];
    
}
-(void)sendBeep
{
    
    [self performSegueWithIdentifier:@"sendBeep" sender:self];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    self.title = @"Feed";
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
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.titleView = nil;
        self.navigationItem.title = @"Panther Prowler";
        self.navigationItem.rightBarButtonItem = done;
    }
    
    
}
-(void)loadQ
{
    if(!self.tableView.isDecelerating && !self.tableView.isDragging)
    {
        //self.gradesWV.userInteractionEnabled = YES;
        //self.tableView.userInteractionEnabled = NO;
        gradesWV = [[UIWebView alloc] initWithFrame:self.view.bounds];
        gradesWV.scalesPageToFit = YES;
        self.tableView.scrollsToTop = NO;
        self.navigationItem.title = @"Q - Grades";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://q.conejousd.org/StudentPortal/Home/Login"]];
        [gradesWV loadRequest:request];
        [self.view addSubview:gradesWV];
        
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.titleView = nil;
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
    self.navigationItem.titleView = segmentedControl;
}

-(void)hideMe
{
    [self dismissViewControllerAnimated:NO completion:nil];
    // fixes bug where objects didn't load when app was loaded for the first time
    [self performSelectorOnMainThread:@selector(loadObjects) withObject:nil waitUntilDone:NO];
}

-(PFQuery *)queryForTable
{
    PFConfig *config = [PFConfig getConfig];
    
    switch (segmentedControl.selectedSegmentIndex)
    {
        case 0:
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
    
            return query;
            break;
        case 1:
            
            if([config[@"lockdown"] boolValue] == false)
            {
                // Gets all the approved ones
                PFQuery *firstQuery = [PFQuery queryWithClassName:@"sentBeeps"];
                [firstQuery whereKey:@"approved" equalTo:[NSNumber numberWithBool:true]];
                
                
                // Gets all the unapproved ones, belonging to the user
                PFQuery *secondQuery = [PFQuery queryWithClassName:@"sentBeeps"];
                [secondQuery whereKey:@"person" equalTo:installation.objectId];
                [secondQuery whereKey:@"approved" equalTo:[NSNumber numberWithBool:false]];
                
               
                // Compiles both results into one query
                query = [PFQuery orQueryWithSubqueries:@[firstQuery, secondQuery]];
                
                
                [query orderByDescending:@"createdAt"];
                return query;
            }
        else
        {
            query = [PFQuery queryWithClassName:@"beep"];
            [query orderByDescending:@"createdAt"];
        }
        
        return query;
        break;
            
        
    }
    return nil;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
#warning Potentially incomplete method implementation.
    
    // Return the number of sections.
    
    
    return 1;
    
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(FeedCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Feed"];
    /*cell.bg.image = [UIImage imageNamed:@""];
    cell.bg.alpha = 0.4;
    cell.clubText.selectable = YES;
    cell.bg.hidden = YES;*/
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"viewspotlight"])
    {
        BeepSpotlightVC *spotlightVC = segue.destinationViewController;
        spotlightVC.beepText = self.spotlightText;
        spotlightVC.outofApp = YES;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feed"];
    /*cell.bg.image = [UIImage imageNamed:@""];
    cell.bg.alpha = 0.4;
    cell.bg.hidden = YES;*/
   // cell.backgroundColor = [UIColor whiteColor];
    //NSString *username = [[PFUser currentUser]username];
    
    // CLUBS
    if(segmentedControl.selectedSegmentIndex == 0)
    {
     self.navigationItem.rightBarButtonItem = qButton;
     self.navigationItem.leftBarButtonItem = prowl;
     cell.clubName.text = object[@"Name"];
     cell.objId = [object objectForKey:@"clubName"];
     cell.clubText.text = [object objectForKey:@"feedPost"];
     cell.clubName.textColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];

        
    }
    // BEEP
    if(segmentedControl.selectedSegmentIndex == 1)
    {
        self.navigationItem.rightBarButtonItem = sendButton;
        self.navigationItem.leftBarButtonItem = nil;
        cell.clubName.text = @"Beep";
        //cell.objId = [object objectForKey:@"clubName"];
        beepString = object[@"beepText"];
        
        
        
        
       
        if([object[@"live"]boolValue] == true)
        {
            cell.clubName.text = @"LIVE";
            cell.clubName.textColor = [UIColor redColor];
            
        }
        else
        {
            //cell.clubName.text = @"Beep";
            cell.clubName.textColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
        }
        cell.clubText.text = beepString;
        
        
    }

    /*if([username isEqualToString:cell.objId])
        {
            cell.removeButton.hidden = NO;
            [cell.removeButton addTarget:self action:@selector(deleteMe:) forControlEvents:UIControlEventTouchUpInside];
            [cell.feedView addSubview:cell.removeButton];
            
        }*/
    
    self.tableView.separatorColor = [UIColor colorWithRed:(70.0/255.0) green:(70.0/255.0) blue:(70.0/255.0) alpha:1.0];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YY, hh:mm a"];
    NSString *date = [dateFormatter stringFromDate:object.createdAt];
    
    //NSDateFormatter *getDates =
    
    
    
    cell.dateLabel.text = date;
  //  cell.dateLabel.alpha = 0.6;
    
    
    cell.clubText.selectable = YES;
    
   // cell.clubName.alpha = 1;
    
    
   // cell.clubText.alpha = 1;
    cell.clubText.scrollsToTop = NO;
    
    
    
    
   // [cell.feedView addSubview:cell.clubName];
    
  // //[cell.feedView addSubview:cell.clubText];
   // [cell.feedView addSubview:cell.dateLabel];
    
    
    
    
    
    cell.userInteractionEnabled = YES;
    return cell;
    
    
    
}


@end
