//
//  ANProfileViewController.h
//  Ribbit
//
//  Created by Anirudh narla on 11/19/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ANProfileViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property(nonatomic,strong) PFUser *currentUser;

-(IBAction)editPhoto:(id)sender;

- (IBAction)Save:(id)sender;

-(UIImage*) resizeImage:(UIImage*) image towidth:(float) width toHeight:(float) height;

@property (weak, nonatomic) IBOutlet UITextField *Fname;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *Gender;

@end
