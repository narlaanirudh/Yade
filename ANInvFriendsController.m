//
//  ANInvFriendsController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/12/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANInvFriendsController.h"


@interface ANInvFriendsController ()

@end

@implementation ANInvFriendsController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.currentUser = [PFUser currentUser];
    
    
    
    

   
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
   // NSLog(@"count %lu", (unsigned long)self.allUsers.count);
    return [self.allUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser * user = [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    
    if([self isFriend:user ])
  
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    else
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    
    
   
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    
    PFRelation *friendsRelation = [self.currentUser relationforKey:@"friendsRelation"];
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    
    
    
    //Remove from favorites
    
    if([self isFriend:user ])
    {
        
        
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        
        for( PFUser *friends in self.friends)
        {
            if([friends.objectId isEqualToString:user.objectId])
                [self.friends removeObject:friends];
            break;
        }
        
        
        [friendsRelation removeObject:user];
        
        
        
    }
    
        else
        {
            
            //add to favorites
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [friendsRelation addObject:user];
            [self.friends addObject:user];
            
            
            
        }
    
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error)
            NSLog(@"Error %@   %@" , error , [error userInfo]);
    }];
    
    
    
}


-(BOOL) isFriend:(PFUser *)user {
    
    for( PFUser *friends in self.friends)
    {
        if([friends.objectId isEqualToString:user.objectId])
            return YES;
    }
    
    return NO;
    
}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
   
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:"]];
}




@end
