//
//  DetailsViewController.h
//  StayFit
//
//  Created by Nikita Agarwal on 7/21/22.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : ViewController
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *muscle;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *instructions;
@property (strong, nonatomic) NSDictionary *detailDict;
@end

NS_ASSUME_NONNULL_END
