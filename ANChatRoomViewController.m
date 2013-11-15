//
//  ANChatRoomViewController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/14/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANChatRoomViewController.h"

@interface ANChatRoomViewController ()

@end

@implementation ANChatRoomViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
    //Load up the Global Chat Rooms
    
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
    
    //Load up the Private Chat Rooms
    
   
    PFQuery *query = [PFQuery queryWithClassName:@"PrivateChatRooms"];
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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
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
    
    return cell;
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

@end
