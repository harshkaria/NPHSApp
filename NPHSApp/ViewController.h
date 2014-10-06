//
//  ViewController.h
//  NPHSApp
//
//  Created by Harsh Karia on 9/14/14.
//  Copyright (c) 2014 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *football;
- (IBAction)football:(id)sender;
- (IBAction)subApp:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *unSub;
- (IBAction)unSub:(id)sender;


@end

