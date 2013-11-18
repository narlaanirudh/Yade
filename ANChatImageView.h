//
//  ANChatImageView.h
//  Ribbit
//
//  Created by Anirudh narla on 11/16/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ANChatImageView : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) PFObject *message;

@end
