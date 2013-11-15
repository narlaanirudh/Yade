//
//  ANInboxViewController.h
//  Ribbit
//
//  Created by Anirudh narla on 11/12/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ANInboxViewController : UITableViewController
- (IBAction)Logout:(id)sender;

@property (nonatomic,strong) NSArray* messages;
@property (nonatomic,strong) PFObject *selectedMessage;
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;


@end
