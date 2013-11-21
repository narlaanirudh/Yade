//
//  ANContactsSelectorController.h
//  Yade
//
//  Created by Anirudh narla on 11/20/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>

/*
 
 type
 0=ABID
 1=contact number
 2=email
 
 */


@protocol ANContactsSelectorDelegate <NSObject>
- (void)selectedContacts:(NSArray *)contacts noOfcontacts:(int)nofcontacts contactType:(int)type;
@end





@interface ANContactsSelectorController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *arrayOfPeople;
@property (nonatomic, assign) NSArray *people;
@property (nonatomic, strong) NSMutableArray *selectedPeople;
@property (strong,nonatomic) NSMutableArray *filteredContacts;

@property IBOutlet UISearchBar *contactSearchBar;

@property id<ANContactsSelectorDelegate>delegate;

-(IBAction)finishedSelecting:(id)sender;

@end
