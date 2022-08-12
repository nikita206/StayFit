//
//  SignupViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/8/22.
//

#import "SignupViewController.h"
#import "Parse/Parse.h"
@import GooglePlaces;
#import "AppDelegate.h"

@interface SignupViewController () {
    AppDelegate *appDelegate;
      NSManagedObjectContext *context;
      NSArray *dictionaries;
}

@end
bool isGrantedNotificationAccess;

@implementation SignupViewController {
      GMSAutocompleteFilter *_filter;
}
@synthesize state,statePicker, stateArray, fitnessLevel, levelArray, levelPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    //setting up notification that pops when user signs up
    isGrantedNotificationAccess = false;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert+UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        isGrantedNotificationAccess = granted;
    }];
    //creates an array for the picker view of fitness level
    levelArray = @[@"Beginner", @"Intermediate", @"Expert"];
    levelPicker = [[UIPickerView alloc] init];
    [levelPicker setDataSource:self];
    [levelPicker setDelegate:self];
    [fitnessLevel setInputView:levelPicker];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    //number of columns that picker view should display
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
        //returns number of rows for fitness level picker view
        return [levelArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //returns each row's contents for fitness level picker view
    return [levelArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //checks which row was selected by the user in picker view
    [fitnessLevel setText:[levelArray objectAtIndex:row]];
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
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude: self.latitude longitude:self.longitude];
    newUser[@"location"] = point;
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
    //checks if notification access is allowed
    if(isGrantedNotificationAccess){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        //sets notification details
        content.title = @"StayFit";
        content.subtitle = @"Registration Successful";
        content.body = @"Thanks for registering with StayFit! Please login to continue.";
        content.sound = [UNNotificationSound defaultSound];
        //notification is sent 2 seconds after the button is pressed
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
        UNNotificationRequest *request =  [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:nil];
    }
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
  GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID | GMSPlaceFieldAddressComponents | GMSPlaceFieldFormattedAddress | GMSPlaceFieldCoordinate);
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
    for ( GMSAddressComponent * component in place.addressComponents) {
        //checking the array to see where locality is located
        if ( [component.type  isEqual: @"locality"] )
        {
            //automatically sets the name of the city
            self.city.text = component.name;
        }
        if ( [component.type  isEqual: @"administrative_area_level_1"] )
        {
            //automatically sets the name of the state
            self.state.text = component.name;
        }
    }
    self.latitude = (float)place.coordinate.latitude;
    self.longitude = (float)place.coordinate.longitude;
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
