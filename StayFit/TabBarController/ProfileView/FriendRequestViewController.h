//
//  FriendRequestViewController.h
//  StayFit
//
//  Created by Nikita Agarwal on 8/11/22.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendRequestViewController : ViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)accept:(id)sender;
- (IBAction)decline:(id)sender;

@end

NS_ASSUME_NONNULL_END
