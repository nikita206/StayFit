//
//  ProfileFriendsCell.h
//  StayFit
//
//  Created by Nikita Agarwal on 8/11/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProfileFriendsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;

@end

NS_ASSUME_NONNULL_END
