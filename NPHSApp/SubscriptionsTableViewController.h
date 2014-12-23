//
//  SubscriptionsTableViewController.h
//  NPHSApp
//
//  Created by Harsh Karia on 10/12/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface SubscriptionsTableViewController : PFQueryTableViewController
@property (weak, nonatomic) IBOutlet UITableView *SubscriptionTableView;
@property (weak, nonatomic) IBOutlet UISwitch *test;
@property (weak, nonatomic) IBOutlet UIView *greenView;



@end
