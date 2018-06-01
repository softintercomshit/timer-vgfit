//
//  TabataObject.h
//  TestTimer
//
//  Created by Andrei on 11/8/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerObject.h"

static NSString *const kCircleTypeKey = @"TabataCircleType";
static NSString *const kTimeValue = @"timeValue";

@interface TabataObject : NSObject

@property (strong, nonatomic) NSMutableArray<NSNumber*> *tabataPickers;
@property (strong, nonatomic) NSMutableArray<NSNumber*> *tabataColors;
@property (strong, nonatomic) NSMutableArray <NSDictionary *> *tabataCircleViewValuesArray;
@property (strong, nonatomic) NSMutableArray<NSNumber*> *valuesForTimer;

@property (strong, nonatomic) NSMutableArray *valuesArray;
//@property(nonatomic) TabataCircleType tabataCircleType;
//@property(nonatomic) TimerObject* timerObj;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger roundsLeft;
@property (nonatomic, assign) NSInteger cyclesLeft;
@property (nonatomic, assign) NSInteger roundsTotalTime;
@property (nonatomic, assign) NSInteger cyclesTotalTime;

@property (nonatomic, assign) NSInteger soundIndex;

- (void)updateTabataPickersValues;
- (void)updateTabataColors;
- (void)setupTimer;



@end
