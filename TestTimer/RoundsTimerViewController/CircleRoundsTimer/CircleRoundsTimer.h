//
//  CircleRoundsTimer.h
//  TestTimer
//
//  Created by Andrei on 11/6/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleTimer.h"

@interface CircleRoundsTimer : CircleTimer

@property(nonatomic) RoundsCircleType roundsCircleType;
@property (weak, nonatomic) NSNumber *roundsSecondsValue;
@property(nonatomic) TimerFormats timerFormat;

@property (weak, nonatomic) IBOutlet UILabel *roundsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundsTimeLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topRoundsTitleLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint
*centerHorizontalRoundsTimeLabelConstraint;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadingRoundsTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *trailingRoundsTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topRoundsTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomRoundsTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *equalHeightRoundsTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *equalWidthRoundsTimeLabelConstraint;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *equalHeightRoundsTitleLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *equalWidthRoundsTitleLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacingRoundsTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightRoundsCircleTimerConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthRoundsCircleTimerConstraint;

- (void)setNullValue;
- (NSString*)roundsTitle;

- (void)setupLandscapeConstraints;
- (void)setupPortraitConstraints;

- (void)setupLandscapeConstraintsForSafeArea;
- (void)setupPortraitConstraintsForSafeArea;

@end
