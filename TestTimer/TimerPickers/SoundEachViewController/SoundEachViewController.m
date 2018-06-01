//
//  SoundEachViewController.m
//  TestTimer
//
//  Created by a on 1/22/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "SoundEachViewController.h"
#import "SettingsManager.h"
#import "AppTheme.h"
#import "CustomNavigationBarUIView.h"

@interface SoundEachViewController ()
@property (strong, nonatomic) IBOutlet UILabel *minLabel;
@property (strong, nonatomic) IBOutlet UILabel *secLabel;
@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavigationBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secLabelTrailingConstraint;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;

@end

@implementation SoundEachViewController

- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        [_customNavigationBarView setupLandscapeConstraint];
        [self rotateLandscape];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
        [self rotatePortrait];
    }
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateInterfaceOrientation:toInterfaceOrientation];
    
}


- (void) rotateLandscape{
    if (IS_IPHONE || Utilities.deviceHasAreaInsets) {
        [_secLabel setTextAlignment:NSTextAlignmentLeft];
    }
    if (IS_IPAD_PRO) {
        [_secLabel setTextAlignment:NSTextAlignmentLeft];
    }
    if (IS_IPAD) {
        _secLabelTrailingConstraint.constant = 80;
    }
    
}


- (void)rotatePortrait {
    if (IS_IPHONE || Utilities.deviceHasAreaInsets) {
        [_secLabel setTextAlignment:NSTextAlignmentRight];
    }
    if (IS_IPAD_PRO) {
        [_secLabel setTextAlignment:NSTextAlignmentCenter];
    }
    if (IS_IPAD) {
        [_secLabel setTextAlignment:NSTextAlignmentLeft];
        _secLabelTrailingConstraint.constant = 20;
    }
}


- (void)customBarButtonItem {
    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_doneButton setTitle:@"Done".localized forState:UIControlStateNormal];
    _doneButton.titleLabel.font= [UIFont fontWithName:@"Avenir Next" size:18];
    [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_doneButton setImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateNormal];
    [_doneButton setTintColor:[UIColor colorWithRed:241.0f/255.0f green:163.0f/255.0f blue:34.0f/255.0f alpha:1.0f]];
    [_doneButton setTitleColor:[UIColor colorWithRed:241.0f/255.0f green:163.0f/255.0f blue:34.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_doneButton sizeToFit];
    _doneButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _doneButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _doneButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
   _customRightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:_doneButton];
    [_doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = _customRightBarButtonItem;
    _leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel".localized style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem =_leftBarButtonItem;
    [self.navigationItem.leftBarButtonItem setTintColor:[[AppTheme sharedManager]labelColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:241.0f/255.0f green:163.0f/255.0f blue:34.0f/255.0f alpha:1.0f]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPAD) {
        _minLabel.font = [UIFont fontWithName:@"Avenir Next" size:38];
        _secLabel.font = [UIFont fontWithName:@"Avenir Next" size:38];
    }
    if (IS_IPAD_PRO) {
        _minLabel.font = [UIFont fontWithName:@"Avenir Next" size:52];
        _secLabel.font = [UIFont fontWithName:@"Avenir Next" size:52];
    }
    [self customBarButtonItem];
    self.title=@"Sound each".localized;
    _minutesArray =[[NSMutableArray alloc]init];
    _secondsArray = [[NSMutableArray alloc]init];
    NSString * strValues=[[NSString alloc]init];
    for (int i=0; i<60; i++) {
        strValues = [NSString stringWithFormat:@"%d",i];
        if (i<10) {
            strValues =[NSString stringWithFormat:@"0%d",i];
        }
        if (i<60) {
            [_secondsArray addObject:strValues];
        }
        [_minutesArray addObject:strValues];
    }
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        NSLog(@"LANDSCAPE");
        [self rotateLandscape];
    }
    else
    {
        NSLog(@"PORTRAIT");
        [self rotatePortrait];
    }
    [self updateUI];
    
    if(_fullSecSoundEach==5){
        [_timeLapSoundPicker selectRow:0 inComponent:kMinComponent animated:NO];
        [_timeLapSoundPicker selectRow:5 inComponent:kSecComponent animated:NO];
    }
    else{
        [_timeLapSoundPicker selectRow:_soundEachMin inComponent:kMinComponent animated:NO];
        [_timeLapSoundPicker selectRow:_soundEachSec inComponent:kSecComponent animated:NO];
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case kMinComponent:
            return [_minutesArray count];
            break;
        case kSecComponent:
            return [_secondsArray count];
        default:
            break;
    }
    return component;
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    if (IS_IPHONE_6P) {
        return 82;
    }
    if (IS_IPHONE_6) {
        return 75;
    }
    if (IS_IPHONE_5) {
        return 60;
    }
    if (IS_IPHONE_4_OR_LESS) {
        return 55;
    }
    if (IS_IPAD)
    {
        return 110;
    }
    if (IS_IPAD_PRO) {
        return 150;
    }
    if (Utilities.deviceHasAreaInsets) {
          return 82;
    }
    return 100;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *columnView = [[UILabel alloc] init];
    if (component==kMinComponent) {
            columnView.text = [NSString stringWithFormat:@"%lu", (long) row];
        
    }
    if (component==kSecComponent) {
            columnView.text = [NSString stringWithFormat:@"%lu ", (long) row];
    }
    if (IS_IPAD_PRO) {
        columnView.font = [UIFont fontWithName:@"Avenir Next" size:140];
    }
    if (IS_IPAD) {
        columnView.font = [UIFont fontWithName:@"Avenir Next" size:105];
    }
    if (IS_IPHONE_6P) {
        columnView.font = [UIFont fontWithName:@"Avenir Next" size:77];
    }
    if (IS_IPHONE_6) {
        columnView.font = [UIFont fontWithName:@"Avenir Next" size:70];
    }
    if (IS_IPHONE_5) {
        columnView.font = [UIFont fontWithName:@"Avenir Next" size:55];
    }
    if (IS_IPHONE_4_OR_LESS) {
        columnView.font = [UIFont fontWithName:@"Avenir Next" size:45];
    }
    if (Utilities.deviceHasAreaInsets) {
        columnView.font = [UIFont fontWithName:@"Avenir Next" size:77];
    }

    columnView.textAlignment = NSTextAlignmentCenter;
    return columnView;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (component)
    {
        case kMinComponent:
            return [_minutesArray objectAtIndex:row];
            break;
        case kSecComponent:
            return [_secondsArray objectAtIndex:row];
        break;}
    return [_minutesArray objectAtIndex:row];
}


