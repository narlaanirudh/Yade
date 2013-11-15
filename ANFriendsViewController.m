//
//  ANFriendsViewController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/12/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANFriendsViewController.h"
#import "ANInvFriendsController.h"


@interface ANFriendsViewController ()

@end

@implementation ANFriendsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void) viewWillAppear:(BOOL)animated
{

    // Load up the Favorites
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error)
            NSLog(@"error %@  %@",error , [error userInfo]);
        
        else
        {
            self.friends = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        }
        
            
    }];
    
    //Load up all users
    
    query = [PFUser query];
    
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@   %@" , error , [error userInfo]);
        }
        
        else
            
            
        {
            self.allUsers = objects;
            
            /*for( PFUser *user in objects)
            {
                [self.allUsers setObject:user forKey:user.objectId];
                
            }
             */
            
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
            return @"Favorites";
            break;
            
            case 1:
            return @"Contacts";
            
            
        default:
            return nil;
            break;
    }
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    
    if(section ==0)
    return [self.friends count];
    
    else
        //return 2;
        return ( [self.allUsers count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    if(indexPath.section==0)
    {
   
        PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    }
    
   
    if(indexPath.section==1)
    {
        
        PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
        
       // if(![self isFriend:user])
        cell.textLabel.text = user.username;
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"showContatcs"])
    {
        ANInvFriendsController *invfrndcntrllr = (ANInvFriendsController *)segue.destinationViewController;
        
        invfrndcntrllr.allUsers = self.allUsers;
        invfrndcntrllr.friends = self.friends;
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Helper method

-(BOOL) isFriend:(PFUser *)user {
    
    for( PFUser *friends in self.friends)
    {
        if([friends.objectId isEqualToString:user.objectId])
            return YES;
    }
    
    return NO;
    
}

@end