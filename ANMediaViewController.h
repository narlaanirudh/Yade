//
//  ANMediaViewController.h
//  Yade
//
//  Created by Anirudh narla on 11/21/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol mediaDelegate <NSObject>
- (void)userHasDecided:(UIImage*)img orVideo:(NSString*)videoFilePath withType:(NSString*)type;
@end



@interface ANMediaViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

{
    
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;


@property (weak, nonatomic) IBOutlet UIImageView *tmpImage;

@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *type;

@property(nonatomic,strong) NSString *videoFilePath;

- (IBAction)pencilPressed:(id)sender;
- (IBAction)eraserPressed:(id)sender;

- (IBAction)Save:(id)sender;
- (IBAction)reset:(id)sender;

@property id<mediaDelegate>delegate;

-(void) reset;







//Doodling



@end
