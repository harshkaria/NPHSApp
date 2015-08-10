//
//  BeepSendVC.m
//  NPHSApp
//
//  Created by Harsh Karia on 3/24/15.
//  Copyright (c) 2015 Harsh Karia. All rights reserved.
//

#import "BeepSendVC.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "RKDropdownAlert.h"
#import "CommentsViewController.h"
#import "CustomizableCamera/Camera View/CameraSessionView.h"
#import "TGCameraViewController.h"
#import "JSImagePickerViewController.h"
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"

@interface BeepSendVC ()

@property UIBarButtonItem *sendButton;
@property NSString *finalString;
@property NSMutableArray *badWords;
@property NSTimer *timer;
@property NSInteger timeInt;
@property NSMutableAttributedString *commentString;
@property (nonatomic, strong) CameraSessionView *cameraView;
@property NSData *parseImageData;
@property BOOL shouldHideStatusBar;


@end

@implementation BeepSendVC
@synthesize beepTextView, finalString, badWords, timer, timeInt, commentObject, characterLabel, commentString, cameraView, parseImageData, beepImage, shouldHideStatusBar;


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
  
}

- (void)viewDidLoad {
    self.navigationItem.title = commentObject[@"topic"];
    [super viewDidLoad];
    //self.navigationItem.title = nil;
    shouldHideStatusBar = NO;

    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1];
    
    
    [beepImage setHidden:YES];
    [self.removeImageButton setHidden:YES];
    
    beepTextView.layer.cornerRadius = 4;
    beepTextView.layer.borderWidth = 1;
    beepTextView.layer.borderColor = [[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1] CGColor];
    beepTextView.delegate = self;
    [commentString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1],
                                   NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:21]}
                           range:[beepTextView.text rangeOfString:beepTextView.text]];
    

    
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Beep" style:UIBarButtonItemStyleDone target:self action:@selector(sendBeep)];
    UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(showActions)];
    self.navigationItem.rightBarButtonItems = @[sendButton, camera];
    [beepImage setupImageViewer];
    
   // [self addGesture];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)addGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageActions)];
    tapGesture.delegate = self;
    beepImage.userInteractionEnabled = YES;
    [beepImage addGestureRecognizer:tapGesture];
}
-(void)showImageActions
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"View Picture", @"Remove Picture", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}
-(void)showActions
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Picture", @"Choose From Library" , nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 0)
    {
    switch (buttonIndex) {
        case 0:
            NSLog(@"Taking One");
            cameraView = [[CameraSessionView alloc] initWithFrame:self.navigationController.view.bounds];
            cameraView.delegate = self;
            [cameraView setTopBarColor:[UIColor colorWithRed:(212.0/255.0) green:(175.0/255.0) blue:(55.0/255.0) alpha:1]];
            [cameraView hideCameraToogleButton];
            [cameraView prefersStatusBarHidden];
            [self.navigationController.view addSubview:cameraView];

            break;
        case 1:
            NSLog(@"Opening Library");
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:NULL];

            break;
    }
    }
    if(actionSheet.tag == 1)
    {
            switch (buttonIndex) {
                case 0:
                    NSLog(@"Yo");
                    break;
                case 1:
                    //[self
                    
                    break;
            }
    }
  }
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.parseImageData = UIImagePNGRepresentation(chosenImage);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.beepImage.image = chosenImage;
    [beepImage setHidden:NO];
    [self.removeImageButton setHidden:NO];
    
}

