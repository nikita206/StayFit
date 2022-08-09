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
    //takes the user back to the segment that was active after share button is clicked (fitness/recipes)
    switch(self.segoutValue){
        //if fitness segment was active
        case 0:
            //checks if the caption or image is missing
            if(self.image.image && ![self.caption.text isEqualToString:@""]){
                [Post postUserImage:self.image.image withCaption:self.caption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error) {
                        //throws an error if either is null
                        NSLog(@"%s", "could not post");
                    }
                    else{
                        //if neither of text fields is null then post is posted
                        NSLog(@"Your post was posted!");
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
        //if recipes segment was active
        case 1:
            //checks if the caption or image is missing
            if(self.image.image && ![self.caption.text isEqualToString:@""]){
                [recipesPost postUserImage:self.image.image withCaption:self.caption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error) {
                        //throws an error if either is null
                        NSLog(@"%s", "could not post");
                    }
                    else{
                        //if neither of text fields is null then post is posted
                        NSLog(@"Your post was posted!");
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
        }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *resizedImage = [self resizeImage:originalImage withSize:CGSizeMake(500,500)];
    [self.image setImage:resizedImage];
    // Dismisses UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    //resizes the image
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
    //enables user to pick a photo from their camera roll
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)takePicture:(id)sender {
    //enables user to open camera and take a picture
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        //if camera is unavailable then camera roll is opened
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
@end