//
//  CommunityViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/11/22.
//

#import "CommunityViewController.h"
#import "Parse/Parse.h"
#import "FitnessFeedCell.h"
#import "recipesPost.h"
#import "NewPostViewController.h"
#import "RecipesFeedCell.h"
#import "GymBuddyCell.h"
#import <QuartzCore/QuartzCore.h>
@interface CommunityViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *arrayOfFitnessPosts;
@property (strong, nonatomic) NSArray *arrayofRecipesPosts;
@property (strong, nonatomic) NSArray *arrayOfGymBuddies;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *liked;
@end

@implementation CommunityViewController
@synthesize segout;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.liked = [[NSMutableArray alloc]init];
    //refreshes the page each time a post is added
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.fitnessTableView insertSubview:self.refreshControl atIndex:0];
    self.fitnessTableView.dataSource = self;
    self.fitnessTableView.delegate = self;
    //default view is fitness segment when user clicks on community tab
    [self fitnessCase];
    
}

- (IBAction)segact:(id)sender {
    //checks which segment (Fitness, Recipes, Gym Buddy) is active
    switch (self.segout.selectedSegmentIndex){
        case 0:
            //if the current segment is fitness
            [self fitnessCase];
            break;
        case 1:
            //if the current segment is recipes
            [self recipesCase];
            break;
        case 2:
            //if the current segment is Gym Buddy
            [self gymBuddy];
            break;
    }
}

-(void) fitnessCase{
    self.addButton.hidden = false;
    self.slider.hidden = true;
    self.value.hidden = true;
    self.blankText.hidden = true;
    //stores all the posts in an array
    self.arrayOfFitnessPosts = [[NSMutableArray alloc] init];
    [self fetchFitnessPosts];
}

-(void) recipesCase{
    self.addButton.hidden = false;
    self.slider.hidden = true;
    self.blankText.hidden = true;
    self.value.hidden = true;
    //stores all the posts in an array
    self.arrayofRecipesPosts = [[NSMutableArray alloc] init];
    [self fetchRecipesPosts];
}

-(void) gymBuddy{
    //hides the "New Post" button in Gym Buddy segment
    self.addButton.hidden = true;
    self.slider.hidden = false;
    self.value.hidden = false;
    //stores all the posts in an array
    self.arrayOfGymBuddies = [[NSMutableArray alloc] init];
    [self fetchGymBuddies];
}

-(void) fetchPosts {
    //checks which segment (Fitness, Recipes, Gym Buddy) is active go fetch posts of respective segments
    switch (self.segout.selectedSegmentIndex){
        case 0:
            //if the current segment is fitness
            [self fetchFitnessPosts];
            break;
        case 1:
            //if the current segment is recipes
            [self fetchRecipesPosts];
            break;
        case 2:
            //if the current segment is Gym Buddy
            [self fetchGymBuddies];
            break;
    }
}

-(void) fetchFitnessPosts{
    //creates a new query for fitness posts in the descending order of post created time
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
            if (posts.count) {
                //loads the fitness posts onto the view if found
                self.arrayOfFitnessPosts = posts;
                [self.fitnessTableView reloadData];
            }
            else {
                //throws an error with descriptions if no posts are found in the array
                NSLog(@"%@", error);
            }
            //ends the refresh control once posts are loaded
            [self.refreshControl endRefreshing];
        }];
}
-(void) fetchRecipesPosts{
    //creates a new query for recipes posts in the descending order of post created time
    PFQuery *postQuery = [PFQuery queryWithClassName:@"recipesPost"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts.count) {
            //loads the recipes posts onto the view if found
            self.arrayofRecipesPosts = posts;
            [self.fitnessTableView reloadData];
        }
        else {
            //throws an error with descriptions if no posts are found in the array
            NSLog(@"%@", error);
        }
        //ends the refresh control once posts are loaded
        [self.refreshControl endRefreshing];
    }];
}

