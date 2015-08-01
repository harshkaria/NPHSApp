//
//  CommentsCell.m
//  NPHSApp
//
//  Created by Harsh Karia on 6/18/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "CommentsCell.h"
#import "MHFacebookImageViewer.h"

@implementation CommentsCell
@synthesize commentText, tagView, dogTag, commentImageView;



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)staffStyle
{
    self.tagView.backgroundColor = [UIColor redColor];
    [self.dogTag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.dogTag.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
}
@end
