//
//  CommunityViewController.h
//  StayFit
//
//  Created by Nikita Agarwal on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommunityViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segout;
- (IBAction)segact:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *fitnessView;
@property (weak, nonatomic) IBOutlet UIView *recipesView;
@property (weak, nonatomic) IBOutlet UIView *buddyView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewFitness;

@end

NS_ASSUME_NONNULL_END
