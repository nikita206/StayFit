//
//  RecommendedWorkoutViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/19/22.
//

#import "RecommendedWorkoutViewController.h"
#import "Parse/Parse.h"

@interface RecommendedWorkoutViewController ()

@end

@implementation RecommendedWorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
                   NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                  NSLog(@"%@", dataDictionary);
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
                   NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                  NSLog(@"%@", dataDictionary);
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
                   NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                  NSLog(@"%@", dataDictionary);
                   }
        }];
        [task resume];
    }
}

@end
