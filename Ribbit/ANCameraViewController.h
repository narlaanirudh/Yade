//
//  ANCameraViewController.h
//  Ribbit
//
//  Created by Anirudh narla on 11/13/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ANMediaViewController.h"

@interface ANCameraViewController : UITableViewController <mediaDelegate>



//@property (nonatomic,strong) ANmessagePickerController *typeChooser;



@property (nonatomic,strong) NSArray *friends;

@property (nonatomic , strong) NSMutableArray *recepients;

@property (nonatomic,strong) PFRelation *friendsRelation;

@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) NSArray *privateCRooms;

@property (nonatomic,strong) NSArray *globalRooms;

@property(nonatomic,strong) NSString *chatRoomType;

@property(nonatomic,strong) NSString *chatRoomName;


@property (nonatomic,strong) UIImage *image;


@property(nonatomic,strong) NSString *videoFilePath;




-(void)reset;

-(void)uploadMessage;

- (IBAction)send:(id)sender;

- (IBAction)cancel:(id)sender;





-(UIImage*) resizeImage:(UIImage*) image towidth:(float) width toHeight:(float) height;

@end
