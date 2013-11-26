//
//  ANmessagePickerController.h
//  Ribbit
//
//  Created by Anirudh narla on 11/15/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANCameraViewController.h"

@protocol SettingsDelegate <NSObject>
- (void)userHasDecided:(NSString *)dType;
@end


@interface ANmessagePickerController : UIViewController
@property (copy,nonatomic) NSString *type;
- (IBAction)friends:(id)sender;
- (IBAction)groups:(id)sender;


@property id<SettingsDelegate>delegate;



@end
