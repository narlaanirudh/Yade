//
//  ANChatRoomInboxController.h
//  Ribbit
//
//  Created by Anirudh narla on 11/16/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ANChatImageView.h"

@interface ANChatRoomInboxController : UITableViewController

@property (nonatomic,strong) NSArray* messages;
@property (nonatomic,strong) PFObject *selectedMessage;
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;


@property(nonatomic,strong) NSString *chatRoomType;
@property(nonatomic,strong) NSString *chatRoomName;


@end
