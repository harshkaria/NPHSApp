//
//  LoginViewController.h
//  NPHSApp
//
//  Created by Harsh Karia on 9/28/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)logIn:(id)sender;

@end
