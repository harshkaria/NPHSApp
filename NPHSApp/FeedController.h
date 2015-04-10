//
//  FeedController.h
//  NPHSApp
//
//  Created by Harsh Karia on 11/23/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MWFeedParser.h"
#import <ParseUI/ParseUI.h>
@interface FeedController : PFQueryTableViewController<MWFeedParserDelegate>
@property NSString *spotlightText;
@property BOOL comingBack;
@end
