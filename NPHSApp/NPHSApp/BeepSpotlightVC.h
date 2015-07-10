//
//  BeepSpotlightVC.h
//  NPHSApp
//
//  Created by Harsh Karia on 4/5/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeepSpotlightVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *beepTextView;
//-(id)initWithString:(NSString *)spotlightText;
- (IBAction)doneButton:(id)sender;
@property NSString *beepText;
@property BOOL outofApp;
@end
