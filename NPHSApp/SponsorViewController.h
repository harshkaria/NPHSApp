//
//  SponsorViewController.h
//  NPHSApp
//
//  Created by Harsh Karia on 7/27/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SponsorViewController : UIViewController

@property PFObject *sponsoredObject;
@property (weak, nonatomic) IBOutlet UIImageView *sponsorLogo;
@property (weak, nonatomic) IBOutlet UITextView *discountText;
@property (weak, nonatomic) IBOutlet UITextView *addressText;
@property (weak, nonatomic) IBOutlet UITextView *phoneNumberText;
@property (weak, nonatomic) IBOutlet UITextView *emailText;
@property (weak, nonatomic) IBOutlet UITextView *websiteText;

@end
