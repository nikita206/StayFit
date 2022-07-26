//
//  LoginViewController.h
//  StayFit
//
//  Created by Nikita Agarwal on 7/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)didTapLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *signUp;

@end

NS_ASSUME_NONNULL_END
