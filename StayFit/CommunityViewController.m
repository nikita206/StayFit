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
    [self fitnessCase];
}

- (IBAction)segact:(id)sender {
    switch (self.segout.selectedSegmentIndex){
        case 0:
            [self fitnessCase];
            break;
        case 1:
            [self recipesCase];
            break;
        case 2:
            [self gymBuddy];
            break;
    }
}

-(void) fitnessCase{
    self.recipesView.hidden = YES;
    self.buddyView.hidden = YES;
    self.fitnessView.hidden = NO;
}

-(void) recipesCase{
    self.recipesView.hidden = NO;
    self.buddyView.hidden = YES;
    self.fitnessView.hidden = YES;

}

-(void) gymBuddy{
    self.recipesView.hidden = YES;
    self.buddyView.hidden = NO;
    self.fitnessView.hidden = YES;

}
@end
