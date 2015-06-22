//
//  BeepSendVC.h
//  NPHSApp
//
//  Created by Harsh Karia on 3/24/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BeepSendVC : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *beepTextView;
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
-(BOOL)containsBadWords:(NSString * )string;
@property PFObject *commentObject;
@end
