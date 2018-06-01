//
//  CircleRoundsTimer.m
//  TestTimer
//
//  Created by Andrei on 11/6/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "CircleRoundsTimer.h"

@implementation CircleRoundsTimer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setRoundsCircleType:(RoundsCircleType)roundsCircleType {
    if (IS_IPAD || IS_IPAD_PRO) {
        self.thickness = 20;
    }else{
        self.thickness = 11;
    }
    _roundsCircleType = roundsCircleType;
    self.activeColor = [AppColorManager sharedInstanceManager].arrayWithRoundsCircleColors[roundsCircleType];
    self.pauseColor = [AppColorManager sharedInstanceManager].arrayWithRoundsCircleColors[roundsCircleType];
    [_roundsTimeLabel setTextColor:[AppColorManager sharedInstanceManager].arrayWithRoundsCircleColors[roundsCircleType]];
    [_roundsTitleLabel setTextColor:[AppColorManager sharedInstanceManager].arrayWithRoundsCircleColors[roundsCircleType]];
    [_roundsTitleLabel setText:[self roundsTitle]];
    [self setNeedsDisplay];
}


- (void)setRoundsSecondsValue:(NSNumber *)roundsSecondsValue {
    [_roundsTimeLabel setText:[Utilities timeFormatString:roundsSecondsValue]];
}


- (NSString *)roundsTitle {
    NSString *roundsTitle;
    switch (_roundsCircleType) {
        case RoundsPrepare:
            roundsTitle = @"Prepare".localized;
            break;
        case RoundsWork:
            roundsTitle = @"Work".localized;
            break;
        case RoundsRest:
            roundsTitle = @"Rest".localized;
            break;
        default:
            roundsTitle = @"Prepare".localized;
            break;
    }
    return roundsTitle;
}


- (void)setNullValue {
    [_roundsTimeLabel setText:[Utilities timeFormatString:@(0)]];
}


- (void)setupLandscapeConstraints {
    if(IS_IPAD){
        _topRoundsTitleLabelConstraint.constant = 64;
        [_verticalSpacingRoundsTimeLabelConstraint setConstant:-80.5];
        _topRoundsTimeLabelConstraint.constant = 50;
        _centerHorizontalRoundsTimeLabelConstraint = [_centerHorizontalRoundsTimeLabelConstraint updatePriority:999];
        _bottomRoundsTimeLabelConstraint.constant = 230;
        _leadingRoundsTimeLabelConstraint.constant = 44;
        _trailingRoundsTimeLabelConstraint.constant = 44;
        if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
            [_roundsTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:110]]; // 150
        }else{
            [_roundsTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:160]]; // 150
        }
    }
    else if (IS_IPAD_PRO) {
        _topRoundsTitleLabelConstraint.constant = 64;
        _topRoundsTimeLabelConstraint.constant = 50;
        _centerHorizontalRoundsTimeLabelConstraint = [_centerHorizontalRoundsTimeLabelConstraint updatePriority:999];
        _bottomRoundsTimeLabelConstraint.constant = 260;
        _leadingRoundsTimeLabelConstraint.constant = 44;
        _trailingRoundsTimeLabelConstraint.constant = 44;
        
        [_roundsTitleLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:75]];
        if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
            [_roundsTimeLabel  setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:150]]; // 150
        }else{
            [_roundsTimeLabel  setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:200]]; // 150
        }
//        [_roundsTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:150]];
        [_verticalSpacingRoundsTimeLabelConstraint setConstant:-150.5];
    }
    
    _equalHeightRoundsTimeLabelConstraint  = [_equalHeightRoundsTimeLabelConstraint updateMultiplier:1];
    _equalWidthRoundsTimeLabelConstraint = [_equalWidthRoundsTimeLabelConstraint updateMultiplier:1];
    _equalHeightRoundsTitleLabelConstraint = [_equalHeightRoundsTitleLabelConstraint updateMultiplier:1];
    _equalWidthRoundsTitleLabelConstraint = [_equalWidthRoundsTitleLabelConstraint updateMultiplier:1];
}


- (void)setupPortraitConstraints {
    
    if (IS_IPAD) {
        _topRoundsTitleLabelConstraint.constant = 134;
        _topRoundsTimeLabelConstraint.constant = 152;
        _centerHorizontalRoundsTimeLabelConstraint = [_centerHorizontalRoundsTimeLabelConstraint updatePriority:1000];
        _bottomRoundsTimeLabelConstraint.constant = 152.5;
        _leadingRoundsTimeLabelConstraint.constant = 3;
        _trailingRoundsTimeLabelConstraint.constant = 3;
        _equalHeightRoundsTimeLabelConstraint  = [_equalHeightRoundsTimeLabelConstraint updateMultiplier:0.3];
        _equalWidthRoundsTimeLabelConstraint = [_equalWidthRoundsTimeLabelConstraint updateMultiplier:0.4];
//        [_roundsTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:150]]; // 150
        if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
            [_roundsTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:110]]; // 150
        }else{
            [_roundsTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:160]]; // 150
        }
        
    }else if(IS_IPAD_PRO){
        _topRoundsTitleLabelConstraint.constant = 134;
        _topRoundsTimeLabelConstraint.constant = 152;
        _centerHorizontalRoundsTimeLabelConstraint = [_centerHorizontalRoundsTimeLabelConstraint updatePriority:1000];
        _bottomRoundsTimeLabelConstraint.constant = 152.5;
        _leadingRoundsTimeLabelConstraint.constant = 15;
        _trailingRoundsTimeLabelConstraint.constant = 15;
        _equalHeightRoundsTimeLabelConstraint  = [_equalHeightRoundsTimeLabelConstraint updateMultiplier:0.3];
        _equalWidthRoundsTimeLabelConstraint = [_equalWidthRoundsTimeLabelConstraint updateMultiplier:0.4];
        if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
            [_roundsTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:150]]; // 150
        }else{
            [_roundsTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:400]]; // 150
        }
        
        [_roundsTitleLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:60]];
        [_verticalSpacingRoundsTimeLabelConstraint setConstant:-50.5];
    }
}


- (void)setupLandscapeConstraintsForSafeArea{
    
    if (Utilities.deviceHasAreaInsets) {
        
        _heightRoundsCircleTimerConstraint.constant = [UIScreen mainScreen].bounds.size.height * .82;
        _widthRoundsCircleTimerConstraint.constant = [UIScreen mainScreen].bounds.size.width * .38;
        if (Utilities.deviceHasAreaInsets || IS_IPHONE_6P) {
        [_roundsTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:750]];
        }
    }else{
        if (!(IS_IPAD_PRO || IS_IPAD)) {
            _heightRoundsCircleTimerConstraint.constant = [UIScreen mainScreen].bounds.size.height * .81;
            _widthRoundsCircleTimerConstraint.constant = [UIScreen mainScreen].bounds.size.width * .45;
        }
    }
}


- (void)setupPortraitConstraintsForSafeArea {
    if ((Utilities.deviceHasAreaInsets || IS_IPHONE_6P) && [SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
        [_roundsTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:55]];
    }else{
        if (!(IS_IPAD_PRO || IS_IPAD)) {
            [_roundsTimeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:750]];
        }
    }
}





@end
