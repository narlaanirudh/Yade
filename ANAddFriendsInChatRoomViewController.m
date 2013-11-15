//
//  ANAddFriendsInChatRoomViewController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/14/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANAddFriendsInChatRoomViewController.h"

@interface ANAddFriendsInChatRoomViewController ()

@end

@implementation ANAddFriendsInChatRoomViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.recepients = [[NSMutableArray alloc] init];

   
    
    
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
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
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if([self.recepients containsObject:user.objectId ])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)addFriends:(id)sender {
    
    
    if( [self.recepients count]==0)
        // no friends to add
        
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Friends not selected!!" message:@"Please select some friends" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        
        [alertView show];
        
       
    }
    
    else
        
        // everything looks good lets send this babay away
    {
        
        PFObject *message = [PFObject objectWithClassName:@"PrivateChatRooms"];
       
        message[@"GroupName"] = self.ChatRoomName;
        message[@"memberGroups"] = self.recepients;
        message[@"senderId"] = [[PFUser currentUser] objectId];
        message[@"senderUserName"] = [[PFUser currentUser] username];
        
        
        
        [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error)
                
            {
                NSString *errorString = [error userInfo][@"error"];
                UIAlertView *allertView = [[UIAlertView alloc] initWithTitle:@"Error!!" message:errorString delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil ];
                [allertView show];
                
            }
            
            
            else
            {
                //TODO everything is succesful
                 [self.recepients removeAllObjects];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                
            }
            
            
            
        }];
       
        
        
    }
    
    
    
    
    
}



@end