-(void)didCaptureImageWithData:(NSData *)imageData {
    [self.beepTextView resignFirstResponder];
    [self.cameraView removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
    //self.tabBarController.tabBar.hidden = NO;
    NSLog(@"Captured");

    parseImageData = imageData;
    self.beepImage.image = [UIImage imageWithData:imageData];
    [beepImage setHidden:NO];
    [self.removeImageButton setHidden:NO];
    //[self sendBeep];
    
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    //commentString = [[NSMutableAttributedString alloc] initWithString:@""];
    beepTextView.text = @"";
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger amount = (199 - [newString length] + 1);
    self.characterLabel.textColor = [UIColor whiteColor];
    self.characterLabel.text = [NSString stringWithFormat:@"%lu", amount];
    if(amount == -1)
    {
        self.characterLabel.text = @"0";
        self.characterLabel.textColor = [UIColor redColor];
        return NO;
    }
  
    return YES;
}



-(void)sendBeep
{
    PFInstallation *installation = [PFInstallation currentInstallation];
    PFObject *installObject = [PFObject objectWithoutDataWithClassName:@"_Installation" objectId:installation.objectId];
    
    //PFQuery *query = [PFInstallation query];
    beepTextView.text = [NSString stringWithFormat:@"%@", beepTextView.text];
    NSLog([NSString stringWithFormat:@"%li seconds", (long)timeInt]);
    [installObject fetchIfNeeded];
    
    NSString *dogTag = [installObject objectForKey:@"dogTag"];
    NSString *topicName = [commentObject objectForKey:@"topic"];
    
    
    if(![self containsBadWords:[beepTextView.text lowercaseString]] && timeInt == 0 && beepTextView.text.length > 0 && ![beepTextView.text isEqualToString:@"Enter Beep Here"] && [installObject[@"banned"] boolValue] == false)
    {
        PFObject *object = [PFObject objectWithClassName:@"Comments"];
        
        if([[installObject objectForKey:@"authorized"] boolValue] == YES)
        {
            object[@"staff"] = [NSNumber numberWithBool:YES];
        }
        else
        {
            object[@"staff"] = [NSNumber numberWithBool:NO];

        }
        
        object[@"text"] = beepTextView.text;
        object[@"creator"] = installation.objectId;
        object[@"dogTag"] = dogTag;
        object[@"approved"] = [NSNumber numberWithBool:false];
        object[@"topicPointer"] = commentObject;
        object[@"topicObjectId"] = commentObject.objectId;
        object[@"voteNumber"] = [NSNumber numberWithInt:0];
        object[@"topic"] = commentObject[@"topic"];
        object[@"hasImage"] = [NSNumber numberWithBool:false];
        
        if(self.parseImageData)
        {
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:parseImageData];
        object[@"image"] = imageFile;
        object[@"hasImage"] = [NSNumber numberWithBool:true];
        }
        
        //PFInstallation *installation = [PFInstallation currentInstallation];
        [installation incrementKey:@"ranker"];
        [installation saveInBackground];
        [commentObject incrementKey:@"commentCount"];
        [commentObject saveInBackground];
        
        [object saveInBackgroundWithBlock:^(BOOL success, NSError *error)
        {
            if(success & !error)
            {
            [beepTextView resignFirstResponder];
            [self.view endEditing:YES];
            [RKDropdownAlert show];
            [RKDropdownAlert title:@"Beeped" message:@"Your beep was sent." time:3];
            //beepTextView.text = @"Enter Beep Here";
            NSMutableArray *mentionsArray = [self findMentions:beepTextView.text];
                PFPush *push = [[PFPush alloc] init];
                PFQuery *query = [PFQuery queryWithClassName:@"_Installation"];
                [query whereKey:@"authorized" equalTo:[NSNumber numberWithBool:YES]];
                [push setQuery:query];
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSString stringWithFormat:@"\"%@\" needs approval.", beepTextView.text], @"alert",
                                            @"default", @"sound",
                                            nil];
                [push setData:dictionary];
                [push sendPushInBackground];

            
            if([mentionsArray count] > 0)
            {
            PFPush *push = [[PFPush alloc] init];
            PFQuery *query = [PFQuery queryWithClassName:@"_Installation"];
            [query whereKey:@"dogTag" containedIn:mentionsArray];
            [push setQuery:query];
             NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%@ tagged you in %@.", dogTag, topicName], @"alert",
                                    @"default", @"sound",
                                            nil];
            [push setData:dictionary];
            [push sendPushInBackground];
            }
            
                self.characterLabel.text = @"";
                //CommentsViewController *commentsVC = [[CommentsViewController alloc] init];
                //[commentsVC endAnimationHandle];
                //commentsVC.commentPointer = commentObject;
                [self.navigationController popViewControllerAnimated:YES];
                //[self performSegueWithIdentifier:@"doneCommenting" sender:self];
                
            }
            beepTextView.text = @"Enter Beep Here";
            timeInt = 45;
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeOut:) userInfo:nil repeats:YES];
            
            
        }];
        
        
    }
    else if(timeInt > 0)
    {
       
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Too Much" message:[NSString stringWithFormat:@"Please wait %li seconds before beeping again", (long)timeInt] time:4];
    }
    else if([beepTextView.text isEqualToString:@"Enter Beep Here"] || !(beepTextView.text.length > 0))
    {
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Enter something" message:@"Please type in a Beep before sending" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];
        
    }
    else if([installObject[@"banned"]boolValue] == true)
    {
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"You're banned!" message:[NSString stringWithFormat:@"To dispute this, take a screenshot now. ID: %@", installation.objectId] backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];

        
    }
    else if([self containsBadWords:[beepTextView.text lowercaseString]])
    {
        NSLog([NSString stringWithFormat:@"%li seconds", (long)timeInt]);
        [RKDropdownAlert show];
        [RKDropdownAlert title:@"Bad Words!" message:@"Contains naughty words..." backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:3];
    }
   
}
-(void)timeOut:(NSTimer *)countdown
{
    timeInt -= 1;
    if(timeInt <= 0)
    {
        timeInt = 0;
        [countdown invalidate];
    }
}
-(NSMutableArray *)findMentions:(NSString *)mention
{
    NSMutableArray *mentionsArray = [[NSMutableArray alloc] init];
    NSArray *mentions = [mention componentsSeparatedByString:@" "];
    for(NSString *mention in mentions)
    {
        if([mention hasPrefix:@"@"])
        {
            NSString *newMentionsString = [mention stringByReplacingOccurrencesOfString:@"@" withString:@""];
            newMentionsString = [newMentionsString uppercaseString];
            [mentionsArray addObject:newMentionsString];
        }
    }
    return mentionsArray;
    
}

-(BOOL)containsBadWords:(NSString * )string
{
    
   /* badWords = [[NSMutableArray alloc] init];
    [badWords addObject:@"fuck"];
    [badWords addObject:@"shit"];*/
    //[badWords objectAtIndex:<#(NSUInteger)#>]
    // DO arrays
    if(([string containsString:@"fuck"] || [string containsString:@"shit"] || [string containsString:@"bitch"] || [string containsString:@"cunt"] || [string containsString:@"dick"] || [string containsString:@"tit"] || [string containsString:@"puss"] || [string containsString:@"nig"] || [string containsString:@"porn"] || [string containsString:@"8="] || [string containsString:@"8-"] || [string containsString:@"(.)(.)"]))
    {
        return YES;
    }
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"doneCommenting"])
    {
        CommentsViewController *commentsVC = segue.destinationViewController;
        commentsVC.commentPointer = commentObject;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)removeImage:(id)sender {
    NSLog(@"Pressed");
    self.parseImageData = nil;
    self.beepImage.hidden = YES;
    self.removeImageButton.hidden = YES;
}

-(BOOL)prefersStatusBarHidden
{
    return shouldHideStatusBar;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
