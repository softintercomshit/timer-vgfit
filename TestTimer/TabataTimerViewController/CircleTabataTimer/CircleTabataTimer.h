//
//  CircleTabataTimer.h
//  TestTimer
//
//  Created by Andrei on 11/6/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "CircleTimer.h"

@interface CircleTabataTimer : CircleTimer


@property(nonatomic) TabataCircleType tabataCircleType;
@property(weak, nonatomic) NSNumber *secondsValue;
@property(nonatomic) TimerFormats timerFormat;

@property (weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topTitleLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint
*centerHorizontalTimeLabelConstraint;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadingTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *trailingTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *equalHeightTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *equalWidthTimeLabelConstraint;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *equalHeightTitleLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *equalWidthTitleLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacingTimeLabelConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightCircleTimerConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthCircleTimerConstraint;

- (void)setNullValue;
- (NSString*)title;

- (void)setupLandscapeConstraints;
- (void)setupPortraitConstraints;
- (void)setupPortraitForSafeAreaConstraints;

- (void)setupLandscapeForSafeAreaConstraints;



@end
