//
//  GymBuddyCell.h
//  StayFit
//
//  Created by Nikita Agarwal on 7/15/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GymBuddyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *levelOfFitness;
@property (weak, nonatomic) IBOutlet UILabel *location;

@end

NS_ASSUME_NONNULL_END
