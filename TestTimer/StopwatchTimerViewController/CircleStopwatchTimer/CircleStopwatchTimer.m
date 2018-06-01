//
//  CircleStopwatchTimer.m
//  TestTimer
//
//  Created by Andrei on 11/6/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "CircleStopwatchTimer.h"

@implementation CircleStopwatchTimer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setStopwatchCircleType:(StopwatchCircleType)stopwatchCircleType {
    if (IS_IPAD || IS_IPAD_PRO) {
        self.thickness = 20;
    }else{
        self.thickness = 11;
    }
    _stopwatchCircleType = stopwatchCircleType;
    [_stopwatchTitleLabel setText:[self stopwatchTitle]];
}



- (void)setStopwatchSecondsValue:(NSNumber *)stopwatchSecondsValue {
    [_stopwatchTimeLabel setText:[Utilities timeFormatString:stopwatchSecondsValue]];
}


- (NSString *)stopwatchTitle {
    NSString *stopwatchTitle;
    switch (_stopwatchCircleType) {
        case StopwatchPrepare:
            stopwatchTitle = @"Prepare".localized;
            break;
            case StopwatchTimeLap:
            stopwatchTitle = @"Time lap".localized;
            break;
        default:
            stopwatchTitle = @"Prepare".localized;
            break;
    }
    return stopwatchTitle;
}


- (void)setNullValue {
    [_stopwatchTimeLabel setText:[Utilities timeFormatString:@(0)]];
}


- (void)setupLandscapeConstraints {
    if(IS_IPAD){
        _topStopwatchTitleLabelConstraint.constant = 64;
        [_verticalSpacingStopwatchTimeLabelConstraint setConstant:-80.5];
        _topStopwatchTimeLabelConstraint.constant = 50;
        _centerHorizontalStopwatchTimeLabelConstraint = [_centerHorizontalStopwatchTimeLabelConstraint updatePriority:999];
        _bottomStopwatchTimeLabelConstraint.constant = 230;
        _leadingStopwatchTimeLabelConstraint.constant = 44;
        _trailingStopwatchTimeLabelConstraint.constant = 44;
        if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
            [_stopwatchTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:110]]; // 150
        }else{
            [_stopwatchTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:160]]; // 150
        }
    }
    else if (IS_IPAD_PRO) {
        _topStopwatchTitleLabelConstraint.constant = 64;
        _topStopwatchTimeLabelConstraint.constant = 50;
        _centerHorizontalStopwatchTimeLabelConstraint = [_centerHorizontalStopwatchTimeLabelConstraint updatePriority:999];
        _bottomStopwatchTimeLabelConstraint.constant = 260;
        _leadingStopwatchTimeLabelConstraint.constant = 44;
        _trailingStopwatchTimeLabelConstraint.constant = 44;
        [_stopwatchTitleLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:75]];
//        [_stopwatchTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:150]];
        if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
            [_stopwatchTimeLabel  setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:150]]; // 150
        }else{
            [_stopwatchTimeLabel  setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:200]]; // 150
        }
        [_verticalSpacingStopwatchTimeLabelConstraint setConstant:-150.5];
    }
    
    _equalHeightStopwatchTimeLabelConstraint  = [_equalHeightStopwatchTimeLabelConstraint updateMultiplier:1];
    _equalWidthStopwatchTimeLabelConstraint = [_equalWidthStopwatchTimeLabelConstraint updateMultiplier:1];
    _equalHeightStopwatchTitleLabelConstraint = [_equalHeightStopwatchTitleLabelConstraint updateMultiplier:1];
    _equalWidthStopwatchTitleLabelConstraint = [_equalWidthStopwatchTitleLabelConstraint updateMultiplier:1];
}


- (void)setupPortraitConstraints {
    
    if (IS_IPAD) {
        _topStopwatchTitleLabelConstraint.constant = 134;
        _topStopwatchTimeLabelConstraint.constant = 152;
        _centerHorizontalStopwatchTimeLabelConstraint = [_centerHorizontalStopwatchTimeLabelConstraint updatePriority:1000];
        _bottomStopwatchTimeLabelConstraint.constant = 152.5;
        _leadingStopwatchTimeLabelConstraint.constant = 3;
        _trailingStopwatchTimeLabelConstraint.constant = 3;
        _equalHeightStopwatchTimeLabelConstraint  = [_equalHeightStopwatchTimeLabelConstraint updateMultiplier:0.3];
        _equalWidthStopwatchTimeLabelConstraint = [_equalWidthStopwatchTimeLabelConstraint updateMultiplier:0.4];
        if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
            [_stopwatchTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:110]]; // 150
        }else{
            [_stopwatchTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:160]]; // 150
        }
        
    }else if(IS_IPAD_PRO){
        _topStopwatchTitleLabelConstraint.constant = 134;
        _topStopwatchTimeLabelConstraint.constant = 152;
        _centerHorizontalStopwatchTimeLabelConstraint = [_centerHorizontalStopwatchTimeLabelConstraint updatePriority:1000];
        _bottomStopwatchTimeLabelConstraint.constant = 152.5;
        _leadingStopwatchTimeLabelConstraint.constant = 15;
        _trailingStopwatchTimeLabelConstraint.constant = 15;
        _equalHeightStopwatchTimeLabelConstraint  = [_equalHeightStopwatchTimeLabelConstraint updateMultiplier:0.3];
        _equalWidthStopwatchTimeLabelConstraint = [_equalWidthStopwatchTimeLabelConstraint updateMultiplier:0.4];
        [_stopwatchTitleLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:60]];
        [_verticalSpacingStopwatchTimeLabelConstraint setConstant:-50.5];
        if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
            [_stopwatchTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:150]]; // 150
        }else{
            [_stopwatchTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:400]]; // 150
        }
        
        [_stopwatchTitleLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:60]];
    }
}

- (void)setupLandscapeConstraintsForSafeAreaDevice {
    
    if (Utilities.deviceHasAreaInsets) {
        
        _heightStopwatchCircleTimerConstraint.constant = [UIScreen mainScreen].bounds.size.height * .82;
        _widthStopwatchCircleTimerConstraint.constant = [UIScreen mainScreen].bounds.size.width * .38;
        if (Utilities.deviceHasAreaInsets || IS_IPHONE_6P) {
        [_stopwatchTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:750]];
        }
    }else{
        if (!(IS_IPAD_PRO || IS_IPAD)) {
            _heightStopwatchCircleTimerConstraint.constant = [UIScreen mainScreen].bounds.size.height * .81;
            _widthStopwatchCircleTimerConstraint.constant = [UIScreen mainScreen].bounds.size.width * .45;
        }
    }
}

- (void)setupPortraitConstraintsForSafeAreaDevice {
    if ((Utilities.deviceHasAreaInsets || IS_IPHONE_6P) && [SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
        [_stopwatchTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:55]];
    }else{
        if (!(IS_IPAD_PRO || IS_IPAD)) {
            [_stopwatchTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:750]];
        }
    }
}




@end
