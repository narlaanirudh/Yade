//
//  ANChatImageView.m
//  Ribbit
//
//  Created by Anirudh narla on 11/16/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANChatImageView.h"
#import "MBProgressHUD.h"

@interface ANChatImageView ()

@end

@implementation ANChatImageView


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [super viewWillAppear:animated];
    
    // Do any additional setup after loading the view.
  
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
         PFFile *imgFile = [self.message objectForKey:@"file"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSURL *imageURL = [[NSURL alloc]initWithString:imgFile.url];
            
            NSData *imgData = [[NSData alloc] initWithContentsOfURL:imageURL];
            
            UIImage *image = [[UIImage alloc]initWithData:imgData];
            
            self.imageView.image = image;
            
            self.navigationItem.title = [NSString stringWithFormat:@"Sent from %@",[self.message objectForKey:@"senderUserName"]];
        });
    });
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([self respondsToSelector:@selector(timeout)])
        [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(timeout) userInfo:Nil repeats:NO];
}

-(void) timeout
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
