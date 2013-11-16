//
//  ANmessagePickerController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/15/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANmessagePickerController.h"

@interface ANmessagePickerController ()

@end

@implementation ANmessagePickerController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    
   
  //  if ([self.delegate respondsToSelector:@selector(seteditedType:)]) {
        
    
   
    
    
}





- (IBAction)friends:(id)sender {
    
   // ANCameraViewController *setType = (ANCameraViewController*) self.parentViewController;
   
   
    
    [self.delegate userHasDecided:@"Friends" ];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
    
}

- (IBAction)groups:(id)sender {
    
   // ANCameraViewController *setType = (ANCameraViewController*)self.parentViewController;
    
  
     [self.delegate userHasDecided:@"Groups" ];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

@end
