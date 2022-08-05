//
//  LoginViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/8/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "SignupViewController.h"
#import "AppDelegate.h"
@interface LoginViewController (){
    AppDelegate *appDelegate;
      NSManagedObjectContext *context;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //creates tap gesture for the Sign Up button
    UITapGestureRecognizer *signUpTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSignup)];
    [self.signUp addGestureRecognizer:signUpTap];
    [self.signUp setUserInteractionEnabled:YES];
}

- (void)loginUser {
    //sets the username and password entered by the user to the text fields
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    //fetches data
    NSFetchRequest *requestExamLocation = [NSFetchRequest fetchRequestWithEntityName:@"Users"];
    NSArray *results = [context executeFetchRequest:requestExamLocation error:nil];
    //checks if the username password combination is stored in core data
    for(NSString *key in [results valueForKey:@"username_password"]){
        if([key isEqual:[NSString stringWithFormat:@"%@%@%@", self.username.text, @"#", self.password.text]]){
            NSLog(@"Core data for login works");
            //segue to the tab bar controller that opens when user logs in
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tabController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
            self.view.window.rootViewController = tabController;
        }
    }
    //initiates login user
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            //throws an error along with its description if user cannot be logged in
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            //segue to the tab bar controller that opens when user logs in
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *tabController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
            self.view.window.rootViewController = tabController;
        }
    }];
}

- (IBAction)didTapLogin:(id)sender {
    //checks that username and password fields are not blank when user tries to login
    if([self.username.text isEqual:@""] || [self.password.text isEqual:@""]){
        //throws an alert if either of the fields are blank
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please check all that all the fields are filled" preferredStyle:(UIAlertControllerStyleAlert)];
        //creates an OK button to dismiss the aler
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{}];
    }
    else{
        //logs the user in if fields are not blank
        [self loginUser];
    }
}

-(void) didTapSignup {
    //takes the user to the signup page when tap gesture is recognized
    NSLog(@"Taking you to the signup page");
    //segue to the signup page
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *signup = [storyboard instantiateViewControllerWithIdentifier:@"signup"];
    self.view.window.rootViewController = signup;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //dismisses the keyboard when user taps on screen
    [[self view] endEditing:YES];
}
@end
