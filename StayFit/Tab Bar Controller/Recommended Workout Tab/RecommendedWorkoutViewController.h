//
//  RecommendedWorkoutViewController.h
//  StayFit
//
//  Created by Nikita Agarwal on 7/19/22.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendedWorkoutViewController : ViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

NS_ASSUME_NONNULL_END
