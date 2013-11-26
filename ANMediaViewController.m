//
//  ANMediaViewController.m
//  Yade
//
//  Created by Anirudh narla on 11/21/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANMediaViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ANMediaViewController ()

@end

@implementation ANMediaViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 5.0;
    opacity = 1.0;

	
    
        
    
   
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.editing = NO;
    self.imagePicker.videoMaximumDuration = 7.0;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    else
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.                       imagePicker.sourceType];
    
    
    
    [self presentViewController:self.imagePicker animated:NO completion:Nil];
    
    
}



#pragma mark - ImpagePickerController

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // A photo was taken/selected!
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // Save the image!
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    }
    else {
        // A video was taken/selected!
        self.videoFilePath = (__bridge NSString *)([[info objectForKey:UIImagePickerControllerMediaURL] path]);
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // Save the video!
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
    }
    
    
    
  
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
     //Add doodling here
    
   if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
       self.mainImage.image = self.image;
       self.tmpImage.alpha = 0.1f;
   }
    else
        [self Save:self];
    
    
    //Call delegate function indicating it has finished
    
    
    
    
}



// To handle ActionSheet


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            self.type = @"Friends";
            
        }
            
            
            break;
            
        case 1:
        {
            self.type = @"Groups";
            
        }
            
            
            
            break;
            
       
            
            
            
    }
    [self.delegate userHasDecided:self.image orVideo:self.videoFilePath withType:self.type];
    [self reset];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}


-(void)reset
{
    self.videoFilePath =nil;
    self.image = nil;
   
}

- (IBAction)Save:(id)sender {
    
    self.image = self.mainImage.image;
    
    
    //Time to send it away
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Where does the photo go" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Friends",@"Chat Rooms",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    [actionSheet showInView:self.view];
    
    [self.navigationItem setHidesBackButton:NO];
  
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
}


#pragma mark Doodling Code

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.tmpImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tmpImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tmpImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tmpImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tmpImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tmpImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tmpImage.image = nil;
    UIGraphicsEndImageContext();
}




//Code to change color

- (IBAction)pencilPressed:(id)sender {
           UIButton * PressedButton = (UIButton*)sender;
        
        switch(PressedButton.tag)
        {
            case 0:
                red = 0.0/255.0;
                green = 0.0/255.0;
                blue = 0.0/255.0;
                break;
            case 1:
                red = 105.0/255.0;
                green = 105.0/255.0;
                blue = 105.0/255.0;
                break;
            case 2:
                red = 255.0/255.0;
                green = 0.0/255.0;
                blue = 0.0/255.0;
                break;
            case 3:
                red = 0.0/255.0;
                green = 0.0/255.0;
                blue = 255.0/255.0;
                break;
            case 4:
                red = 102.0/255.0;
                green = 204.0/255.0;
                blue = 0.0/255.0;
                break;
            case 5:
                red = 102.0/255.0;
                green = 255.0/255.0;
                blue = 0.0/255.0;
                break;
            case 6:
                red = 51.0/255.0;
                green = 204.0/255.0;
                blue = 255.0/255.0;
                break;
            case 7:
                red = 160.0/255.0;
                green = 82.0/255.0;
                blue = 45.0/255.0;
                break;
            case 8:
                red = 255.0/255.0;
                green = 102.0/255.0;
                blue = 0.0/255.0;
                break;
            case 9:
                red = 255.0/255.0;
                green = 255.0/255.0;
                blue = 0.0/255.0;
                break;
        }
    
}

- (IBAction)eraserPressed:(id)sender {
    
    red = 255.0/255.0;
    green = 255.0/255.0;
    blue = 255.0/255.0;
    opacity = 1.0;
}



- (IBAction)reset:(id)sender {
    
     self.mainImage.image = nil;
}
@end
