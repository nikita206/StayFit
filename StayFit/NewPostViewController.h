//
//  NewPostViewController.h
//  StayFit
//
//  Created by Nikita Agarwal on 7/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewPostViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
- (IBAction)shareButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *caption;
- (IBAction)takePicture:(id)sender;
- (IBAction)cameraRoll:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic) int segoutValue;

@end

NS_ASSUME_NONNULL_END
