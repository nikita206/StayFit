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
             NSLog(@"%@", object[@"fromUser"]);
            [self.friendreqArray addObject:object[@"fromUser"]];
            [self.friendObjectId addObject:object.objectId];
        }
        NSLog(@"array is %@",self.friendObjectId);
        [self.tableView reloadData];
//        PFObject *object=[objects objectAtIndex:0];
//        NSLog(@"%@", object);
//
//        self.friendreqArray= objects;
//        [self.tableView reloadData];
//        NSLog(@"%@",object[@"toUser"]);
//
//        PFUser *user1= object[@"toUser"];
//
//        NSString *friendName = [NSString stringWithFormat:@"%@ %@",user1[@"FirstName"], user1[@"LastName"] ];
//        NSLog(@"name= %@",friendName);

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
    NSLog(@"%@", list[@"firstName"]);
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
    
    cell.name.text = list[@"firstName"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendreqArray.count;
}


- (IBAction)decline:(id)sender {
}

- (IBAction)accept:(id)sender {
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
@end
