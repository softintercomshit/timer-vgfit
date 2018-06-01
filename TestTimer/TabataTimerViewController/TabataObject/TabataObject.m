//
//  TabataObject.m
//  TestTimer
//
//  Created by Andrei on 11/8/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "TabataObject.h"
#import "TabataIntervalsViewController.h"

@implementation TabataObject


- (instancetype)init
{
    self = [super init];
    if (self) {
        _tabataPickers = [NSMutableArray new];
        _tabataColors  = [NSMutableArray new];
        [_tabataPickers addObjectsFromArray: @[@timerPrepareTabataValue,
                                                @timerWorkTabataValue,
                                                @timerRestTabataValue,
                                                @timerRoundsTabataValue,
                                                @timerCyclesTabataValue,
                                                @timerRestBetweenCyclesTabataValue]];
        
        
        [_tabataColors addObjectsFromArray: @[@timerYellowColor,
                                               @timerGreenColor,
                                               @timerRedColor,
                                               @timerBlueColor,
                                               @timerTurquoiseColor,
                                               @timerYellowColor
                                               ]];
    }
    return self;
}


- (void)updateTabataPickersValues {
    
    [_tabataPickers removeAllObjects];
    [_tabataPickers addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"intervalsTabataArray"]];
    NSLog(@"_tabataPickers ==== %@",_tabataPickers);
}
//
- (void)updateTabataColors {

    [_tabataColors removeAllObjects];

    [_tabataColors addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"colorsTabataArray"]];
     NSLog(@"_tabataColor ======== %@", _tabataColors);
}

- (void)setupTimer {
    
    _tabataCircleViewValuesArray = [NSMutableArray array];
    
    _tabataPickers = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"intervalsTabataArray"]];
    _tabataColors = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"colorsTabataArray"]];

    if (![_tabataPickers isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"intervalsTabataArray"]]) {
//        [_tabataPickers addObjectsFromArray: @[@timerPrepareTabataValue,
//                                                @timerWorkTabataValue,
//                                                @timerRestTabataValue,
//                                                @timerRoundsTabataValue,
//                                                @timerCyclesTabataValue,
//                                                @timerRestBetweenCyclesTabataValue]];
        [_tabataPickers addObjectsFromArray:@[[NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"fullSecPrepare"]],
                                              [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"selectedSecondsFullValue"]],
                                              [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"fullValueSecRV"]],
                                              [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"fullRoundsValue"]],
                                              [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"fullCyclesValue"]],
                                              [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"fullValueSecRestBetweenCycles"]]
                                              ]];
        [[NSUserDefaults standardUserDefaults] setObject:_tabataPickers forKey:@"intervalsTabataArray"];
    }
    NSLog(@"tabata value: %@",_tabataPickers);
    
     if (![_tabataColors isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"colorsTabataArray"]]) {
         [_tabataColors addObjectsFromArray: @[@timerYellowColor,
                                                @timerGreenColor,
                                                @timerRedColor,
                                                @timerBlueColor,
                                                @timerTurquoiseColor,
                                                @timerYellowColor
                                                ]];
     }
  
    _soundIndex = [[SettingsManagerImplementation sharedInstance]songNames];
    
    NSLog(@"_tabataPickers ======== %@", _tabataPickers);
//    NSLog(@"_tabataColor ======== %@", _tabataColors);
    _roundsLeft = _tabataPickers[RoundsIndex].integerValue;
    _cyclesLeft = _tabataPickers[CyrclesIndex].integerValue;
    
    NSInteger rounds = _tabataPickers[RoundsIndex].integerValue;
    NSInteger cycles = _tabataPickers[CyrclesIndex].integerValue;
    
    _valuesForTimer = [NSMutableArray array];
    NSDictionary *dictionary;
    
    if (_tabataPickers[PrepareIndex].integerValue > 0) {
        [_valuesForTimer addObject:_tabataPickers[PrepareIndex]];
        dictionary = @{kCircleTypeKey: @(Prepare), kTimeValue:_tabataPickers[PrepareIndex]};
        [_tabataCircleViewValuesArray addObject:dictionary];
    }
    
    for (int i=0; i < cycles; i++) {
        for (int y = 0 ; y < rounds; y++) {
            NSInteger restBetweenCyrclesTime = _tabataPickers[RestBetweenCyrclesIndex].integerValue;
            NSInteger restTime = _tabataPickers[RestIndex].integerValue;
            
            // work
            [_valuesForTimer addObject:_tabataPickers[WorkIndex]];
            dictionary = @{kCircleTypeKey: @(Work), kTimeValue: _tabataPickers[WorkIndex]};
            [_tabataCircleViewValuesArray addObject:dictionary];
            
            if (y==rounds-1) {
                if (i != cycles-1) {
                    if (restBetweenCyrclesTime > 0) {
                        
                        // rest between cyrcles
                        [_valuesForTimer addObject:_tabataPickers[RestBetweenCyrclesIndex]];
 
                        dictionary = @{kCircleTypeKey: @(RestBetweenCycles), kTimeValue: _tabataPickers[RestBetweenCyrclesIndex]};
                        [_tabataCircleViewValuesArray addObject:dictionary];
                        
                    }else if(restTime > 0){
                        
                        // rest
                        [_valuesForTimer addObject:_tabataPickers[RestIndex]];
                        dictionary = @{kCircleTypeKey: @(Rest), kTimeValue: _tabataPickers[Rest]};
                        [_tabataCircleViewValuesArray addObject:dictionary];
                        
                    }
                }
                break;
            }else{
                if (restTime > 0) {
                    
                    // rest
                    [_valuesForTimer addObject:_tabataPickers[RestIndex]];
                    dictionary = @{kCircleTypeKey: @(Rest), kTimeValue: _tabataPickers[Rest]};
                    [_tabataCircleViewValuesArray addObject:dictionary];
                    
                }
            }
        }
       
    }
    
    NSNumber *sum = [_valuesForTimer valueForKeyPath:@"@sum.integerValue"];
    _cyclesTotalTime = sum.integerValue - _tabataPickers[PrepareIndex].integerValue;
    
    _roundsTotalTime = (_tabataPickers[WorkIndex].integerValue + _tabataPickers[RestIndex].integerValue) * rounds - (( cycles > 1 && _tabataPickers[RestBetweenCyrclesIndex].integerValue > 0) ? _tabataPickers[RestIndex].integerValue : 0 );
    NSLog(@"======%ld",_roundsTotalTime);
    
    NSLog(@"--------->%ld",_cyclesTotalTime);
    NSLog(@"///////////////// %@", _valuesForTimer);
//    NSLog(@"Rounds timer total time == %ld", (_tabataPickers[WorkIndex].integerValue + _tabataPickers[RestIndex].integerValue) * rounds - (( cycles > 1 ) ? _tabataPickers[RestIndex].integerValue : 0 ));
   
//    NSLog(@"Cycles timer total time == %ld",sum.integerValue - _tabataPickers[PrepareIndex].integerValue);
//    NSLog(@"arrray print -------------> %@",_valuesForTimer);
    
}




@end
