//
//  ViewController.m
//  NPHSApp
//
//  Created by Harsh Karia on 9/14/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "DraggableViewBackground.h"
#import "OnboardingContentViewController.h"
#import "OnboardingViewController.h"
#import "SplashViewController.h"
#import "AppDelegate.h"
#import "FeedController.h"
//#import "FeedViewController.h";
@interface ViewController ()
@property (nonatomic) PFInstallation *installation;
@end

@implementation ViewController
@synthesize installation;
- (void)viewDidLoad {
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    UIViewController *splash = [[SplashViewController alloc] init];
    [self presentViewController:splash animated:NO completion:nil];
    [self performSelector:@selector(hideMe) withObject:nil afterDelay:3];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"date"];
    
    [super viewDidLoad];
    installation = [PFInstallation currentInstallation];
    
   
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasPerformedFirstLaunch"]) {
        self.navigationController.navigationBar.hidden = YES;
        
        
        OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"Welcome" body:@"This NPHS app will rock yo socks off" image:nil buttonText:nil action:nil];
        OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"Introducing Smart Notfications" body:@"Subscribe to the activites you are involved in, and follow football games, etc as they happen" image:[UIImage imageNamed:@"nphs2.jpg"] buttonText:nil action:nil];
        OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc]initWithTitle:@"Introducing Smart Reminders" body:@"Interact like never before. Now, you can view live scores for athletics, and automatically get new reminders that are tailored to suit you." image:nil buttonText:nil action:nil];
        OnboardingContentViewController *fourthPage = [[OnboardingContentViewController alloc]initWithTitle:@"Precise Design" body:@"We designed the NPHS with you in mind. In fact, most of the pictures you see in this app, including the background on the pages, will be updated with pictures you take. Tweet away to @harshkaria"  image:nil buttonText:nil action:nil];
        
        
        [firstPage setUnderIconPadding:-120  ];
        secondPage.topPadding = 40;
        [thirdPage setUnderIconPadding:-175];
        [fourthPage setUnderIconPadding:-175];
        OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"nphs2.jpg"] contents:@[firstPage, secondPage, thirdPage, fourthPage]];
        onboardingVC.shouldMaskBackground = YES;
        onboardingVC.allowSkipping = YES;
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
        [self background];
        
        
    }
    else
    {
   
    if(installation.badge != 0)
    {
        installation.badge = 0;
        [installation saveInBackground];
    }
   // DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
    
    //[self.view addSubview:draggableBackground];
  
    //[self background];
    
   
    
    }
    
    
    
}
// child view controller
-(void)background
{
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundView.image = [UIImage imageNamed:VIEW_BG];
    [self.view addSubview:backgroundView];
   /* UIButton *buttonOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonOne setTitle:@"Subscribe to App Club" forState:UIControlStateNormal];
    buttonOne.frame = CGRectMake(124, 110, 156, 30);
    [buttonOne addTarget:self action:@selector(subApp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonOne];*/
    
    

}
-(void)hideMe
{
    [self dismissViewControllerAnimated:NO completion:nil];
   
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
