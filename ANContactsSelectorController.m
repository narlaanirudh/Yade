//
//  ANContactsSelectorController.m
//  Yade
//
//  Created by Anirudh narla on 11/20/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANContactsSelectorController.h"

@interface ANContactsSelectorController ()

@end

@implementation ANContactsSelectorController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedPeople = [[NSMutableArray alloc]init];
   
    
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
  
   CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
                                                               kCFAllocatorDefault,
                                                               CFArrayGetCount(people),
                                                               people
                                                               );
    
    
    CFArraySortValues(
                      peopleMutable,
                      CFRangeMake(0, CFArrayGetCount(peopleMutable)),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void*) ABPersonGetSortOrdering()
                      );
    
    NSMutableArray *tmp = (__bridge NSMutableArray*)peopleMutable;
    
   people = *(&peopleMutable);
    
    self.arrayOfPeople = [ NSArray arrayWithArray:tmp];
    
    self.filteredContacts = [[NSMutableArray alloc]initWithCapacity:[self.arrayOfPeople count]];
    [self.tableView reloadData];
    
   
[self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
    

    
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    [self.filteredContacts removeAllObjects];
    // Filter the array using NSPredicate
    
    //Extremely complicated Predicate
    
    NSPredicate* predicate = [NSPredicate predicateWithBlock: ^(id record, NSDictionary* bindings) {
        
       
        
        NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue((__bridge ABRecordRef)(record),
                                                                             kABPersonFirstNameProperty);
        NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue((__bridge ABRecordRef)(record),kABPersonLastNameProperty);
        
         NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        BOOL result = NO;
        
        if ([name rangeOfString:searchText].location != NSNotFound) {
                result = YES;
                
            }
        
        
        
        return result;
    }];
    

    
    self.filteredContacts = [NSMutableArray arrayWithArray:[self.arrayOfPeople filteredArrayUsingPredicate:predicate]];
}

-(IBAction)finishedSelecting:(id)sender
{
   
    
    
    [self.delegate selectedContacts:self.selectedPeople noOfcontacts:[self.selectedPeople count] contactType:0 ];
    
      [self.navigationController popViewControllerAnimated:NO];
    
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
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
           return [self.filteredContacts count];
       
    } else {
           return [self.arrayOfPeople count];
    }
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    

   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
 //Loading Basic Values
    
    int index = indexPath.row;
    
    ABRecordRef person;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        person = (__bridge ABRecordRef)(self.filteredContacts[index]);
       
    } else {
       person = (__bridge ABRecordRef)(self.arrayOfPeople[index]);
    }
    
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                         kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonLastNameProperty);
    
 
    
    
 //Loading Image of the Person
    
    NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(person);
    
    UIImage  *image;
    if(imgData !=NULL)
    {
        image = [UIImage imageWithData:imgData];
    }
    else
    {
       image =  [UIImage imageNamed:@"0012.png"];
    }
  
   
    NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    cell.textLabel.text = name;
    cell.imageView.image = image;
   

 //Setting Accessory Values
    id personabc;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        personabc = [self.filteredContacts objectAtIndex:indexPath.row];
        
        
    } else {
        
        personabc = [self.arrayOfPeople objectAtIndex:indexPath.row];
        
    }

  
    
    if( [self.selectedPeople containsObject:personabc])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
   
    
    
    return cell;
     
    
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
       
   
    
    id person;
    
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        person = [self.filteredContacts objectAtIndex:indexPath.row];
        
        
    } else {
        
         person = [self.arrayOfPeople objectAtIndex:indexPath.row];
        
    }
   
    
 
    

    
    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedPeople addObject:person];
    }
    
    else if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedPeople removeObject:person];
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


#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}



-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
[self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
}



@end
