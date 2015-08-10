//
//  LiveScoresVC.h
//  NPHSApp
//
//  Created by Harsh Karia on 8/6/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface LiveScoresVC : UIViewController<UITextFieldDelegate>
@property PFObject *liveObject;
@property (weak, nonatomic) IBOutlet UITextField *pantherScore;
@property (weak, nonatomic) IBOutlet UITextField *opponentScore;
- (IBAction)updateButton:(id)sender;
@end