-(IBAction)cancelButtonTapped:(id)sender{
    //oricum trebuie sa ma uit de ce _soundEachSec era 0 dar nu 3 by default
    if (_fullSecSoundEach!=0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(IBAction)doneButtonTapped:(id)sender{
    _soundEachMin=[_timeLapSoundPicker selectedRowInComponent:kMinComponent];
    _soundEachSec=[_timeLapSoundPicker selectedRowInComponent:kSecComponent];
    if ((_soundEachMin==0 && _soundEachSec==0) ) {
        [_timeLapSoundPicker selectRow:0 inComponent:kMinComponent animated:YES];
        [_timeLapSoundPicker selectRow:1 inComponent:kSecComponent animated:YES];
        _soundEachSec=1;
    }
    _fullSecSoundEach = _soundEachMin*60+_soundEachSec%60;
    [self delegateSoundEachViewController];
    [self.navigationController popViewControllerAnimated:YES];
    [_timeLapSoundPicker reloadAllComponents];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _soundEachMin=[_timeLapSoundPicker selectedRowInComponent:kMinComponent];
    _soundEachSec=[_timeLapSoundPicker selectedRowInComponent:kSecComponent];
    if ((_soundEachMin==0 && _soundEachSec==0) ) {
        [_timeLapSoundPicker selectRow:0 inComponent:kMinComponent animated:YES];
        [_timeLapSoundPicker selectRow:1 inComponent:kSecComponent animated:YES];
        _soundEachSec=1;
    }
    [_timeLapSoundPicker reloadAllComponents];
}


- (void) delegateSoundEachViewController{
    if ([_delegate respondsToSelector:@selector(dataFromSoundEachMinViewController:pickedMinValue:pickedSecValue:)]) {
        [_delegate dataFromSoundEachMinViewController:_fullSecSoundEach pickedMinValue:_soundEachMin pickedSecValue:_soundEachSec];
    }
}


- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:AppUpdateThemeNotificationName object:nil];
}


- (void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AppUpdateThemeNotificationName object:nil];
}


- (void)updateUI{
    [_customNavigationBarView setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    [_customNavigationBarViewIpad setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[AppTheme sharedManager] labelColor],
       NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]}];
    [self.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[[AppTheme sharedManager]labelColor],
                                                     NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]} forState:UIControlStateNormal];
}


- (void)dealloc{
    [self removeObserver];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (IS_IPAD_PRO) {
        switch (component){
            case 0:
                return 360.0f;
            case 1:
                return 370.0f;
        }
    }
    else if (IS_IPAD) {
        switch (component){
            case 0:
                return 210.0f;
            case 1:
                return 220.0f;
        }
    }
    else if (IS_IPHONE_6P) {
        switch (component){
            case 0:
                return 170.0f;
            case 1:
                return 180.0f;
        }
    }
    else if(IS_IPHONE_6){
        switch (component){
            case 0:
                return 140.0f;
            case 1:
                return 150.0f;
        }
    }
    else if(IS_IPHONE_5){
        switch (component){
            case 0:
                return 120.0f;
            case 1:
                return 130.0f;
        }
    }
    else if(IS_IPHONE_4_OR_LESS){
        switch (component){
            case 0:
                return 100.0f;
            case 1:
                return 110.0f;
        }
    }
    else if (Utilities.deviceHasAreaInsets) {
        switch (component){
            case 0:
                return 150.0f;
            case 1:
                return 160.0f;
        }
    }
    return 130;
}

@end
