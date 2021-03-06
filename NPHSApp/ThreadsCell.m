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
@synthesize custom, topicLabel, bgView, effectView;

- (void)awakeFromNib {
    // Initialization code
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = CGRectMake(0, 0, 400, 115);
    [self.bgView addSubview:effectView];
    
}

-(void)removeBlur
{
    [self.effectView removeFromSuperview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end