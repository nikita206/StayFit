//
//  SignupViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/8/22.
//

#import "SignupViewController.h"
#import "Parse/Parse.h"

@interface SignupViewController ()

@end

@implementation SignupViewController
@synthesize state,statePicker, stateArray, fitnessLevel, levelArray, levelPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    stateArray = @[@"Alabama", @"Alaska", @"American Samoa", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"District of Columbia", @"Florida", @"Georgia", @"Guam", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Minor Outlying Islands", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Northern Mariana Islands", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Puerto Rico", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"U.S. Virgin Islands", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
    statePicker = [[UIPickerView alloc] init];
    [statePicker setDataSource:self];
    [statePicker setDelegate:self];
    self.statePicker.tag = 0;
    [state setInputView:statePicker];
    levelArray = @[@"Beginner", @"Intermediate", @"Advanced"];
    levelPicker = [[UIPickerView alloc] init];
    [levelPicker setDataSource:self];
    [levelPicker setDelegate:self];
    self.levelPicker.tag = 1;
    [fitnessLevel setInputView:levelPicker];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 0) {
        return [stateArray count];
    }
    
    else if(pickerView.tag == 1) {
        return [levelArray count];
    }
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
    return [stateArray objectAtIndex:row];
    }
    else if(pickerView.tag == 1) {
        return [levelArray objectAtIndex:row];
    }
    return 0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
    [state setText:[stateArray objectAtIndex:row]];
    }
    else if(pickerView.tag == 1) {
        [fitnessLevel setText:[levelArray objectAtIndex:row]];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:YES];
}

- (void)registerUser {
    //initializes a user object
    PFUser *newUser = [PFUser user];
    
    //sets user properties
    newUser[@"firstName"] = self.firstName.text;
    newUser[@"lastName"] = self.lastName.text;
    newUser.email = self.email.text;
    newUser.username = self.username.text;
    newUser.password = self.password.text;
    newUser[@"weight"] = self.weight.text;
    newUser[@"height"] = self.height.text;
    newUser[@"city"] = self.city.text;
    newUser[@"state"] = self.state.text;
    newUser[@"fitnessLevel"] = self.fitnessLevel.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"login"];
            self.view.window.rootViewController = login;
        }
    }];
}

- (IBAction)didTapSignup:(id)sender {
    if([self.firstName.text isEqual:@""] || [self.lastName.text isEqual:@""] || [self.email.text isEqual:@""] || [self.username.text isEqual:@""] || [self.password.text isEqual:@""] || [self.weight.text isEqual:@""] || [self.height.text isEqual:@""] || [self.city.text isEqual:@""] || [self.state.text isEqual:@""] || [self.fitnessLevel.text isEqual:@""]){
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                               message:@"Please check all that all the fields are filled"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
        
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle cancel response here. Doing nothing will dismiss the view.
                                                          }];
        //cancel action to the alertController
    [alert addAction:cancelAction];

        //OK action to the alertController
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
    [self registerUser];
    }
}

- (IBAction)didTapBack:(id)sender {
    NSLog(@"going back!");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    self.view.window.rootViewController = login;
}
@end
