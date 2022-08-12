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
@property (nonatomic, strong) NSMutableArray *friendObjectId;
@end

@implementation FriendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.friendObjectId = [[NSMutableArray alloc]init];
    self.friendreqArray = [[NSMutableArray alloc]init];
    [self friendRequestsFromUser];
}

//stores information of users who sent the friend request to the current user
-(void)friendRequestsFromUser{
    //runs the query to see a list of users who sent the request
    PFQuery *friendQuery = [PFQuery queryWithClassName:@"friends"];
    PFObject *currentUserObject = [[PFUser currentUser]objectId];
    [friendQuery whereKey:@"toUser" equalTo:currentUserObject];
    [friendQuery whereKey:@"status" equalTo:@"pending"];
    //added in the order of latest to oldest requests
    [friendQuery orderByDescending:@"createdAt"];
    [friendQuery includeKey:@"toUser"];
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (error)
    {
        NSLog(@"could not find friends");
    }
    else {
        for (PFObject *object in objects) {
            //adds the id of the user who sent the request to array
            [self.friendreqArray addObject:object[@"fromUser"]];
            //adds the object id of the request stored in Parse
            [self.friendObjectId addObject:object.objectId];
        }
        [self.tableView reloadData];
    }
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    friendreqTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"friend" forIndexPath:indexPath];
    NSString *friendId = self.friendreqArray[indexPath.row];
    [self getRequestSenderDetails:cell string:friendId];
    return cell;
}

-(UITableViewCell *)getRequestSenderDetails:(friendreqTableViewCell *)cell string:(NSString *)friendId{
    //runs the query to get the details of the user who sent the friend request
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:friendId];
    [query includeKey:@"firstName"];
    PFObject* list = [query getFirstObject];
    //sets cell contents of the user who sent the friend request
    cell.name.text = [NSString stringWithFormat:@"%@%@%@", list[@"firstName"]  , @" ", list[@"lastName"]];
    cell.profilePic.file = list[@"profileImage"];
    [cell.profilePic loadInBackground];
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
