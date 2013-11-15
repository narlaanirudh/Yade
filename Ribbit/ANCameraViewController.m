//
//  ANCameraViewController.m
//  Ribbit
//
//  Created by Anirudh narla on 11/13/13.
//  Copyright (c) 2013 Anirudh Narla. All rights reserved.
//

#import "ANCameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ANCameraViewController ()

@end

@implementation ANCameraViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.recepients = [[NSMutableArray alloc] init];

   
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if(self.image == nil && [self.videoFilePath length]==0)
    {
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.editing = NO;
    self.imagePicker.videoMaximumDuration = 7.0;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    else
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.                       imagePicker.sourceType];
    
    [self presentViewController:self.imagePicker animated:NO completion:Nil];
    }
    
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


#pragma mark - ImpagePickerController

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    
   [self dismissViewControllerAnimated:NO completion:nil];
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // A photo was taken/selected!
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // Save the image!
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    }
    else {
        // A video was taken/selected!
        self.videoFilePath = (__bridge NSString *)([[info objectForKey:UIImagePickerControllerMediaURL] path]);
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // Save the video!
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Helper Methods

- (IBAction)send:(id)sender {
    
    if(self.image == nil && [self.videoFilePath length]==0)
    //some problem with image sending
    
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Try Again!!" message:@"Media was not taken correctly" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        
        [alertView show];
        
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
    
    else
        
        // everything looks good lets send this babay away
    {
        //self.image = [self resizeImage:self.image towidth:640 toHeight:1136];
        [self uploadMessage];
       
        
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
                
                PFObject *message = [PFObject objectWithClassName:@"messages"];
                message[@"fileName"] = fileName;
                message[@"file"] = dataFile;
                message[@"fileType"]= fileType;
                message[@"recepientIds"] = self.recepients;
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
                             [self reset];
                            
                        }
                    
                    
                    
                }];
                
            }
    }];
    

}

- (IBAction)cancel:(id)sender {
    
    [self reset];
    
    
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

-(void)reset
{
    self.videoFilePath =nil;
    self.image = nil;
    
    [self.recepients removeAllObjects];
    
    [self.tabBarController setSelectedIndex:0];
}
@end
