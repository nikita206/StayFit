//
//  WorkoutCell.h
//  StayFit
//
//  Created by Nikita Agarwal on 7/20/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkoutCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *workoutName;
@property (weak, nonatomic) IBOutlet UILabel *muscle;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *instructions;
@end

NS_ASSUME_NONNULL_END
