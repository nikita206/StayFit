//
//  ProfileViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/11/22.
//

#import "ProfileViewController.h"
#import "Post.h"
#import "ProfileFriendsCell.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *addedFriendArray;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.addedFriendArray = [[NSMutableArray alloc]init];
    //creates a new query for fitness posts in the descending order of post created time
    PFQuery *friendQuery = [PFQuery queryWithClassName:@"friends"];
    PFObject *currentUserObject = [[PFUser currentUser]objectId];
    NSLog(@"current user ID %@",currentUserObject);
    [friendQuery whereKey:@"toUser" equalTo:currentUserObject];
    [friendQuery whereKey:@"status" equalTo:@"accepted"];
    [friendQuery orderByDescending:@"createdAt"];
    
    [friendQuery includeKey:@"toUser"];
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (error)
    {
        NSLog(@"could not find friends");
    }
    else {
        NSLog(@"friendRequestCount = %d", objects.count);
        for (PFObject *object in objects) {
             NSLog(@"%@", object[@"fromUser"]);
            [self.addedFriendArray addObject:object[@"fromUser"]];
        }
        NSLog(@"array is %@", self.addedFriendArray);
        [self.tableView reloadData];
    }
    }];
    
    //sets the current user as the user logged in
    PFUser *user = [PFUser currentUser];
    [super viewDidLoad];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileFriendsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"addedFriends" forIndexPath:indexPath];
    //sets the contents for each cell
    NSString *friendId = self.addedFriendArray[indexPath.row];
    NSLog(@"%@",friendId);
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:friendId];
    [query includeKey:@"firstName"];
    PFObject* list = [query getFirstObject];
    NSLog(@"%@", list[@"firstName"]);
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if(!error){
            if (posts.count) {
                NSLog(@"User Found");
            }
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
    
    cell.name.text = list[@"firstName"];
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

@end
