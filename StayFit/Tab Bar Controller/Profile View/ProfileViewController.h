//
//  ProfileViewController.h
//  StayFit
//
//  Created by Nikita Agarwal on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"


NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
- (IBAction)didTapLogout:(id)sender;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *level;

@end

NS_ASSUME_NONNULL_END
