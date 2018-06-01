//
//  RoundsObject.h
//  TestTimer
//
//  Created by Andrei on 11/23/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerObject.h"

static NSString *const kRoundsCircleTypeKey = @"RoundsCircleType";
static NSString *const kRoundsTimeValue = @"roundsTimeValue";


@interface RoundsObject : NSObject

@property (strong, nonatomic) NSMutableArray<NSNumber*> *roundsPickers;
@property (strong, nonatomic) NSMutableArray<NSNumber*> *roundsColors;
@property (strong, nonatomic) NSMutableArray <NSDictionary *> *roundsCircleViewValuesArray;
@property (strong, nonatomic) NSMutableArray<NSNumber*> *valuesForTimer;


@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger roundsLeft;
@property (nonatomic, assign) NSInteger roundsTotalTime;


@property (nonatomic, assign) NSInteger soundIndex;

- (void)updateRoundsPickersValues;
- (void)updateRoundsColorsValues;
- (void)setupRoundsTimer;


@end
