//
//  SubscriptionsCell.m
//  NPHSApp
//
//  Created by Harsh Karia on 12/22/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "SubscriptionsCell.h"

@implementation SubscriptionsCell
@synthesize contentView, clubLabel, username;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
