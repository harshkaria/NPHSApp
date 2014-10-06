//
//  NotificationViewController.h
//  NPHSApp
//
//  Created by Harsh Karia on 9/27/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController<UITextFieldDelegate>


- (IBAction)sendButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;
@property (weak, nonatomic) IBOutlet UITextField *notificationField;

@end
