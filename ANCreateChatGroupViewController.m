//
//  ANCreateChatGroupViewController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/14/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANCreateChatGroupViewController.h"

@interface ANCreateChatGroupViewController ()

@end

@implementation ANCreateChatGroupViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}




- (IBAction)createGlobalChatRoom:(id)sender {
    
    PFObject *message = [PFObject objectWithClassName:self.chatRoomName.text];
    
    
    
    
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error)
            
        {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *allertView = [[UIAlertView alloc] initWithTitle:@"Error!!" message:errorString delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
            [allertView show];
            
        }
        
        
        
    }];
    
    PFObject *message1 = [PFObject objectWithClassName:@"GlobalChatRooms"];
    message1[@"GroupName"] = self.chatRoomName.text;
    message1[@"GroupParent"]=@"Africa";
    
    
    [message1 saveInBackground];
    
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    

   
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"inviteFriends"])
        
    {
        
        ANAddFriendsInChatRoomViewController *prvchtrom = (ANAddFriendsInChatRoomViewController*) segue.destinationViewController;
        
        prvchtrom.ChatRoomName = self.chatRoomName.text;
        
        
        
    }
    
}
@end
