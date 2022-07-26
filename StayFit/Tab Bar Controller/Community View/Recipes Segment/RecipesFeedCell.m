//
//  RecipesFeedCell.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/13/22.
//

#import "RecipesFeedCell.h"

@implementation RecipesFeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setPost:(recipesPost *)post {
   _post = post;
}

@end
