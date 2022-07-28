//
//  SignupViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/8/22.
//

#import "SignupViewController.h"
#import "Parse/Parse.h"
@import GooglePlaces;

@interface SignupViewController ()

@end

@implementation SignupViewController {
      GMSAutocompleteFilter *_filter;
}
@synthesize state,statePicker, stateArray, fitnessLevel, levelArray, levelPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    //creates an array for the picker view of States
    stateArray = @[@"Alabama", @"Alaska", @"American Samoa", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"District of Columbia", @"Florida", @"Georgia", @"Guam", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Minor Outlying Islands", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Northern Mariana Islands", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Puerto Rico", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"U.S. Virgin Islands", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
    statePicker = [[UIPickerView alloc] init];
    [statePicker setDataSource:self];
    [statePicker setDelegate:self];
    self.statePicker.tag = 0;
    [state setInputView:statePicker];
    
    //creates an array for the picker view of fitness level
    levelArray = @[@"Beginner", @"Intermediate", @"Advanced"];
    levelPicker = [[UIPickerView alloc] init];
    [levelPicker setDataSource:self];
    [levelPicker setDelegate:self];
    self.levelPicker.tag = 1;
    [fitnessLevel setInputView:levelPicker];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    //number of columns that picker view should display
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //checks which picker view needs to be showed(states/fitness level) in order to identify number of rows to be displayed
    switch (pickerView.tag){
        case 0:
            //returns number of rows for states picker view
            return [stateArray count];
        case 1:
            //returns number of rows for fitness level picker view
            return [levelArray count];
    }
    //default return value
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //displays each row's content in picker view
    switch(pickerView.tag){
        case 0:
            //returns each row's contents for states picker view
            return [stateArray objectAtIndex:row];
        case 1:
            //returns each row's contents for fitness level picker view
            return [levelArray objectAtIndex:row];
        default:
            //default value
            return 0;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //checks which row was selected by the user in picker view
    switch(pickerView.tag){
        case 0:
            [state setText:[stateArray objectAtIndex:row]];
            break;
        case 1:
            [fitnessLevel setText:[levelArray objectAtIndex:row]];
            break;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //dismisses picker view once user is done selecting
    [[self view] endEditing:YES];
}

- (void)registerUser {
    //initializes a user object
    PFUser *newUser = [PFUser user];
    //sets user properties in Parse
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
    newUser[@"address"] = self.addressField.text;
    
    //calls sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            //throws an error along with the description if user cannot be signed up
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            //takes the user back to login page once registered successfully
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"login"];
            self.view.window.rootViewController = login;
        }
    }];
}

- (IBAction)didTapSignup:(id)sender {
    //checks if any field in signup is empty
    if([self.firstName.text isEqual:@""] || [self.lastName.text isEqual:@""] || [self.email.text isEqual:@""] || [self.username.text isEqual:@""] || [self.password.text isEqual:@""] || [self.weight.text isEqual:@""] || [self.height.text isEqual:@""] || [self.city.text isEqual:@""] || [self.state.text isEqual:@""] || [self.fitnessLevel.text isEqual:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please check all that all the fields are filled" preferredStyle:(UIAlertControllerStyleAlert)];
        //adds OK button to the alert
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:okAction];
        //dismisses the alert
        [self presentViewController:alert animated:YES completion:^{}];
    }
    else{
        //registers the user if none of the fields are blank
        [self registerUser];
    }
}

- (IBAction)didTapBack:(id)sender {
    //segue to go back to the login page if back is pressed
    NSLog(@"Going back to login page");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    self.view.window.rootViewController = login;
}

//if the button to add address is clicked then a new view is opened
- (IBAction)address:(id)sender {
    [self autocompleteClicked];
}

- (void)autocompleteClicked {
  GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
  acController.delegate = self;
  // Specifies the place data types to return.
  GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID | GMSPlaceFieldAddressComponents);
  acController.placeFields = fields;
   

  // Specifies filter for address
  _filter = [[GMSAutocompleteFilter alloc] init];
  _filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
  acController.autocompleteFilter = _filter;

  // Display the autocomplete view controller.
  [self presentViewController:acController animated:YES completion:nil];
}

  // Handles the user's selection and dismisses the view
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
  [self dismissViewControllerAnimated:YES completion:nil];
    self.addressField.text = place.name;
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Error: %@", [error description]);
}

  //dismisses the view if user cancels
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

  // Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
@end
