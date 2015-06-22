//
//  AppDelegate.m
//  NPHSApp
//
//  Created by Harsh Karia on 9/14/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
//#import "OnboardingViewController.h"
//#import "OnboardingContentViewController.h"
#import "FeedController.h"
#import "RKDropdownAlert.h"
#import <ParseCrashReporting/ParseCrashReporting.h>
#import "BeepSpotlightVC.h"
#import "SplashViewController.h"
@interface AppDelegate ()
@property UINavigationController *navController;
@property UITabBarController *tabBarController;
@end

@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
@implementation AppDelegate
// publicname:(type *)nameinthecode
@synthesize navController, tabBarController, beepText;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ParseCrashReporting enable];
        // Override point for customization after application launch.
    // NORMAL
    /*[Parse setApplicationId:@"ca45HTXpVgPlUi1w0kfUR1rcU4p56g398F2N1UBa"
                  clientKey:@"HZYxCrJvEaTPvJFqVWjP1xvGzxjlF2cbEgEpaYQ2"];*/

    // THREADS
    [Parse setApplicationId:@"7nKYjaRV0FKR1QeU74bT5RiVPuujLk1xuBOcYas8"
                  clientKey:@"Q0Sq9hazXcLrKpTJ9Oe2KDlR1JZE9kXfEKH9G0dL"];
    //BETA
    //[Parse setApplicationId:@"zScBzNliDkwbRIOwiuLY71s31ZWBkb6Gd2pDTtAr"
    //clientKey:@"UeIZ0ilVrYrYkKIXsNExpsmCfsFvME0f58X5xFZD"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"Feed"];
    navController  = (UINavigationController *)self.window.rootViewController;
    

    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else
    {
        // Register for Push Notifications before iOS 8
            [application registerForRemoteNotificationTypes:
                        (UIRemoteNotificationTypeBadge |
                         UIRemoteNotificationTypeAlert |
                         UIRemoteNotificationTypeSound)];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  
    [[UINavigationBar appearance]setTitleTextAttributes:
    @{
      NSForegroundColorAttributeName:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1],
      NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:22
     ]}];
    
    [[UINavigationBar appearance]setBackgroundColor:[UIColor blackColor]];
    [[UINavigationBar appearance]setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance]setTranslucent:NO];
    
    
    [[UITabBar appearance]setTranslucent:NO];
    [[UITabBar appearance]setBarTintColor:[UIColor blackColor]];
    //UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
   
    
    
    [[UITabBarItem appearance]setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName: [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1],
       NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:12]
      } forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:
       @{
       NSForegroundColorAttributeName: [UIColor whiteColor]
       } forState:UIControlStateSelected];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]];
    [[UISegmentedControl appearance]setTintColor: [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]];
    
    // SPOTLIGHT BEEP
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if([notificationPayload objectForKey:@"id"])
    {
        NSString *myBeep = [notificationPayload objectForKey:@"id"];
        
        PFObject *beepObject = [PFObject objectWithoutDataWithClassName:@"sentBeeps" objectId:myBeep];
        [beepObject fetchIfNeeded];
        
        beepText = beepObject[@"beepText"];
               

    }
    
    else
    {
        FeedController *feed = [[FeedController alloc]init];

        [feed loadObjects];
        
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    //currentInstallation.channels = @[ @"global", @"asg", ];
    [currentInstallation addUniqueObject:@"global" forKey:@"channels"];
    [currentInstallation addUniqueObject:@"asg" forKey:@"channels"];
    [currentInstallation addUniqueObject:@"admin" forKey:@"channels"];
    
    [currentInstallation saveInBackground];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // if push is recieved in the app, while app is running
    // gets it from 'aps' dictionairy
    NSDictionary *notification = [userInfo objectForKey:@"aps"];
    NSString *object = [userInfo objectForKey:@"id"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if(object)
    {
        PFObject *beepObject = [PFObject objectWithoutDataWithClassName:@"sentBeeps" objectId:object];
        [beepObject fetch];
        NSString *beepTexts = beepObject[@"beepText"];
        BeepSpotlightVC *spotlight = [storyboard instantiateViewControllerWithIdentifier:@"Spotlight"];
        spotlight.beepText = beepTexts;
        [self.navController presentViewController:spotlight animated:NO completion:nil];
    
    }
    else
    {
    [RKDropdownAlert show];
    [RKDropdownAlert title:@"Notification" message:[notification objectForKey:@"alert"] backgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] textColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]time:5];
    }
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if(currentInstallation.badge != 0)
    {
    currentInstallation.badge = 0;
    [currentInstallation saveInBackground];
    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if(currentInstallation.badge != 0)
    {
        currentInstallation.badge = 0;
        [currentInstallation saveInBackground];
    }
  

    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
