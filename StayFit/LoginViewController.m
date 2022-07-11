//
//  LoginViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/8/22.
//

#import "LoginViewController.h"

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

- (IBAction)didTapLogin:(id)sender {
}

-(void) didTapSignup {
    NSLog(@"taking you there!");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *signup = [storyboard instantiateViewControllerWithIdentifier:@"signup"];
    self.view.window.rootViewController = signup;
}
@end
