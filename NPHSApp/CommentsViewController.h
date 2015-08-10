//
//  CommentsViewController.h
//  NPHSApp
//
//  Created by Harsh Karia on 6/18/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "MarqueeLabel.h"
#import "JHTickerView.h"

@interface CommentsViewController : PFQueryTableViewController
@property PFObject *commentPointer;
@property UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet MarqueeLabel *promptLabel;
@property JHTickerView *promptView;
-(void)endAnimationHandle;



@end
