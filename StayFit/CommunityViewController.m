//
//  CommunityViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/11/22.
//

#import "CommunityViewController.h"
#import "Parse/Parse.h"
#import "FitnessFeedCell.h"
@interface CommunityViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *arrayOfFitnessPosts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation CommunityViewController
@synthesize segout;
- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.fitnessTableView insertSubview:self.refreshControl atIndex:0];
    [self fetchPosts];
}

-(void) recipesCase{

}

-(void) gymBuddy{;

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
        return cell;
    } else if (self.segout.selectedSegmentIndex == 1) {
        
    } else if (self.segout.selectedSegmentIndex == 2) {
        
    }
    
    return [UITableViewCell new];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfFitnessPosts.count;
}

@end
