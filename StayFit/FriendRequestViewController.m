//
//  FriendRequestViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 8/11/22.
//

#import "FriendRequestViewController.h"
#import "friendreqTableViewCell.h"
#import "Parse/Parse.h"
@interface FriendRequestViewController ()  <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *friendreqArray;
@property (nonatomic, strong) NSMutableArray *friendName;
@property (nonatomic, strong) NSMutableArray *friendObjectId;
@end

@implementation FriendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.friendObjectId = [[NSMutableArray alloc]init];
    self.friendreqArray = [[NSMutableArray alloc]init];
    //creates a new query for fitness posts in the descending order of post created time
    PFQuery *friendQuery = [PFQuery queryWithClassName:@"friends"];
    PFObject *currentUserObject = [[PFUser currentUser]objectId];
    NSLog(@"current user ID %@",currentUserObject);
    [friendQuery whereKey:@"toUser" equalTo:currentUserObject];
    [friendQuery whereKey:@"status" equalTo:@"pending"];
    [friendQuery orderByDescending:@"createdAt"];
    
    [friendQuery includeKey:@"toUser"];
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (error)
    {
        NSLog(@"could not find friends");
    }
    else {
        NSLog(@"friendRequestCount = %d", objects.count);
        for (PFObject *object in objects) {
             NSLog(@"object is %@", object);
            [self.friendreqArray addObject:object[@"fromUser"]];
            [self.friendObjectId addObject:object.objectId];
        }
        NSLog(@"array is %@",self.friendObjectId);
        [self.tableView reloadData];

    }
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    friendreqTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"friend" forIndexPath:indexPath];
    //sets the contents for each cell
    NSString *friendId = self.friendreqArray[indexPath.row];
    NSLog(@"%@",friendId);
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:friendId];
    [query includeKey:@"firstName"];
    PFObject* list = [query getFirstObject];
    NSLog(@"list is %@", list);
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if(!error){
            if (posts.count) {
                self.friendName = posts;
            }
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
    
    cell.name.text = [NSString stringWithFormat:@"%@%@%@", list[@"firstName"]  , @" ", list[@"lastName"]];
    cell.profilePic.file = list[@"profileImage"];
    [cell.profilePic loadInBackground];
    //sets the radius for porfile pic
    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/2;
    cell.profilePic.clipsToBounds = YES;
    cell.level.text = list[@"fitnessLevel"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendreqArray.count;
}


- (IBAction)decline:(id)sender {
    [self ShowAlert:@"Friend request declined"];
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSLog(@"This was the index %ld", (long)hitIndex.row);
    PFObject *currentUserObject = [[PFUser currentUser]objectId];
    NSLog(@"current user id is %@", currentUserObject);
    NSString *objectId = self.friendObjectId[(long)hitIndex.row];
    PFQuery *query = [PFQuery queryWithClassName:@"friends"];
    [query getObjectInBackgroundWithId:objectId
                                 block:^(PFObject *friend, NSError *error) {
    
        friend[@"status"] = @"declined";
        [friend saveInBackground];
        }];
    [self.friendObjectId removeObject:objectId];
    [self.friendreqArray removeObject:self.friendreqArray[(long)hitIndex.row]];
    [self.tableView reloadData];
}

- (IBAction)accept:(id)sender {
    [self ShowAlert:@"Friend request accepted"];
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSLog(@"This was the index %ld", (long)hitIndex.row);
    PFObject *currentUserObject = [[PFUser currentUser]objectId];
    NSLog(@"current user id is %@", currentUserObject);
    NSString *objectId = self.friendObjectId[(long)hitIndex.row];
    PFQuery *query = [PFQuery queryWithClassName:@"friends"];
    [query getObjectInBackgroundWithId:objectId
                                 block:^(PFObject *friend, NSError *error) {
    
        friend[@"status"] = @"accepted";
        [friend saveInBackground];
        }];
    [self.friendObjectId removeObject:objectId];
    [self.friendreqArray removeObject:self.friendreqArray[(long)hitIndex.row]];
    [self.tableView reloadData];
}

- (void) ShowAlert:(NSString *)Message {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:@""
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alert.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [UIColor colorWithRed: 11.0/255.0 green: 104.0/255.0 blue:164.0/255.0 alpha: 1.0];
    }
    NSMutableAttributedString *AS = [[NSMutableAttributedString alloc] initWithString:Message];
    [AS addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0,AS.length)];
    [alert setValue:AS forKey:@"attributedTitle"];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    });
}
@end
