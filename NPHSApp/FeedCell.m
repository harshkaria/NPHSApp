//
//  FeedCell.m
//  NPHSApp
//
//  Created by Harsh Karia on 11/23/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "FeedCell.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "FeedController.h"
@implementation FeedCell
@synthesize feedView, clubName, clubText, dateLabel, bg, removeButton, objId;
- (void)awakeFromNib {
    // Initialization code
    removeButton.hidden = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
    
    // Configure the view for the selected state
    //self.selected = NO;
}
- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}


@end
