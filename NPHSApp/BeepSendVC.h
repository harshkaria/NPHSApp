//
//  BeepSendVC.h
//  NPHSApp
//
//  Created by Harsh Karia on 3/24/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CustomizableCamera/Camera View/CameraSessionView.h"
#import "TGCameraViewController.h"
#import "JSImagePickerViewController.h"
#import "MHFacebookImageViewer.h"


@interface BeepSendVC : UIViewController<UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, JSImagePickerViewControllerDelegate, CACameraSessionDelegate, UIGestureRecognizerDelegate, MHFacebookImageViewerDatasource>
@property (weak, nonatomic) IBOutlet UITextView *beepTextView;
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
-(BOOL)containsBadWords:(NSString * )string;
@property PFObject *commentObject;
@property (weak, nonatomic) IBOutlet UIImageView *beepImage;
- (IBAction)removeImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *removeImageButton;
-(void)showCamera;
@end
