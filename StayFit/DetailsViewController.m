//
//  DetailsViewController.m
//  StayFit
//
//  Created by Nikita Agarwal on 7/21/22.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.name.text = self.detailDict[@"name"];
    self.muscle.text = self.detailDict[@"muscle"];
    self.type.text = self.detailDict[@"type"];
    self.level.text = self.detailDict[@"difficulty"];
    self.instructions.text = self.detailDict[@"instructions"];
}

@end
