//
//  ANFriendsViewController.h
//  Ribbit
//
//  Created by Anirudh narla on 11/12/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ANFriendsViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *friends;
//@property (nonatomic , strong) NSMutableDictionary *allUsers;
@property (nonatomic , strong) NSArray *allUsers;

@property (nonatomic,strong) PFRelation *friendsRelation;

-(BOOL) isFriend:(PFUser *)user ;

@end
