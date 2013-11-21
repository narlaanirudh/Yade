//
//  ANLoginController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/12/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANLoginController.h"
#import <Parse/Parse.h>
#import "RNBlurModalView.h"

@interface ANLoginController ()

@end

@implementation ANLoginController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    
    NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSLog(@"here you go %@",bundleID);
}





- (IBAction)cancel:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)logIn:(id)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
  
    
    
    if(username.length == 0 || password.length == 0)
    {
        
        RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self title:@"Oops!!" message:@"Please enter a valid username/password"];
        [modal show];
       
        
     
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

- (IBAction)facebookLogin:(id)sender {
    
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
       
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user) {
            
            
            
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // Store other values from fb
                    
                    NSDictionary *userData = (NSDictionary *)result;
                    
                    PFUser *currentUser = [PFUser currentUser];
                    
                    currentUser[@"username"] = userData[@"id"];
                    currentUser[@"Fname"] = userData[@"name"];
                    currentUser[@"Gender"] = userData[@"gender"];
                    currentUser[@"email"] = userData[@"email"];
                    currentUser[@"imgURL"]= [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", userData[@"id"]];
                 
                    
                    [currentUser saveInBackground];
                }
            }];
            NSLog(@"User with facebook logged in!");
            [self.navigationController popToRootViewControllerAnimated:YES];
           
        }
    }];
    
    
    FBRequest *request = [FBRequest requestForMe];
    
    [request setSession:[PFFacebookUtils session]];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
           // NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
           // NSString *location = userData[@"location"][@"name"];
          //  NSString *gender = userData[@"gender"];
          //  NSString *birthday = userData[@"birthday"];
          //  NSString *relationship = userData[@"relationship_status"];
            
            NSLog(@"Have you got my name %@",name);
            PFUser *currentUser = [PFUser currentUser];
            currentUser.username = name;
            [currentUser save];
            
            //NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            // Now add the data to the UI elements
            // ...
        }
        
        else
            NSLog(@"Uh An error occurred: %@", error);
    }];
     
    
}


@end
