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
    [self fitnessCase];
    
}

- (IBAction)segact:(id)sender {
    //checks which segment is active
    switch (self.segout.selectedSegmentIndex){
        case 0:
            [self fitnessCase];
            break;
        case 1:
            [self recipesCase];
            break;
        case 2:
            [self gymBuddy];
            break;
    }
}

-(void) fitnessCase{
    self.addButton.hidden = false;
    self.arrayOfFitnessPosts = [[NSMutableArray alloc] init];
    [self fetchFitnessPosts];
}

-(void) recipesCase{
    self.addButton.hidden = false;
    self.arrayofRecipesPosts = [[NSMutableArray alloc] init];
    [self fetchRecipesPosts];
}

-(void) gymBuddy{
    self.addButton.hidden = true;
    self.arrayOfGymBuddies = [[NSMutableArray alloc] init];
    [self fetchGymBuddies];
}

-(void) fetchPosts {
    if (self.segout.selectedSegmentIndex == 0) {
        [self fetchFitnessPosts];
    } else if (self.segout.selectedSegmentIndex == 1) {
        [self fetchRecipesPosts];
    } else {
        [self fetchGymBuddies];
    }
}

-(void) fetchFitnessPosts{
    //creates a new query for fitness posts
        PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
        [postQuery orderByDescending:@"createdAt"];
        [postQuery includeKey:@"author"];
        postQuery.limit = 20;
    
        [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
            if (posts) {
                self.arrayOfFitnessPosts = posts;
                [self.fitnessTableView reloadData];
            }
            else {
                NSLog(@"%@", error);
            }
            [self.refreshControl endRefreshing];
        }];
}
-(void) fetchRecipesPosts{
    //creates a new query for recipes posts
    PFQuery *postQuery = [PFQuery queryWithClassName:@"recipesPost"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;

    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts.count) {
            self.arrayofRecipesPosts = posts;
            [self.fitnessTableView reloadData];
        }
        else {
            NSLog(@"%@", @"no posts");
        }
        [self.refreshControl endRefreshing];
    }];
}

-(void) fetchGymBuddies{
    //creates a new query for matching gym buddies
    PFQuery *postQuery = [PFQuery queryWithClassName:@"_User"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"fitnessLevel" equalTo:[PFUser currentUser][@"fitnessLevel"]];
    [postQuery whereKey:@"city" equalTo:[PFUser currentUser][@"city"]];
    [postQuery whereKey:@"username" notEqualTo:[PFUser currentUser].username];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts.count) {
            self.arrayOfGymBuddies = posts;
            [self.fitnessTableView reloadData];
        }
        else {
            NSLog(@"%@", error);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //sets table view according to the active segment
    if(self.segout.selectedSegmentIndex == 0) {
        FitnessFeedCell *cell = [self.fitnessTableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
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
        cell.pfp.layer.cornerRadius = cell.pfp.frame.size.width/2;
        cell.pfp.clipsToBounds = YES;
        return cell;
    }
    
    else if (self.segout.selectedSegmentIndex == 1) {
        RecipesFeedCell *cell = [self.fitnessTableView dequeueReusableCellWithIdentifier:@"postCellTwo" forIndexPath:indexPath];
        recipesPost *post = self.arrayofRecipesPosts[indexPath.row];
        cell.post = post;
        cell.author.text = [NSString stringWithFormat:@"%@%@%@", post[@"author"][@"firstName"]  , @" ", post[@"author"][@"lastName"]];
        cell.username.text = [NSString stringWithFormat:@"%@%@", @"@"  , post[@"author"][@"username"]];
        cell.caption.text = post[@"caption"];
        cell.photoImageView.file = post[@"image"];
        [cell.photoImageView loadInBackground];
        cell.pfp.file = post[@"author"][@"profileImage"];
        [cell.pfp loadInBackground];
        cell.pfp.layer.cornerRadius = cell.pfp.frame.size.width/2;
        cell.pfp.clipsToBounds = YES;
        return cell;
    }
    
    else if (self.segout.selectedSegmentIndex == 2) {
        GymBuddyCell *cell = [self.fitnessTableView dequeueReusableCellWithIdentifier:@"postCellThree" forIndexPath:indexPath];
        PFObject *user = [self.arrayOfGymBuddies objectAtIndex:indexPath.row];
        cell.author.text = [NSString stringWithFormat:@"%@%@%@", [user objectForKey:@"firstName"]  , @" ", [user objectForKey:@"lastName"]];
        cell.username.text = [user objectForKey:@"username"];
        cell.levelOfFitness.text = [user objectForKey:@"fitnessLevel"];
        cell.location.text = [user objectForKey:@"city"];
        cell.pfp.file = [user objectForKey:@"profileImage"];
        [cell.pfp loadInBackground];
        cell.pfp.layer.cornerRadius = 12;
        cell.pfp.clipsToBounds = YES;
        CALayer *imageViewLayer = cell.pfp.layer;
        CAGradientLayer *maskLayer = [CAGradientLayer layer];
        maskLayer.colors = @[ (id)([UIColor blackColor].CGColor), (id)([UIColor clearColor].CGColor) ];
        maskLayer.startPoint = CGPointMake(0, 0);
        maskLayer.endPoint = CGPointMake(1, 1);
        maskLayer.frame = imageViewLayer.bounds; 
        imageViewLayer.mask = maskLayer;
        return cell;
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
    if(self.segout.selectedSegmentIndex == 0) {
        return self.arrayOfFitnessPosts.count;
    }
    
    else if (self.segout.selectedSegmentIndex == 1) {
        return self.arrayofRecipesPosts.count;
    }
    
    else if (self.segout.selectedSegmentIndex == 2) {
        return self.arrayOfGymBuddies.count;
    }
    
    return 0;
}

@end
