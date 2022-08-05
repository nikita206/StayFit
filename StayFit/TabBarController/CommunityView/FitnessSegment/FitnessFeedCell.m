//
//  FitnessFeedCell.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/12/22.
//

#import "FitnessFeedCell.h"

@protocol CellConfigurable <NSObject>
@property (strong, nonatomic) UILabel *username;


@end

@implementation FitnessFeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setPost:(Post *)post {
    _post = post;
}

-(void)configureCell {
//    self.author.text = [NSString stringWithFormat:@"%@%@%@", post[@"author"][@"firstName"]  , @" ", self.post[@"author"][@"lastName"]];
//    cell.username.text = [NSString stringWithFormat:@"%@%@", @"@"  , post[@"author"][@"username"]];
//    cell.caption.text = post[@"caption"];
//    cell.photoImageView.file = post[@"image"];
//    [cell.photoImageView loadInBackground];
//    cell.level.text = post[@"author"][@"fitnessLevel"];
//    cell.pfp.file = post[@"author"][@"profileImage"];
//    [cell.pfp loadInBackground];
//    //sets the radius for porfile pic
//    cell.pfp.layer.cornerRadius = cell.pfp.frame.size.width/2;
//    cell.pfp.clipsToBounds = YES;
}

@end
