//
//  ThreadsCell.m
//  NPHSApp
//
//  Created by Harsh Karia on 6/15/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "ThreadsCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ThreadsCell
@synthesize custom, topicLabel, bgView;

- (void)awakeFromNib {
    // Initialization code
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = CGRectMake(0, 0, 380, 115);
    [self.bgView addSubview:effectView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
