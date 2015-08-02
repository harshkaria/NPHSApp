//
//  BeepViewController.h
//  NPHSApp
//
//  Created by Harsh Karia on 3/15/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "MHFacebookImageViewer.h"
@interface BeepViewController : PFQueryTableViewController<MHFacebookImageViewerDatasource>
@property PFObject *topicObject;

@end
