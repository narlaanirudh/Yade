//
//  ANAddFriendsInChatRoomViewController.h
//  Ribbit
//
//  Created by Anirudh narla on 11/14/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ANAddFriendsInChatRoomViewController : UITableViewController

@property (nonatomic,strong) NSArray *friends;

@property (nonatomic , strong) NSMutableArray *recepients;

@property (nonatomic,strong) PFRelation *friendsRelation;
- (IBAction)addFriends:(id)sender;

@property (nonatomic,strong) NSString *ChatRoomName;

@end
