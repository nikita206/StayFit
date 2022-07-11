//
//  LoginViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/8/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "SignupViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *signUpTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSignup)];
    [self.signUp addGestureRecognizer:signUpTap];
    [self.signUp setUserInteractionEnabled:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loginUser {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
//            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tabController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
            self.view.window.rootViewController = tabController;
        }
    }];
}

- (IBAction)didTapLogin:(id)sender {
    if([self.username.text isEqual:@""] || [self.password.text isEqual:@""]){
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                               message:@"Please check all that all the fields are filled"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
        
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                          }];
        // add the cancel action to the alertController
    [alert addAction:cancelAction];

        // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
        // add the OK action to the alert controller
    [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
        
    }
    else{
    [self loginUser];
    }
}

-(void) didTapSignup {
    NSLog(@"taking you there!");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *signup = [storyboard instantiateViewControllerWithIdentifier:@"signup"];
    self.view.window.rootViewController = signup;
}
@end
