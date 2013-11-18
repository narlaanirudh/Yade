//
//  ANChatRoomInboxController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/16/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANChatRoomInboxController.h"

@interface ANChatRoomInboxController ()

@end

@implementation ANChatRoomInboxController



- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  
    
    if([self.chatRoomType isEqualToString:@"Private"])
    {
        
         PFQuery *query = [PFQuery queryWithClassName:@"PrivateChatRooms"];
        PFObject *room= [query getObjectWithId:self.chatRoomName];
        
        NSArray *messages = [room objectForKey:@"listOfMessages"];
        
     
    
    query = [PFQuery queryWithClassName:@"messages"];
        [query whereKey:@"objectId" containedIn:messages];
    
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
    
    else
    {
        //Global Just get all messages
        PFQuery *query = [PFQuery queryWithClassName:self.chatRoomName];
        [query whereKey:@"recepientIds" notEqualTo:[[PFUser currentUser] objectId ]];
      
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
    
    NSLog(@"messages %@",self.messages);
    
   
        
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
    
    
    
    
    [dateFormatter setDateFormat:@"EEE-dd-MMM"];
    
    NSDate *tmpDate = message.updatedAt;
    
    
    
    
    
    cell.detailTextLabel.text =  [dateFormatter stringFromDate:tmpDate];

    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    
    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
    
   
    
    if([fileType isEqualToString:@"image"])
    {
       
        
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
    
    //if its global it needs to be opposite
    
    if([self.chatRoomType isEqualToString:@"Private"])
    {
    
    if([recepientIds count] == 1)
    {
        [self.selectedMessage deleteInBackground];
    }
    
    else{
        
        [recepientIds removeObject:[[PFUser currentUser]objectId]];
       // NSLog(@" %@",recepientIds);
        [self.selectedMessage setObject:recepientIds forKey:@"recepientIds"];
        [self.selectedMessage saveInBackground];
    }
    }
    
    else
    {
        [recepientIds addObject:[[PFUser currentUser]objectId]];
        //NSLog(@" %@",recepientIds);
        [self.selectedMessage setObject:recepientIds forKey:@"recepientIds"];
        [self.selectedMessage saveInBackground];

        
    }
    
    [self performSegueWithIdentifier:@"showImage" sender:self];
    
}



    
    


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([ segue.identifier isEqualToString:@"showImage"] )
    {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        
        ANChatImageView *imgViewCntrl =(ANChatImageView*) [segue destinationViewController];
        
        imgViewCntrl.message = self.selectedMessage;
        
        
    }
}



@end
