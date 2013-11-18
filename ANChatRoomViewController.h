//
//  ANChatRoomViewController.h
//  Ribbit
//
//  Created by Anirudh narla on 11/14/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ANChatRoomInboxController.h"

@interface ANChatRoomViewController : UITableViewController



@property (nonatomic,strong) NSArray *privateCRooms;

@property (nonatomic,strong) NSArray *globalRooms;


@property(nonatomic,strong) NSString *chatRoomType;
@property(nonatomic,strong) NSString *chatRoomName;

@end
