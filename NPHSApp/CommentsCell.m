//
//  CommentsCell.m
//  NPHSApp
//
//  Created by Harsh Karia on 6/18/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "CommentsCell.h"
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"

@implementation CommentsCell
@synthesize commentText, tagView, dogTag, commentImageView;

-(void)awakeFromNib
{
    
    [self.commentImageView setupImageViewer];
    CGPoint offset = CGPointMake(0, self.commentText.contentSize.height - self.commentText.frame.size.height);
  //  [self.commentText setContentOffset: CGPointMake(0,0) animated:NO];
    //[self.commentText setContentOffset:offset animated:YES];
    //commentText.textContainerInset = UIEdgeInsetsZero;
    //commentText.textContainer.lineFragmentPadding = 0;
}

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
