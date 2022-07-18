//
//  FitnessFeedCell.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/12/22.
//

#import "FitnessFeedCell.h"

@implementation FitnessFeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setPost:(Post *)post {
   _post = post;
}

@end
