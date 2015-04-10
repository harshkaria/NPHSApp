//
//  BeepSpotlightVC.m
//  NPHSApp
//
//  Created by Harsh Karia on 4/5/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "BeepSpotlightVC.h"
#import "SplashViewController.h"
#import "FeedController.h"
@interface BeepSpotlightVC ()
@end

@implementation BeepSpotlightVC
@synthesize beepText, beepTextView, outofApp;

- (void)viewDidLoad
{
    
    self.navigationItem.title = @"";
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    beepText = [NSString stringWithFormat:@"\"%@\"", beepText];
    beepTextView.text = beepText;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doneButton:(id)sender
{
    if(!outofApp)
    {
        FeedController *feed = [[FeedController alloc]init];
        [self dismissViewControllerAnimated:YES completion:^
        {
            [self presentViewController:feed animated:NO completion:nil];
        }];
    }
    else
    {
        [self performSegueWithIdentifier:@"backToFeed" sender:self];
    }
   
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"backToFeed"])
    {
        FeedController *feedVC = segue.destinationViewController;
        feedVC.comingBack = YES;
        self.navigationController.navigationItem.backBarButtonItem = nil;
        feedVC.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [feedVC loadObjects];
        
    }
}
@end
