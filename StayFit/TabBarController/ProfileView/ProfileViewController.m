//
//  ProfileViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/11/22.
//

#import "ProfileViewController.h"
#import "Post.h"
#import "ProfileFriendsCell.h"
#import <MessageUI/MessageUI.h>

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *addedFriendArray;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.addedFriendArray = [[NSMutableArray alloc]init];
    [self currentUser];
    [self addedFriends];
}

//sets the details of the signed in user
-(void)currentUser{
    //sets the current user as the user logged in
    PFUser *user = [PFUser currentUser];
    //sets user details on the basis of logged in user
    self.author.text = [NSString stringWithFormat:@"%@%@%@", user[@"firstName"]  , @" ", user[@"lastName"]];
    self.username.text = [NSString stringWithFormat:@"%@%@", @"@" , user.username];
    self.level.text = user[@"fitnessLevel"];
    self.profilePic.file = user[@"profileImage"];
    [self.profilePic loadInBackground];
    //sets the radius of the profile pic of the user
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2.1;
    self.profilePic.clipsToBounds = YES;
    //ceates a tap gesture for profile pic
    UITapGestureRecognizer *profileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPhoto)];
    [self.profilePic addGestureRecognizer:profileTap];
    [self.profilePic setUserInteractionEnabled:YES];
}

//runs the query to see the added friends of the signed in user
-(void)addedFriends{
    PFQuery *friendQuery = [PFQuery queryWithClassName:@"friends"];
    PFObject *currentUserObject = [[PFUser currentUser]objectId];
    [friendQuery whereKey:@"toUser" equalTo:currentUserObject];
    //ensures that the friend request is accepted
    [friendQuery whereKey:@"status" equalTo:@"accepted"];
    //displays latest added users first
    [friendQuery orderByDescending:@"createdAt"];
    [friendQuery includeKey:@"toUser"];
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (error)
    {
        NSLog(@"Could not find friends");
    }
    else {
        for (PFObject *object in objects) {
            //adds the friend of the signed in user to the array
            [self.addedFriendArray addObject:object[@"fromUser"]];
        }
        //to ensure that the data is appended correctly into the array
        NSLog(@"array is %@", self.addedFriendArray);
        [self.tableView reloadData];
    }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileFriendsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"addedFriends" forIndexPath:indexPath];
    //gets the object ID of the friend
    NSString *friendId = self.addedFriendArray[indexPath.row];
    [self getFriendDetails:cell string:friendId];
    return cell;
}

-(UITableViewCell *)getFriendDetails:(ProfileFriendsCell *)cell string:(NSString *)friendId{
    //fetches details of the added friend
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:friendId];
    [query includeKey:@"firstName"];
    PFObject* list = [query getFirstObject];
    //sets the contents of the cell
    cell.name.text = [NSString stringWithFormat:@"%@%@%@", list[@"firstName"]  , @" ", list[@"lastName"]];
    cell.profilePic.file = list[@"profileImage"];
    [cell.profilePic loadInBackground];
    //sets the radius for porfile pic
    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/2;
    cell.profilePic.clipsToBounds = YES;
    cell.level.text = list[@"fitnessLevel"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addedFriendArray.count;
}

- (IBAction)didTapLogout:(id)sender {
    //logs out and segues to the login page
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.view.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    }];
}

//allows the user to change their profile picture using camera/camera roll
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    PFFileObject *profilePicture = [PFFileObject fileObjectWithName:@"image.png" data:UIImagePNGRepresentation(editedImage)];
    //sets the profile picture in Parse
    [[PFUser currentUser] setObject:profilePicture forKey:@"profileImage"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"successfully uploaded profile picture");
                self.profilePic.image = editedImage;
            }
            else {
                NSLog(@"failed to upload profile picture");
            }
        }];
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) didTapPhoto {
    //opens Image Picker controller when tap gesture on profile picture is recognized
    NSLog(@"The profile picture was tapped");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

//allows user to send email
- (IBAction)contact:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Sample Subject"];
        [mail setMessageBody:@"Here is some main text in the email!" isHTML:NO];
        [mail setToRecipients:@[@"nikitaag206@gmail.com"]];

        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
