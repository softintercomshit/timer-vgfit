//
//  StopwatchObject.m
//  TestTimer
//
//  Created by Andrei on 11/24/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "StopwatchObject.h"

@implementation StopwatchObject



- (instancetype)init
{
    self = [super init];
    if (self) {
        _stopwatchPickers = [NSMutableArray new];
        [_stopwatchPickers addObjectsFromArray: @[@timerPrepareStopwatchValue,
                                                @timerTimeLapStopwatchValue
                                                ]];

    }
    return self;
}

- (void)updateStopwatchPickersValues {
    [_stopwatchPickers  removeAllObjects];
    [_stopwatchPickers addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"intervalsStopwatchArray"]];
    NSLog(@"_stopwatchPickers ==== %@",_stopwatchPickers);
}

- (void)setupStopwatchTimer {
   _stopwatchCircleViewValuesArray = [NSMutableArray array];
    
    _stopwatchPickers = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"intervalsStopwatchArray"]];
     if (![_stopwatchPickers isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"intervalsStopwatchArray"]]) {
         [_stopwatchPickers addObjectsFromArray:@[[NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"fullSecondsPrepareTime"]],
                                                  [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"fullSecondsTimeLapSoundTime"]]
                                                  ]
          ];
         [[NSUserDefaults standardUserDefaults] setObject:_stopwatchPickers forKey:@"intervalsStopwatchArray"];
     }
    _soundIndex = [[SettingsManagerImplementation sharedInstance]songNames];
    
    _valuesForTimer = [NSMutableArray array];
    NSDictionary *dict;
    if ( _stopwatchPickers[StopwatchPrepare].integerValue> 0) {
        [_valuesForTimer addObject:_stopwatchPickers[StopwatchPrepareIndex]];
        dict = @{kStopwatchCircleTypeKey:@(StopwatchPrepare), kStopwatchTimeValue:_stopwatchPickers[StopwatchPrepareIndex]};
        [_stopwatchCircleViewValuesArray addObject:dict];
    }
    else{
        [_valuesForTimer addObject:_stopwatchPickers[StopwatchTimeLapIndex]];
        dict = @{kStopwatchCircleTypeKey: @(StopwatchTimeLap) , kStopwatchTimeValue: [NSString stringWithFormat:@"00:00"]};
        [_stopwatchCircleViewValuesArray  addObject:dict];
    }
    
    [_valuesForTimer addObject:_stopwatchPickers[StopwatchTimeLapIndex]];
    dict = @{kStopwatchCircleTypeKey:@(StopwatchTimeLap), kStopwatchTimeValue:_stopwatchPickers[StopwatchTimeLapIndex]};
    [_stopwatchCircleViewValuesArray addObject:dict];
    
}

@end
