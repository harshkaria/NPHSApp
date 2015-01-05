//
//  FeedCell.m
//  NPHSApp
//
//  Created by Harsh Karia on 11/23/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import "FeedCell.h"
#import "AppDelegate.h"
@implementation FeedCell
@synthesize feedView, clubName, clubText, dateLabel, bg;
- (void)awakeFromNib {
    // Initialization code
   clubText.dataDetectorTypes = UIDataDetectorTypeLink;
    clubText.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:14]};
    clubText.scrollEnabled = NO;
    
    
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
