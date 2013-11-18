//
//  ANImageViewController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/14/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANImageViewController.h"

@interface ANImageViewController ()

@end

@implementation ANImageViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
        self.navigationItem.hidesBackButton = YES;
    
    
	
     
     
    
    
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Do any additional setup after loading the view.
    PFFile *imgFile = [self.message objectForKey:@"file"];
    
    NSURL *imageURL = [[NSURL alloc]initWithString:imgFile.url];
    
    NSData *imgData = [[NSData alloc] initWithContentsOfURL:imageURL];
    
    UIImage *image = [[UIImage alloc]initWithData:imgData];
    
    self.imageView.image = image;
    
    self.navigationItem.title = [NSString stringWithFormat:@"Sent from %@",[self.message objectForKey:@"senderUserName"]];
    
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