-(void) fetchGymBuddies{
    //creates a new query for matching gym buddies on the basis of location and fitness level
    // User's location
    PFGeoPoint *userGeoPoint = [PFUser currentUser][@"location"];
    //query for places
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    // Interested in locations near user.
    [query whereKey:@"location" nearGeoPoint:userGeoPoint withinMiles:[self.value.text doubleValue]];
    [query whereKey:@"username" notEqualTo:[PFUser currentUser].username];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if(!error){
            if (posts.count) {
                [self.liked removeAllObjects];
                for (PFObject *object in posts) {
                     NSLog(@"%@", object.objectId);
                    [self.liked addObject:object.objectId];
                }
                NSLog(@"array is %@", self.liked);
                //loads the gym buddies posts onto the view if found
                self.arrayOfGymBuddies = posts;
                self.blankText.hidden = true;
                [self.fitnessTableView reloadData];
            }
            else {
                self.arrayOfGymBuddies = posts;
                [self.fitnessTableView reloadData];
                self.blankText.hidden = false;
            }
            //ends the refresh control once posts are loaded
            [self.refreshControl endRefreshing];
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
}

//sets table view according to the active segment
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //loads data when the fitness segment is active
    switch(self.segout.selectedSegmentIndex){
        case 0: {
            FitnessFeedCell *cell = [self.fitnessTableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
            //sets the contents for each cell
            Post *post = self.arrayOfFitnessPosts[indexPath.row];
            [self caseFitness: cell post: post];
            return cell;
        }
        //loads data when the recipes segment is active
        case 1: {
            RecipesFeedCell *cell = [self.fitnessTableView dequeueReusableCellWithIdentifier:@"postCellTwo" forIndexPath:indexPath];
            //sets the contents for each cell
            recipesPost *post = self.arrayofRecipesPosts[indexPath.row];
            [self caseRecipes: cell post: post];
            return cell;
        }
        //loads data when Gym Buddy segment is active
        case 2: {
            GymBuddyCell *cell = [self.fitnessTableView dequeueReusableCellWithIdentifier:@"postCellThree" forIndexPath:indexPath];
            //sets the contents for each cell if array is not null
            if(self.arrayOfGymBuddies.count){
                PFUser *user = [self.arrayOfGymBuddies objectAtIndex:indexPath.row];
                [self caseGymBuddy: cell user: user];
            }
            return cell;
        }
    }
    return nil;
}

-(UITableViewCell *)caseFitness:(FitnessFeedCell *)cell post:(Post *)post {
    cell.post = post;
    cell.author.text = [NSString stringWithFormat:@"%@%@%@", post[@"author"][@"firstName"]  , @" ", post[@"author"][@"lastName"]];
    cell.username.text = [NSString stringWithFormat:@"%@%@", @"@"  , post[@"author"][@"username"]];
    cell.caption.text = post[@"caption"];
    cell.photoImageView.file = post[@"image"];
    [cell.photoImageView loadInBackground];
    cell.level.text = post[@"author"][@"fitnessLevel"];
    cell.pfp.file = post[@"author"][@"profileImage"];
    [cell.pfp loadInBackground];
    //sets the radius for porfile pic
    cell.pfp.layer.cornerRadius = cell.pfp.frame.size.width/2;
    cell.pfp.clipsToBounds = YES;
    return cell;
}

-(UITableViewCell *)caseRecipes:(RecipesFeedCell *)cell post:(Post *)post {
    cell.post = post;
    cell.author.text = [NSString stringWithFormat:@"%@%@%@", post[@"author"][@"firstName"]  , @" ", post[@"author"][@"lastName"]];
    cell.username.text = [NSString stringWithFormat:@"%@%@", @"@"  , post[@"author"][@"username"]];
    cell.caption.text = post[@"caption"];
    cell.photoImageView.file = post[@"image"];
    [cell.photoImageView loadInBackground];
    cell.pfp.file = post[@"author"][@"profileImage"];
    [cell.pfp loadInBackground];
    //sets radius for profile pic
    cell.pfp.layer.cornerRadius = cell.pfp.frame.size.width/2;
    cell.pfp.clipsToBounds = YES;
    return cell;
}

-(UITableViewCell *)caseGymBuddy:(GymBuddyCell *)cell user:(PFUser *)user {
    cell.author.text = [NSString stringWithFormat:@"%@%@%@", [user objectForKey:@"firstName"]  , @" ", [user objectForKey:@"lastName"]];
    cell.username.text = [user objectForKey:@"username"];
    cell.levelOfFitness.text = [user objectForKey:@"fitnessLevel"];
    cell.location.text = [NSString stringWithFormat:@"%@, %@", [user objectForKey:@"address"], [user objectForKey:@"city"]];
    cell.pfp.file = user[@"profileImage"];
    [cell.pfp loadInBackground];
    cell.pfp.layer.cornerRadius = 12;
    cell.pfp.clipsToBounds = YES;
    //sets a gradient to the background image
    CALayer *imageViewLayer = cell.pfp.layer;
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.colors = @[ (id)([UIColor blackColor].CGColor), (id)([UIColor clearColor].CGColor) ];
    maskLayer.startPoint = CGPointMake(0, 0);
    maskLayer.endPoint = CGPointMake(1, 1);
    maskLayer.frame = imageViewLayer.bounds;
    imageViewLayer.mask = maskLayer;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //segue for when the add button is clicked for a new post
    if([[segue identifier] isEqualToString:@"makeNewPost"]){
        NewPostViewController *newPostViewController = [segue destinationViewController];
        newPostViewController.segoutValue = (int)self.segout.selectedSegmentIndex;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //returns number of rows on the basis of segment that is active
    switch(self.segout.selectedSegmentIndex){
        case 0:
            //since fitness segment is active, returns count of array of fitness Posts
            return self.arrayOfFitnessPosts.count;
        case 1:
            //since recipes segment is active, returns count of array of recipes Posts
            return self.arrayofRecipesPosts.count;
        case 2:
            //since gym buddy segment is active, returns count of array of gym buddy Posts
            return self.arrayOfGymBuddies.count;
        default:
            return 0;
    }
}


- (IBAction)sliderDidEndEditing:(id)sender {
    NSLog(@"Did end editing");
}


- (IBAction)sliderChange:(id)sender {
    UISlider *slider = (UISlider *) sender;
    NSString *newValue = [NSString stringWithFormat:@"%0.2f", slider.value];
    self.value.text = [NSString stringWithFormat:@"%@ %@", newValue, @"miles"];
    [self fetchGymBuddies];
}
- (IBAction)didTapLike:(id)sender {
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.fitnessTableView];
    NSIndexPath *hitIndex = [self.fitnessTableView indexPathForRowAtPoint:hitPoint];
    NSLog(@"This was the index %ld", (long)hitIndex.row);
    PFObject *currentUserObject = [[PFUser currentUser]objectId];
    NSLog(@"current user id is %@", currentUserObject);
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:currentUserObject];
    //request them
    PFObject *friend = [PFObject objectWithClassName:@"friends"];
    friend[@"fromUser"] = currentUserObject;
    //selected user is the user at the cell that was selected
    friend[@"toUser"] = self.liked[(long)hitIndex.row];
    // set the initial status to pending
    friend[@"status"] = @"pending";
    [friend saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"friend req sent");
        }
        else {
            NSLog(@"Error");
        }
    }];
}
@end
