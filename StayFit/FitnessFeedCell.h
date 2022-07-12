//
//  FitnessFeedCell.h
//  StayFit
//
//  Created by Nikita Agarwal on 7/12/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface FitnessFeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;
@property (strong, nonatomic) Post *post;
@end

NS_ASSUME_NONNULL_END
