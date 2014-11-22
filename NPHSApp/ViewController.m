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
@interface ViewController ()
@property (nonatomic) PFInstallation *installation;
@end

@implementation ViewController
@synthesize installation;
- (void)viewDidLoad {
    [super viewDidLoad];
    installation = [PFInstallation currentInstallation];
    [self checkDay];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasPerformedFirstLaunch"]) {
        UIImage *image = [UIImage imageNamed:@"nphs1.jpeg"];
        CGSize imageSize = [image size];
        
        OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"Welcome" body:@"This NPHS app will rock yo socks off" image:nil buttonText:nil action:nil];
        OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"Introducing Smart Notfications" body:@"Subscribe to the activites you are involved in, and follow football games, etc as they happen" image:[UIImage imageNamed:@"nphs2.jpg"] buttonText:nil action:nil];
        OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc]initWithTitle:@"Introducing Smart Reminders" body:@"Interact like never before. Now, you can view live scores for athletics, and automatically get new reminders that are tailored to suit you." image:nil buttonText:nil action:nil];
        
        
        [firstPage setUnderIconPadding:-120  ];
        secondPage.topPadding = 40;
        [thirdPage setUnderIconPadding:-175];
        OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"nphs2.jpg"] contents:@[firstPage, secondPage, thirdPage]];
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
        [self presentViewController:onboardingVC animated:NO completion:nil];
        
        
    }
    
    UIViewController *splash = [[SplashViewController alloc] init];
    [self presentViewController:splash animated:NO completion:nil];
    [self performSelector:@selector(hideMe) withObject:nil afterDelay:4.0];
    if(installation.badge != 0)
    {
        installation.badge = 0;
        [installation saveInBackground];
    }
   // DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
    
    //[self.view addSubview:draggableBackground];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor yellowColor]};
  
    [self background];
    
}
-(void)background
{
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundView.image = [UIImage imageNamed:@"nphs2.jpg"];
    [self.view addSubview:backgroundView];
    UIButton *buttonOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonOne setTitle:@"Subscribe to App Club" forState:UIControlStateNormal];
    buttonOne.frame = CGRectMake(124, 110, 156, 30);
    [buttonOne addTarget:self action:@selector(subApp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonOne];
    

}
-(void)hideMe
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)checkDay
{

NSDate *saved = [[NSUserDefaults standardUserDefaults]objectForKey:@"date"];
   
    int plusDays =  2;
    NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setDay:plusDays];
   
    NSCalendar *calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *bDay = [calender dateByAddingComponents:dateComponents toDate:saved options:0];
   NSComparisonResult dComp =[calender compareDate:bDay toDate:[NSDate date] toUnitGranularity:(NSDayCalendarUnit)];
  NSInteger day = [calender component:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSLog(@"%ld", day);
    
   
    
    
    
    
    
   
   if(dComp == NSOrderedSame)
   {
       NSLog(@"hi");
       
       [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"date"];
       [[NSUserDefaults standardUserDefaults]synchronize];
     
       
       
       
   }
    else
    {
        
        
        
    }
   
   }
    



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)football:(id)sender {
    
    [installation addUniqueObject:@"football" forKey:@"channels"];
    [installation saveInBackground];
    NSLog(@"Pressed");
}

- (void)subApp:(UIButton *)button
{
   
    [installation addUniqueObject:@"appClub" forKey:@"channels"];
    [installation saveInBackground];
    NSLog(@"Pressed");
}
- (IBAction)unSub:(id)sender {
    
    [installation removeObject:@"football" forKey:@"channels"];
    [installation saveInBackground];
}
@end
