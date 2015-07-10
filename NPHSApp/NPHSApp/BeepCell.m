//
//  BeepCell.m
//  NPHSApp
//
//  Created by Harsh Karia on 3/9/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "BeepCell.h"

@implementation BeepCell
@synthesize beepText;
- (void)awakeFromNib {
    // Initialization code
    //self.separatorInset = UIEdgeInsetsZero;
    beepText.editable = NO;
    beepText.selectable = YES;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}


@end
