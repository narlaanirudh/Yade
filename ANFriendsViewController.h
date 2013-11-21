//
//  ANFriendsViewController.h
//  Ribbit
//
//  Created by Anirudh narla on 11/12/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ANContactsSelectorController.h"
#import <MessageUI/MessageUI.h>



@interface ANFriendsViewController : UITableViewController<UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,ANContactsSelectorDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *friends;
//@property (nonatomic , strong) NSMutableDictionary *allUsers;
@property (nonatomic , strong) NSArray *allUsers;
@property(nonatomic,strong) NSString *shareType;

@property (nonatomic,strong) PFRelation *friendsRelation;
- (IBAction)InviteFriends:(id)sender;

-(BOOL) isFriend:(PFUser *)user ;
-(void)sendSMS:(NSArray*)recepientIds;
-(void)sendMail:(NSArray*)recepientIds;






@end
