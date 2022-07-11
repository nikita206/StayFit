//
//  CommunityViewController.h
//  StayFit
//
//  Created by Nikita Agarwal on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommunityViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *check;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segout;
- (IBAction)segact:(id)sender;

@end

NS_ASSUME_NONNULL_END
