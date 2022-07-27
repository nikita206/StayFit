//
//  RecipesFeedCell.h
//  StayFit
//
//  Created by Nikita Agarwal on 7/13/22.
//

#import <UIKit/UIKit.h>
#import "recipesPost.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecipesFeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;
@property (weak, nonatomic) IBOutlet PFImageView *pfp;
@property (strong, nonatomic) recipesPost *post;
@end

NS_ASSUME_NONNULL_END
