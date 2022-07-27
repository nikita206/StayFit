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
@end

@implementation CommunityViewController
@synthesize segout;
- (void)viewDidLoad {
    [super viewDidLoad];
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
    //stores all the posts in an array
    self.arrayOfFitnessPosts = [[NSMutableArray alloc] init];
    [self fetchFitnessPosts];
}

-(void) recipesCase{
    //stores all the posts in an array
    self.addButton.hidden = false;
    //stores all the posts in an array
    self.arrayofRecipesPosts = [[NSMutableArray alloc] init];
    [self fetchRecipesPosts];
}

-(void) gymBuddy{
    //hides the "New Post" button in Gym Buddy segment
    self.addButton.hidden = true;
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
            NSLog(@"%@", @"this is an error");
        }
        //ends the refresh control once posts are loaded
        [self.refreshControl endRefreshing];
    }];
}

-(void) fetchGymBuddies{
    //creates a new query for matching gym buddies on the basis of location and fitness level
    PFQuery *postQuery = [PFQuery queryWithClassName:@"_User"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"fitnessLevel" equalTo:[PFUser currentUser][@"fitnessLevel"]];
    [postQuery whereKey:@"city" equalTo:[PFUser currentUser][@"city"]];
    [postQuery whereKey:@"username" notEqualTo:[PFUser currentUser].username];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts.count) {
            //loads the gym buddies posts onto the view if found
            self.arrayOfGymBuddies = posts;
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

//sets table view according to the active segment
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //loads data when the fitness segment is active
    switch(self.segout.selectedSegmentIndex){
        case 0: {
            FitnessFeedCell *cell = [self.fitnessTableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
            //sets the contents for each cell
            Post *post = self.arrayOfFitnessPosts[indexPath.row];
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
        //loads data when the recipes segment is active
        case 1: {
            RecipesFeedCell *cell = [self.fitnessTableView dequeueReusableCellWithIdentifier:@"postCellTwo" forIndexPath:indexPath];
            //sets the contents for each cell
            recipesPost *post = self.arrayofRecipesPosts[indexPath.row];
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
        //loads data when Gym Buddy segment is active
        case 2: {
            GymBuddyCell *cell = [self.fitnessTableView dequeueReusableCellWithIdentifier:@"postCellThree" forIndexPath:indexPath];
            //sets the contents for each cell
            PFObject *user = [self.arrayOfGymBuddies objectAtIndex:indexPath.row];
            cell.author.text = [NSString stringWithFormat:@"%@%@%@", [user objectForKey:@"firstName"]  , @" ", [user objectForKey:@"lastName"]];
            cell.username.text = [user objectForKey:@"username"];
            cell.levelOfFitness.text = [user objectForKey:@"fitnessLevel"];
            cell.location.text = [user objectForKey:@"city"];
            cell.pfp.file = [user objectForKey:@"profileImage"];
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
    }
    return [UITableViewCell new];
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

@end
