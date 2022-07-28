//
//  SignupViewController.h
//  StayFit
//
//  Created by Nikita Agarwal on 7/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignupViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>{}
@property (weak, nonatomic) IBOutlet UITextField *addressField;
- (IBAction)address:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *height;
@property (weak, nonatomic) IBOutlet UITextField *weight;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
- (IBAction)didTapBack:(id)sender;
- (IBAction)didTapSignup:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *fitnessLevel;
@property (nonatomic, retain) UIPickerView *statePicker;
@property (nonatomic, retain) UIPickerView *levelPicker;
@property (nonatomic, retain) NSArray *stateArray;
@property (nonatomic, retain) NSArray *levelArray;
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView;
- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@end

NS_ASSUME_NONNULL_END
