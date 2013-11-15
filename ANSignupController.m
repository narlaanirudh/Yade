//
//  ANSignupController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/12/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//


#import "ANSignupController.h"
#import <Parse/Parse.h>

@interface ANSignupController ()

@end

@implementation ANSignupController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}



- (IBAction)signupButton:(id)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if(username.length == 0)
    {
        UIAlertView *allertView = [[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"The username you entered is incorrect" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
        
        [allertView show];
        
    }
    
    else if(password.length == 0)
    {
        UIAlertView *allertView = [[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"The password you entered is incorrect" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
        
        [allertView show];
        
    }
    
    else if(email.length == 0)
    {
        UIAlertView *allertView = [[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"The email you entered is incorrect" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
        
        [allertView show];
        
    }
    
    else{
    
    // Setting the username on Parse.com
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    
    // other fields can be set just like with PFObject
    //user[@"phone"] = @"415-392-0202";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            
           
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *allertView = [[UIAlertView alloc] initWithTitle:@"Error!!" message:errorString delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
            [allertView show];
            // Show the errorString somewhere and let the user try again.
        }
    }];
    }
    
    
    
    
}
@end
