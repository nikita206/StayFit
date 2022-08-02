//
//  CommunityViewController.h
//  StayFit
//
//  Created by Nikita Agarwal on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommunityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segout;
- (IBAction)segact:(id)sender;;
@property (weak, nonatomic) IBOutlet UIView *fitnessView;
@property (weak, nonatomic) IBOutlet UITableView *fitnessTableView;
- (IBAction)sliderChange:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *blankText;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@end

NS_ASSUME_NONNULL_END
