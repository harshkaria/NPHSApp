//
//  AppDelegate.m
//  NPHSApp
//
//  Created by Harsh Karia on 9/14/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "OnboardingViewController.h"
#import "OnboardingContentViewController.h"
#import "FeedController.h"
#import "RKDropdownAlert.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse setApplicationId:@"ca45HTXpVgPlUi1w0kfUR1rcU4p56g398F2N1UBa"
                  clientKey:@"HZYxCrJvEaTPvJFqVWjP1xvGzxjlF2cbEgEpaYQ2"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
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
     CIImage *image = [[CIImage alloc] initWithContentsOfURL:[NSURL URLWithString:NAV_BG]];
    
     // [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:NAV_BG] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance]setTitleTextAttributes:
    @{
      NSForegroundColorAttributeName:[UIColor yellowColor],
      NSFontAttributeName: [UIFont fontWithName:@"Dekar Light" size:32
     ]}];
    
    [[UINavigationBar appearance]setBackgroundColor:[UIColor blackColor]];
    [[UINavigationBar appearance]setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance]setTranslucent:NO];
    
    
    [[UITabBar appearance]setTranslucent:NO];
    [[UITabBar appearance]setBarTintColor:[UIColor blackColor]];
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    
    
    [[UITabBarItem appearance]setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName: [UIColor yellowColor],
       NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:12]
      } forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:
       @{
       NSForegroundColorAttributeName: [UIColor whiteColor]
       } forState:UIControlStateSelected];
   NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if(notificationPayload)
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
    [RKDropdownAlert show];
    [RKDropdownAlert title:@"Notification" message:[notification objectForKey:@"alert"] backgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] textColor:[UIColor colorWithRed:1 green:(251.0/255.0) blue:(38.0/255.0) alpha:1]time:3];
    
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
    if(!([currentInstallation.channels containsObject:@"global"] && [currentInstallation.channels containsObject:@"asg"] && [currentInstallation.channels containsObject:@"admin"]))
    {
        
    [currentInstallation addUniqueObject:@"global" forKey:@"channels"];
    [currentInstallation addUniqueObject:@"asg" forKey:@"channels"];
    [currentInstallation addUniqueObject:@"admin" forKey:@"channels"];
    
    [currentInstallation saveInBackground];
    }

    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
