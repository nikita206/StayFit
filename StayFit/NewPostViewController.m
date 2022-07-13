//
//  NewPostViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/12/22.
//

#import "NewPostViewController.h"
#import "Post.h"
#import "recipesPost.h"
#import "CommunityViewController.h"

@interface NewPostViewController ()

@end

@implementation NewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)shareButton:(id)sender {
    if(self.segoutValue == 0){
    if(self.image.image && ![self.caption.text isEqualToString:@""]){
        [Post postUserImage:self.image.image withCaption:self.caption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", "could not post");
            }
            else{
                NSLog(@"Awesome");
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController *tabController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                self.view.window.rootViewController = tabController;
            }
        }];
    }
    }
    else if(self.segoutValue == 1){
    if(self.image.image && ![self.caption.text isEqualToString:@""]){
        [recipesPost postUserImage:self.image.image withCaption:self.caption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", "could not post");
            }
            else{
                NSLog(@"Awesome");
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController *tabController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                self.view.window.rootViewController = tabController;
            }
        }];
    }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    // Do something with the images (based on your use case)
    UIImage *resizedImage = [self resizeImage:originalImage withSize:CGSizeMake(500,500)];
    [self.image setImage:resizedImage];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)cameraRoll:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
@end
