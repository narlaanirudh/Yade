//
//  ANCreateChatGroupViewController.h
//  Ribbit
//
//  Created by Anirudh narla on 11/14/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ANAddFriendsInChatRoomViewController.h"

@interface ANCreateChatGroupViewController : UIViewController


- (IBAction)createGlobalChatRoom:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *chatRoomName;


@end
