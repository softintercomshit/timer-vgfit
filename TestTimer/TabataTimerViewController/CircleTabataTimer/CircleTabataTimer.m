//
//  CircleTabataTimer.m
//  TestTimer
//
//  Created by Andrei on 11/6/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "CircleTabataTimer.h"

@implementation CircleTabataTimer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setTabataCircleType:(TabataCircleType)tabataCircleType {
    
    if (IS_IPAD || IS_IPAD_PRO) {
        self.thickness = 20;
    }else{
        self.thickness = 11;
    }
    
    _tabataCircleType = tabataCircleType;
    self.activeColor = [AppColorManager sharedInstanceManager].arrayWithTabataCircleColors[tabataCircleType];
    self.pauseColor = [AppColorManager sharedInstanceManager].arrayWithTabataCircleColors[tabataCircleType];
    [_timeLabel setTextColor:[AppColorManager sharedInstanceManager].arrayWithTabataCircleColors[tabataCircleType]];
    [_titleLabel setTextColor:[AppColorManager sharedInstanceManager].arrayWithTabataCircleColors[tabataCircleType]];
    [_titleLabel setText:[self title]];
    [self setNeedsDisplay];
}

- (void)setSecondsValue:(NSNumber *)secondsValue {
   
    [_timeLabel setText:[self timeFormatString:secondsValue]];
//    [_titleLabel setText:[self title]];
}


- (NSString *)timeFormatString:(NSNumber *)timeInterval {
    NSInteger totalTimeMinutes = timeInterval.integerValue / 60;
    NSInteger totalTimeSeconds = timeInterval.integerValue  % 60;
    
    NSString *timeFormatString;
    
    switch ([SettingsManagerImplementation sharedInstance].timerFormat) {
        case MinSec:
            timeFormatString = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)totalTimeMinutes, (long)totalTimeSeconds];
            break;
        case MilisecondsOneDigit:
            timeFormatString = [NSString stringWithFormat:@"%.1ld:%.2ld.0", (long)totalTimeMinutes, (long)totalTimeSeconds];
            break;
        case MilisecondsTwoDigits:
            timeFormatString = [NSString stringWithFormat:@"%.2ld:%.2ld.00", (long)totalTimeMinutes, (long)totalTimeSeconds];
            break;
        default:
            timeFormatString = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)totalTimeMinutes, (long)totalTimeSeconds];
            break;
    }
    return timeFormatString;
}


- (NSString *)title {
    NSString *title;
    switch (_tabataCircleType) {
            case Prepare:
            title = @"Prepare".localized;
            break;
        case Work:
            title = @"Work".localized;
            break;
        case Rest:
            title = @"Rest".localized;
            break;
        case RestBetweenCycles:
            title = @"Rest BC".localized;
            break;
        default:
            title = @"Prepare".localized;
            break;
    }
    return title;
}


- (void)setNullValue {
    [_timeLabel setText:[self timeFormatString:@(0)]];
}


// Constraints method


- (void)setupLandscapeConstraints {
    if(IS_IPAD){
         _topTitleLabelConstraint.constant = 64;
        [_verticalSpacingTimeLabelConstraint setConstant:-80.5];
        _topTimeLabelConstraint.constant = 50;
        _centerHorizontalTimeLabelConstraint = [_centerHorizontalTimeLabelConstraint updatePriority:999];
        _bottomTimeLabelConstraint.constant = 230;
        _leadingTimeLabelConstraint.constant = 44;
        _trailingTimeLabelConstraint.constant = 44;
//        [_timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:150]]; // 150
        if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
            [_timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:110]]; // 150
        }else{
            [_timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:160]]; // 150
        }
    }
    else if (IS_IPAD_PRO) {
        _topTitleLabelConstraint.constant = 64;
        _topTimeLabelConstraint.constant = 50;
        _centerHorizontalTimeLabelConstraint = [_centerHorizontalTimeLabelConstraint updatePriority:999];
        _bottomTimeLabelConstraint.constant = 260;
        _leadingTimeLabelConstraint.constant = 44;
        _trailingTimeLabelConstraint.constant = 44;
        [_titleLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:75]];
        if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
             [_timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:150]]; // 150
        }else{
            [_timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:200]]; // 150
        }
       
        [_verticalSpacingTimeLabelConstraint setConstant:-150.5];
    }
  
    _equalHeightTimeLabelConstraint  = [_equalHeightTimeLabelConstraint updateMultiplier:1];
    _equalWidthTimeLabelConstraint = [_equalWidthTimeLabelConstraint updateMultiplier:1];
    _equalHeightTitleLabelConstraint = [_equalHeightTitleLabelConstraint updateMultiplier:1];
    _equalWidthTitleLabelConstraint = [_equalWidthTitleLabelConstraint updateMultiplier:1];
    
}


- (void)setupPortraitConstraints {
    
    if (IS_IPAD) {
        _topTitleLabelConstraint.constant = 134;
        _topTimeLabelConstraint.constant = 152;
        _centerHorizontalTimeLabelConstraint = [_centerHorizontalTimeLabelConstraint updatePriority:1000];
        _bottomTimeLabelConstraint.constant = 152.5;
        _leadingTimeLabelConstraint.constant = 3;
        _trailingTimeLabelConstraint.constant = 3;
        _equalHeightTimeLabelConstraint  = [_equalHeightTimeLabelConstraint updateMultiplier:0.3];
        _equalWidthTimeLabelConstraint = [_equalWidthTimeLabelConstraint updateMultiplier:0.4];
//         [_timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:150]]; // 150
        if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
            [_timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:110]]; // 150
        }else{
            [_timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:160]]; // 150
        }
        
    }else if(IS_IPAD_PRO){
        _topTitleLabelConstraint.constant = 134;
        _topTimeLabelConstraint.constant = 152;
        _centerHorizontalTimeLabelConstraint = [_centerHorizontalTimeLabelConstraint updatePriority:1000];
        _bottomTimeLabelConstraint.constant = 152.5;
        _leadingTimeLabelConstraint.constant = 15;
        _trailingTimeLabelConstraint.constant = 15;
        _equalHeightTimeLabelConstraint  = [_equalHeightTimeLabelConstraint updateMultiplier:0.3];
        _equalWidthTimeLabelConstraint = [_equalWidthTimeLabelConstraint updateMultiplier:0.4];
        if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
            [_timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:150]]; // 150
        }else{
            [_timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:400]]; // 150
        }
//        [_timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:400]]; // 150
        [_titleLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:60]];
        [_verticalSpacingTimeLabelConstraint setConstant:-50.5];
    }
}


- (void)setupLandscapeForSafeAreaConstraints {
    
    if (Utilities.deviceHasAreaInsets) {
        _heightCircleTimerConstraint.constant = [UIScreen mainScreen].bounds.size.height * .82;
        _widthCircleTimerConstraint.constant = [UIScreen mainScreen].bounds.size.width * .38;
        if (Utilities.deviceHasAreaInsets || IS_IPHONE_6P) {
               [_timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:750]];
        }
    }else{
        if (!(IS_IPAD_PRO || IS_IPAD)) {
            _heightCircleTimerConstraint.constant = [UIScreen mainScreen].bounds.size.height * .81;
            _widthCircleTimerConstraint.constant = [UIScreen mainScreen].bounds.size.width * .45;
        }
    }
}


- (void)setupPortraitForSafeAreaConstraints {
    if ((Utilities.deviceHasAreaInsets || IS_IPHONE_6P) && [SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
        [_timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:55]];
    }else {
        if (!(IS_IPAD_PRO || IS_IPAD)) {
               [_timeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:750]];
        }
    }
}






@end
