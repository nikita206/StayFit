//
//  CommunityViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/11/22.
//

#import "CommunityViewController.h"

@interface CommunityViewController ()

@end

@implementation CommunityViewController
@synthesize segout;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self firstCase];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) firstCase{
    self.check.text = @"First";
}

- (IBAction)segact:(id)sender {
    switch (self.segout.selectedSegmentIndex){
        case 0:
            [self firstCase];
            break;
        case 1:
            self.check.text = @"Second";
            break;
        case 2:
            self.check.text = @"Third";
            break;
    }
}
@end
