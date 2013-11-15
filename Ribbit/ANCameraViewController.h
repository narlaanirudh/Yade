//
//  ANCameraViewController.h
//  Ribbit
//
//  Created by Anirudh narla on 11/13/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ANCameraViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,strong) UIImagePickerController *imagePicker;

@property (nonatomic,strong) UIImage *image;

@property(nonatomic,strong) NSString *videoFilePath;


@property (nonatomic,strong) NSArray *friends;

@property (nonatomic , strong) NSMutableArray *recepients;

@property (nonatomic,strong) PFRelation *friendsRelation;


-(UIImage*) resizeImage:(UIImage*) image towidth:(float) width toHeight:(float) height;

-(void)reset;

-(void)uploadMessage;

- (IBAction)send:(id)sender;

- (IBAction)cancel:(id)sender;



@end
