//
//  ANCameraViewController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/13/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANCameraViewController.h"


@interface ANCameraViewController ()

@end

@implementation ANCameraViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initialize Strings
    
    self.chatRoomName = [[NSString alloc]init];
    self.chatRoomType = [[NSString alloc]init];
    self.recepients = [[NSMutableArray alloc] init];
    self.type = [[NSString alloc]init];
    
    
    
    //Load up Global Rooms
    PFQuery *query = [PFQuery queryWithClassName:@"GlobalChatRooms"];
    [query whereKey:@"GroupParent" equalTo:@"Africa"];
    //[query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
          
            self.globalRooms =objects;
            [self.tableView reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if(self.image ==nil && [self.videoFilePath length]==0)
    
    [self performSegueWithIdentifier:@"showCamera" sender:self];
    
    // Load up the Friends
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error)
            NSLog(@"error %@  %@",error , [error userInfo]);
        
        else
        {
            self.friends = objects;
            [self.tableView reloadData];
        }
        
        
    }];
    
    //Load up Private Chat Rooms
    
   query = [PFQuery queryWithClassName:@"PrivateChatRooms"];
    [query whereKey:@"memberGroups" equalTo:[[PFUser currentUser] objectId]];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error)
            NSLog(@"error %@  %@",error , [error userInfo]);
        
        else
        {
            self.privateCRooms = objects;
            NSLog(@" Value of pchatrooms%@",objects);
            [self.tableView reloadData];
            
        }
        
        
    }];
    
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    if([self.type isEqualToString:@"Friends"])
    
        return 1;
   
    
    else if([self.type isEqualToString:@"Groups"])
   
        return 2;
    
    return 0;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if([self.type isEqualToString:@"Friends"])
        
        return @"Friends";
    
    
    else if([self.type isEqualToString:@"Groups"])
        
    {

switch (section) {
    case 0:
        return @"Private Chat Rooms";
        break;
        
    case 1:
        return @"Global Chat Rooms ";
        
        
    default:
        return nil;
        break;
}
    }
    
    return nil;
}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
   
    
  if([self.type isEqualToString:@"Friends"])
    {
        return self.friends.count;
    }
    
    else if([self.type isEqualToString:@"Groups"])
    {
        switch (section) {
            case 0:
                return [self.privateCRooms count];
                break;
                
            case 1:
                return [self.globalRooms count];
                
                
            default:
                return 0;
                break;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if([self.type isEqualToString:@"Friends"])
    {
   
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if([self.recepients containsObject:user.objectId ])
    {
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    else if([self.type isEqualToString:@"Groups"])
    {
        
        if(indexPath.section==0)
        {
            
            PFObject *user = [self.privateCRooms objectAtIndex:indexPath.row];
            cell.textLabel.text =[user objectForKey:@"GroupName"];
        }
        
        
        if(indexPath.section==1)
            
            
        {
            
            PFObject *room = [self.globalRooms objectAtIndex:indexPath.row];
            cell.textLabel.text = [room objectForKey:@"GroupName"];
            
            
            
            
        }
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([self.type isEqualToString:@"Friends"])
    {
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
        
        //Deselect the checkmark
        
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [self.recepients removeObject:user.objectId];
        
    }
    
    else
    
    {    //add to recepient list
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
        [self.recepients addObject:user.objectId];
        
        
    }
    }
    
    if([self.type isEqualToString:@"Groups"])
    {
        
       
        
        if(indexPath.section == 0)
        {
            
            self.chatRoomType = @"Private" ;
            PFObject *user = [self.privateCRooms objectAtIndex:indexPath.row];
           self.chatRoomName=user.objectId;
            NSLog(@"First try it is %@",self.chatRoomName);
           // [self send:self];
            
            
            
            
        }
        
        else if(indexPath.section ==1)
        {
            
            self.chatRoomType=@"Global";
            
            PFObject *room = [self.globalRooms objectAtIndex:indexPath.row];
            
            self.chatRoomName=[room objectForKey:@"GroupName"];
            //[self send:self];
            
            
        }
        
        
        
    }
    
   
    
        
        
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
    
    ANMediaViewController*destination = (ANMediaViewController*)[segue destinationViewController];
    
    destination.delegate = self;
     
     
    
    
   
    
}

-(void)userHasDecided:(NSString*) type
{
    self.type = type;
    
  
    
}


#pragma mark Delegate Methods

- (void)userHasDecided:(UIImage*)img orVideo:(NSString*)videoFilePath withType:(NSString*)type
{
    self.image=img;
    self.videoFilePath=videoFilePath;
    self.type=type;
}





#pragma mark Helper Methods

- (IBAction)send:(id)sender {
    
    NSLog(@"Lets see what is %@",self.type);
    
    if(self.image == nil && [self.videoFilePath length]==0)
    //some problem with image sending
    
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Try Again!!" message:@"Media was not taken correctly" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        
        [alertView show];
        
        //TODO show seque
        
        [self performSegueWithIdentifier:@"showCamera" sender:self];
        
        
    }
    
    else
        
        // everything looks good lets send this babay away
    {
        //self.image = [self resizeImage:self.image towidth:640 toHeight:1136];
        [self uploadMessage];
         [self.tabBarController setSelectedIndex:0];
       
        
    }
}


-(void)uploadMessage
{
    NSString* fileName;
    NSString* fileType;
    NSData *mediaData;
    
    if(self.image!= NULL)
        //Image case
    {
        
        UIImage *newImage = [self resizeImage:self.image towidth:640.0f toHeight:1136.0f];
        mediaData= UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    }
    
    else
    //Video case
    {
        mediaData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    
    
    PFFile *dataFile = [PFFile fileWithName:fileName data:mediaData];
    
    [dataFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if(error)
            
        {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *allertView = [[UIAlertView alloc] initWithTitle:@"Error!!" message:errorString delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
            [allertView show];
            
        }
            
            else
            {
                PFObject *message = [PFObject alloc];
                
              
                
                
                
               
                if([self.type isEqualToString:@"Groups"] && [self.chatRoomType isEqualToString:@"Global"])
                {
                    message = [PFObject objectWithClassName:self.chatRoomName];
                    message[@"fileName"] = fileName;
                    message[@"file"] = dataFile;
                    message[@"fileType"]= fileType;
                    message[@"recepientIds"] = self.recepients;
                    message[@"senderId"] = [[PFUser currentUser] objectId];
                    message[@"senderUserName"] = [[PFUser currentUser] username];
                    
                    
                }
                
                else
                {
                    PFQuery *query = [PFQuery queryWithClassName:@"PrivateChatRooms"];
                    
                    PFObject *room = [query getObjectWithId:self.chatRoomName];
                    
                    message = [PFObject objectWithClassName:@"messages"];
                    message[@"fileName"] = fileName;
                    message[@"file"] = dataFile;
                    message[@"fileType"]= fileType;
                    if([self.type isEqualToString:@"Friends"])
                        message[@"recepientIds"] = self.recepients;
                    else
                        
                    message[@"recepientIds"] = [room objectForKey:@"memberGroups"];
                    message[@"senderId"] = [[PFUser currentUser] objectId];
                    message[@"senderUserName"] = [[PFUser currentUser] username];
                    
                }
                 
                
                
                
                
                [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                    if(error)
                       
                    {
                        NSString *errorString = [error userInfo][@"error"];
                        UIAlertView *allertView = [[UIAlertView alloc] initWithTitle:@"Error!!" message:errorString delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
                        [allertView show];
                        
                    }
                        
                        
                        else
                        {
                            //TODO everything is succesful
                            
                            
                            PFQuery *query = [PFQuery queryWithClassName:@"PrivateChatRooms"];
                            
                            PFObject *room = [query getObjectWithId:self.chatRoomName];

                          
                            
                            NSMutableArray * listOfMessages = [room objectForKey:@"listOfMessages"];
                           
                            
                            if(listOfMessages == NULL)
                                listOfMessages = [NSMutableArray arrayWithObject:message.objectId];
                            else
                            
                            [listOfMessages addObject:message.objectId];
                            
                          
                            
                            room[@"listOfMessages"] = listOfMessages;
                            
                            
                            [room saveInBackground];
                            
                             [self reset];
                            
                        }
                    
                    
                    
                }];
                
                
                
            }
    }];
    

}

-(UIImage*) resizeImage:(UIImage*) image towidth:(float) width toHeight:(float) height
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = width/height;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = width/ actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = height;
        }
        else{
            imgRatio = width / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = width;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *resizedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImg;
    
    
}

- (IBAction)cancel:(id)sender {
    
    [self reset];
    [self.tabBarController setSelectedIndex:0];
    
    
    
}



-(void)reset
{
    self.videoFilePath =nil;
    self.image = nil;
    
    [self.recepients removeAllObjects];
    
   
}
@end
