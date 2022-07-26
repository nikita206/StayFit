//
//  ProfileViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/11/22.
//

#import "ProfileViewController.h"
#import "Post.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ProfileViewController

- (void)viewDidLoad {
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
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
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
