//
//  ANLoginController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/12/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANLoginController.h"
#import <Parse/Parse.h>

@interface ANLoginController ()

@end

@implementation ANLoginController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
}





- (IBAction)logIn:(id)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
  
    
    
    if(username.length == 0 || password.length == 0)
    {
        UIAlertView *allertView = [[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"Please enter a valid username/password" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
        
        [allertView show];
        
    }
    
    
    
    
    else{
        
        [PFUser logInWithUsernameInBackground:username password:password
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                            } else {
                                                
                                                NSString *errorString = [error userInfo][@"error"];
                                                UIAlertView *allertView = [[UIAlertView alloc] initWithTitle:@"Error!!" message:errorString delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
                                                [allertView show];
                                               
                                                
                                            }
                                        }];
        
    }
    
    
}
@end
