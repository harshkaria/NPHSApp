//
//  NewTopicController.h
//  NPHSApp
//
//  Created by Harsh Karia on 6/16/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "ViewController.h"

@interface NewTopicController : ViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *topicField;
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UITextField *promptField;
@property (weak, nonatomic) IBOutlet UILabel *promptCount;


@end