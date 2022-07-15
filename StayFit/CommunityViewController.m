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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.fitnessTableView insertSubview:self.refreshControl atIndex:0];
    self.fitnessTableView.dataSource = self;
    self.fitnessTableView.delegate = self;
    [self fitnessCase];
    
}

- (IBAction)segact:(id)sender {
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
    self.arrayOfFitnessPosts = [[NSMutableArray alloc] init];
    [self fetchPosts];
}

-(void) recipesCase{
    self.arrayofRecipesPosts = [[NSMutableArray alloc] init];
    [self fetchRecipesPosts];
}

-(void) gymBuddy{;
    self.arrayOfGymBuddies = [[NSMutableArray alloc] init];
    [self fetchGymBuddies];
}

-(void) fetchPosts{
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
    PFQuery *postQuery = [PFQuery queryWithClassName:@"_User"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"fitnessLevel" equalTo:[PFUser currentUser][@"fitnessLevel"]];
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
    if(self.segout.selectedSegmentIndex == 0) {
        FitnessFeedCell *cell = [self.fitnessTableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
        Post *post = self.arrayOfFitnessPosts[indexPath.row];
        cell.post = post;
        cell.author.text = [NSString stringWithFormat:@"%@%@%@", post[@"author"][@"firstName"]  , @" ", post[@"author"][@"lastName"]];;
        cell.username.text = post[@"author"][@"username"];
        cell.caption.text = post[@"caption"];
        cell.photoImageView.file = post[@"image"];
        [cell.photoImageView loadInBackground];
        cell.level.text = post[@"author"][@"fitnessLevel"];
        return cell;
    }
    
    else if (self.segout.selectedSegmentIndex == 1) {
        RecipesFeedCell *cell = [self.fitnessTableView dequeueReusableCellWithIdentifier:@"postCellTwo" forIndexPath:indexPath];
        recipesPost *post = self.arrayofRecipesPosts[indexPath.row];
        cell.post = post;
        cell.author.text = [NSString stringWithFormat:@"%@%@%@", post[@"author"][@"firstName"]  , @" ", post[@"author"][@"lastName"]];;
        cell.username.text = post[@"author"][@"username"];
        cell.caption.text = post[@"caption"];
        cell.photoImageView.file = post[@"image"];
        [cell.photoImageView loadInBackground];
        return cell;
    }
    
    else if (self.segout.selectedSegmentIndex == 2) {
        GymBuddyCell *cell = [self.fitnessTableView dequeueReusableCellWithIdentifier:@"postCellThree" forIndexPath:indexPath];
        PFUser *user = self.arrayOfGymBuddies[indexPath.row];
        cell.author.text = [NSString stringWithFormat:@"%@%@%@", user[@"firstName"] , @" ", user[@"lastName"]];
        cell.username.text = user.username;
        cell.levelOfFitness.text = user[@"fitnessLevel"];
        return cell;
    }
    
    return [UITableViewCell new];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"makeNewPost"]){
        
        NewPostViewController *newPostViewController = [segue destinationViewController];
       
        newPostViewController.segoutValue = (int)self.segout.selectedSegmentIndex;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.segout.selectedSegmentIndex == 0) {
        return self.arrayOfFitnessPosts.count;
    }
    
    else if (self.segout.selectedSegmentIndex == 1) {
        return self.arrayofRecipesPosts.count;
    }
    
    else if (self.segout.selectedSegmentIndex == 2) {
        
    }
    
    return 0;
}

@end
