//
//  ANImageViewController.h
//  Ribbit
//
//  Created by Anirudh narla on 11/14/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ANImageViewController : UIViewController

@property (nonatomic,strong) PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property(strong,nonatomic) PFFile *imgFile;

-(void) timeout;

@end
