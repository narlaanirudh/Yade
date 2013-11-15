//
//  ANLoginController.h
//  Ribbit
//
//  Created by Anirudh narla on 11/12/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANLoginController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


- (IBAction)logIn:(id)sender;

@end
