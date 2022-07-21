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

@interface RecommendedWorkoutViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *workoutArray;
@end

@implementation RecommendedWorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.workoutArray = [[NSMutableArray alloc] init];
    [self fetchWorkouts];
}


-(void) fetchWorkouts {
    PFUser *currentUser = [PFUser currentUser];
    if([currentUser[@"fitnessLevel"]  isEqual: @"Beginner"]){
        
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
                   NSLog(@"%@", [error localizedDescription]);
               }
               else {
                   self.workoutArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                  NSLog(@"%@", self.workoutArray);
                    [self.tableView reloadData];
                   }
        }];
        [task resume];
    }
    else if([currentUser[@"fitnessLevel"]  isEqual: @"Intermediate"]){
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
                   NSLog(@"%@", [error localizedDescription]);
               }
               else {
                   self.workoutArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                  NSLog(@"%@", self.workoutArray);
                    [self.tableView reloadData];
                   }
        }];
        [task resume];
    }
    else if([currentUser[@"fitnessLevel"]  isEqual: @"Advanced"]){
        
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
                   NSLog(@"%@", [error localizedDescription]);
               }
               else {
                   self.workoutArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                  NSLog(@"%@", self.workoutArray);
                    [self.tableView reloadData];
                   }
        }];
        [task resume];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workout"];
    NSDictionary *workout = self.workoutArray[indexPath.section];
    cell.layer.cornerRadius = 7.0f;
    cell.layer.masksToBounds = YES;
    cell.workoutName.text = workout[@"name"];
    cell.muscle.text = [NSString stringWithFormat:@"%@%@", @"Muscle targeted: ", workout[@"muscle"]];
    cell.type.text = [NSString stringWithFormat:@"%@%@", @"Type of workout: ", workout[@"type"]];
    cell.instructions.text = workout[@"instructions"];
    cell.layer.masksToBounds = false;
    cell.layer.shadowOpacity = 0.23;
    cell.layer.shadowRadius = 4;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.workoutArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier]  isEqualToString:@"details"]) {
    WorkoutCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dataToPass = self.workoutArray[indexPath.section];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
    }
}
@end
