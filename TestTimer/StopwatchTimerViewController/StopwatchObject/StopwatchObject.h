//
//  StopwatchObject.h
//  TestTimer
//
//  Created by Andrei on 11/24/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerObject.h"

static NSString *const kStopwatchCircleTypeKey = @"StopwatchCircleType";
static NSString *const kStopwatchTimeValue = @"stopwatchTimeValue";


@interface StopwatchObject : NSObject


@property (strong, nonatomic) NSMutableArray<NSNumber*> *stopwatchPickers;
@property (strong, nonatomic) NSMutableArray <NSDictionary *> *stopwatchCircleViewValuesArray;
@property (strong, nonatomic) NSMutableArray<NSNumber*> *valuesForTimer;


@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) NSInteger soundIndex;

- (void)updateStopwatchPickersValues;

- (void)setupStopwatchTimer;


@end
