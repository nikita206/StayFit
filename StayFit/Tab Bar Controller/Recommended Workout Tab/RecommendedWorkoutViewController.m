//
//  RecommendedWorkoutViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/19/22.
//

#import "RecommendedWorkoutViewController.h"
#import "Parse/Parse.h"
#import "DetailsViewController.h"
#import "WorkoutCell.h"
#import "QuartzCore/CALayer.h"
#import <UIKit/UIKit.h>

@interface RecommendedWorkoutViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *workoutArray;
@property (nonatomic, strong) NSMutableArray *filteredWorkoutArray;
@end

@implementation RecommendedWorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    //clears the background outside search bar
    [self.searchBar setBackgroundColor:[UIColor clearColor]];
    [self.searchBar setBackgroundImage:[UIImage new]];
    [self.searchBar setTranslucent:YES];
    //sets white background inside search bar
    self.searchBar.searchTextField.backgroundColor = [UIColor whiteColor];
    self.workoutArray = [[NSMutableArray alloc] init];
    [self fetchWorkouts];
}

-(void) fetchWorkouts {
    //sets the current user using parse
    PFUser *currentUser = [PFUser currentUser];

    //API call if the logged in user's fitness level is beginner
    if([currentUser[@"fitnessLevel"]  isEqual: @"Beginner"]){
        [self fitnessWorkouts];
    }
    
    //API call if the logged in user's fitness level is intermediate
    else if([currentUser[@"fitnessLevel"]  isEqual: @"Intermediate"]){
        [self recipesPosts];
    }
    
    //API call if the logged in user's fitness level is advanced
    else if([currentUser[@"fitnessLevel"]  isEqual: @"Advanced"]){
        [self gymBuddy];
    }
}

-(void)fitnessWorkouts{
    // creates NSURL object
    NSURL *url = [NSURL URLWithString:@"https://api.api-ninjas.com/v1/exercises?difficulty=beginner"];
    // creates NSURLMutableRequest with the NSURL
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    // configures the NSURLMutable Request with method and headers
    [request setHTTPMethod:@"GET"];
    [request setValue:@"Aq8IKvomBOkXPQELcAKs7Q==kffUR94hO4SaCim1" forHTTPHeaderField:@"X-Api-Key "];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // creates session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    //creates  session task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               //throws an error with description if API call cannot be made
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               self.workoutArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.filteredWorkoutArray = self.workoutArray;
               //prints out the contents of the API for verification
              NSLog(@"%@", self.workoutArray);
               //loads data into the table View
                [self.tableView reloadData];
               }
    }];
    [task resume];
}

-(void) recipesPosts{
    // creates NSURL object
    NSURL *url = [NSURL URLWithString:@"https://api.api-ninjas.com/v1/exercises?difficulty=intermediate"];
    // creates NSURLMutableRequest with the NSURL
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    // configures the NSURLMutable Request with method and headers
    [request setHTTPMethod:@"GET"];
    [request setValue:@"Aq8IKvomBOkXPQELcAKs7Q==kffUR94hO4SaCim1" forHTTPHeaderField:@"X-Api-Key "];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // creates session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    //creates  session task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               //throws an error with description if API call cannot be made
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               self.workoutArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.filteredWorkoutArray = self.workoutArray;
              //prints out the contents of the API for verification
              NSLog(@"%@", self.workoutArray);
               //loads contents into table view
                [self.tableView reloadData];
               }
    }];
    [task resume];
}

-(void) gymBuddy{
    // creates NSURL object
    NSURL *url = [NSURL URLWithString:@"https://api.api-ninjas.com/v1/exercises?difficulty=advanced"];
    // creates NSURLMutableRequest with the NSURL
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    // configures the NSURLMutable Request with method and headers
    [request setHTTPMethod:@"GET"];
    [request setValue:@"Aq8IKvomBOkXPQELcAKs7Q==kffUR94hO4SaCim1" forHTTPHeaderField:@"X-Api-Key "];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // creates session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    //creates  session task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               //throws an error with description if API call cannot be made
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               self.workoutArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.filteredWorkoutArray = self.workoutArray;
               //prints out the contents of the API for verification
              NSLog(@"%@", self.workoutArray);
               //loads contents into table view
                [self.tableView reloadData];
               }
    }];
    [task resume];
}

//sets the contents of the cells that contain workout title
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workout"];
    //identifies the information to be displayed in each cell
    NSDictionary *workout = self.filteredWorkoutArray[indexPath.section];
    [self recommendWorkouts:cell workout:workout];
    return cell;
}

-(UITableViewCell *)recommendWorkouts:(WorkoutCell *)cell workout:(NSDictionary *)workout {
    //used to set corner radius of cells
    cell.layer.cornerRadius = 5.0f;
    cell.layer.masksToBounds = YES;
    //sets the contents of cells
    cell.workoutName.text = workout[@"name"];
    cell.muscle.text = [NSString stringWithFormat:@"%@%@", @"Muscle targeted: ", workout[@"muscle"]];
    cell.type.text = [NSString stringWithFormat:@"%@%@", @"Type of workout: ", workout[@"type"]];
    cell.instructions.text = workout[@"instructions"];
    return cell;
}

//sets the height for each cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 110;
}

//number of cells required in a table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.filteredWorkoutArray.count;
}

//used to identify number of rows in a table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//space between each cell
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //checks if anything is typed into the search bar
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            //checks the search bar content with the title of the exercise
            return [evaluatedObject[@"name"] containsString:searchText];
        }];
        self.filteredWorkoutArray = [self.workoutArray filteredArrayUsingPredicate:predicate];
    }
    else {
        //displays all workout cells if search bar is blank
        self.filteredWorkoutArray = self.workoutArray;
    }
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //segue to open detailed view if a cell is tapped on
    if([[segue identifier]  isEqualToString:@"details"]) {
        WorkoutCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        //sends the information of the cell to detailed view
        NSDictionary *dataToPass = self.workoutArray[indexPath.section];
        DetailsViewController *detailVC = [segue destinationViewController];
        detailVC.detailDict = dataToPass;
    }
}
@end
