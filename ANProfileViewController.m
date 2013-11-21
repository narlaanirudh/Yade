//
//  ANProfileViewController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/19/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANProfileViewController.h"
#import "RNBlurModalView.h"
#import "MBProgressHUD.h"


@interface ANProfileViewController ()

@end

@implementation ANProfileViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.currentUser = [PFUser currentUser];
         NSURL * imgUrl = [NSURL URLWithString:[self.currentUser objectForKey:@"imgURL"]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        
        NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];

        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.profileImage.image = [UIImage imageWithData:imgData];
            
            self.Fname.text = [self.currentUser objectForKey:@"Fname"];
            self.Gender.text = [self.currentUser objectForKey:@"Gender"];
            self.mobile.text = [self.currentUser objectForKey:@"Mobile"];

           
        });
    });
    
   
    
    
    
    
    
    
    // Set up Camera
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.editing = NO;
   
    
    
}


- (IBAction)Save:(id)sender {
    
    PFUser *currentUser = [PFUser currentUser];
    
    
    currentUser[@"Fname"] = self.Fname.text;
    currentUser[@"Gender"] = self.Gender.text;
    currentUser[@"Mobile"] = self.mobile.text;
    
   // currentUser[@"imgURL"]= [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", userData[@"id"]];
    
    
    [currentUser saveInBackground];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
}




-(IBAction)editPhoto:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Edit Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete Photo",@"Take Photo",@"Choose Existing", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    [actionSheet showInView:self.view];
    
}

// To handle ActionSheet


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            self.currentUser[@"imgURL"] = nil;
            
            break;
            
        case 1:
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePicker animated:NO completion:Nil];
            break;
            
        case 2:
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePicker animated:NO completion:Nil];
            
            
            break;
            
        
            
            }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
   // NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
  
    
       UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *newImage = [self resizeImage:image towidth:640.0f toHeight:1136.0f];
    NSData *mediaData= UIImagePNGRepresentation(newImage);
    
    PFFile *dataFile = [PFFile fileWithName:@"profile.png" data:mediaData];
    
    [dataFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if(error)
            
        {
            NSString *errorString = [error userInfo][@"error"];
          
            
            RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self title:@"Oops!!" message:errorString];
            [modal show];
            
            
            
            
        }
        
        else
        {
            self.currentUser[@"imgURL"]= dataFile.url;
            //[self.currentUser saveInBackground];
        }
            
        
        

    
    
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    
    
    }];
}


-(UIImage*) resizeImage:(UIImage*) image towidth:(float) width toHeight:(float) height
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = width/height;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = width/ actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = height;
        }
        else{
            imgRatio = width / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = width;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *resizedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImg;
    
    
}
     






@end
