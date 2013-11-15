//
//  ANInboxViewController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/12/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANInboxViewController.h"
#import "ANImageViewController.h"
#import <Parse/Parse.h>

@interface ANInboxViewController ()

@end

@implementation ANInboxViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    
    
   

}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PFQuery *query = [PFQuery queryWithClassName:@"messages"];
    [query whereKey:@"recepientIds" equalTo:[[PFUser currentUser] objectId ]];
    [query orderByDescending:@"createdAt"];
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.messages = objects;
            [self.tableView reloadData];
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
     }];
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [message objectForKey:@"senderUserName"];
    
    //setting the date
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc ] init];
    
   // [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   
    
    [dateFormatter setDateFormat:@"EEE-dd-MMM"];
    
    NSDate *tmpDate = message.updatedAt;
    
  
    
   // NSLog(@" %@", []);
    
    cell.detailTextLabel.text =  [dateFormatter stringFromDate:tmpDate];
    
    NSLog(@"Date %@", [dateFormatter stringFromDate:tmpDate]);
    
    // Configure the cell...
    
    return cell;
}

- (IBAction)Logout:(id)sender {
    
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    
    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
    
  
    
    if([fileType isEqualToString:@"image"])
    {
        [self performSegueWithIdentifier:@"showImage" sender:self];
       // NSLog(@"I am inside imageView");
    }
    
    else
    {
        //Handle video here
        
        PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
        
        NSURL *videoURL = [NSURL URLWithString:videoFile.url];
        
        self.moviePlayer.contentURL = videoURL;
        [self.moviePlayer prepareToPlay];
        
        [self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        
        //Adding as a subview
        
        [self.view addSubview:self.moviePlayer.view];
        
        [self.moviePlayer setFullscreen:YES animated:YES];
        
    }
    
    //Delete the Images from the Inbox
    
    NSMutableArray *recepientIds = [[NSMutableArray alloc]initWithArray: [self.selectedMessage objectForKey:@"recepientIds"]];
    
    
    
    if([recepientIds count] == 1)
    {
        [self.selectedMessage deleteInBackground];
    }
    
    else{
        
        [recepientIds removeObject:[[PFUser currentUser]objectId]];
        NSLog(@" %@",recepientIds);
        [self.selectedMessage setObject:recepientIds forKey:@"recepientIds"];
        [self.selectedMessage saveInBackground];
    }
    
   // NSLog(recepientIds);
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([ segue.identifier isEqualToString:@"showLogin"] )
    {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    
    
    else if ([ segue.identifier isEqualToString:@"showImage"] )
    {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        
        ANImageViewController *imgViewCntrl =(ANImageViewController*) [segue destinationViewController];
        
        imgViewCntrl.message = self.selectedMessage;
        
        
    }
     
}


@end
