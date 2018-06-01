//
//  CircleStopwatchTimer.h
//  TestTimer
//
//  Created by Andrei on 11/6/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "CircleTimer.h"

@interface CircleStopwatchTimer : CircleTimer

@property(nonatomic) StopwatchCircleType stopwatchCircleType;
@property (weak, nonatomic) NSNumber *stopwatchSecondsValue;
@property(nonatomic) TimerFormats timerFormat;

@property (weak, nonatomic) IBOutlet UILabel *stopwatchTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopwatchTimeLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topStopwatchTitleLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint
*centerHorizontalStopwatchTimeLabelConstraint;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadingStopwatchTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *trailingStopwatchTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topStopwatchTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomStopwatchTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *equalHeightStopwatchTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *equalWidthStopwatchTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *equalHeightStopwatchTitleLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *equalWidthStopwatchTitleLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacingStopwatchTimeLabelConstraint;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightStopwatchCircleTimerConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthStopwatchCircleTimerConstraint;



- (void)setNullValue;
- (NSString*)stopwatchTitle;

- (void)setupLandscapeConstraints;
- (void)setupPortraitConstraints;

- (void)setupLandscapeConstraintsForSafeAreaDevice;
- (void)setupPortraitConstraintsForSafeAreaDevice;


@end
