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
    PFUser *user = [PFUser currentUser];
    [super viewDidLoad];
    self.author.text = [NSString stringWithFormat:@"%@%@%@", user[@"firstName"]  , @" ", user[@"lastName"]];
    self.profilePic.file = user[@"profileImage"];
    [self.profilePic loadInBackground];
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2.1;
    self.profilePic.clipsToBounds = YES;
    UITapGestureRecognizer *profileTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPhoto)];
    [self.profilePic addGestureRecognizer:profileTap];
    [self.profilePic setUserInteractionEnabled:YES];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                self.view.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    PFFileObject *profilePicture = [PFFileObject fileObjectWithName:@"image.png" data:UIImagePNGRepresentation(editedImage)];
    
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
    NSLog(@"tippy tippy tap");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

@end
