//
//  RoundsObject.m
//  TestTimer
//
//  Created by Andrei on 11/23/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "RoundsObject.h"

@implementation RoundsObject


- (instancetype)init
{
    self = [super init];
    if (self) {
        _roundsPickers = [NSMutableArray new];
        _roundsColors  = [NSMutableArray new];
        [_roundsPickers addObjectsFromArray: @[@timerPrepareRoundsValue,
                                                @timerWorkRoundsValue,
                                                @timerRestRoundsValue,
                                                @timerRoundsCountValue
                                            ]];
        
        
        [_roundsColors addObjectsFromArray: @[@timerYellowColor,
                                               @timerGreenColor,
                                               @timerRedColor,
                                               @timerBlueColor
                                               ]];
    }
    return self;
}


- (void)updateRoundsPickersValues {
    [_roundsPickers removeAllObjects];
    [_roundsPickers addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"intervalsRoundsArray"]];
    NSLog(@"_tabataPickers ==== %@",_roundsPickers);
}


- (void)updateRoundsColorsValues {
    [_roundsColors removeAllObjects];
    [_roundsColors addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"colorsRoundsArray"]];
}

- (void)setupRoundsTimer {
    
    
    _roundsPickers = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"intervalsRoundsArray"]];
    _roundsColors = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"colorsRoundsArray"]];
    
     if (![_roundsPickers isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"intervalsRoundsArray"]]) {
//         [_roundsPickers addObjectsFromArray: @[@timerPrepareRoundsValue,
//                                                 @timerWorkRoundsValue,
//                                                 @timerRestRoundsValue,
//                                                 @timerRoundsCountValue
//                                                 ]];
         [_roundsPickers addObjectsFromArray:@[[NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"dateFullSecPrepare"]],
                                               [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"fullValueSecRTVC"]],
                                               [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"fullValueRestTimeValue"]],
                                               [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"roundsValue"]]]
          ];
         [[NSUserDefaults standardUserDefaults] setObject:_roundsPickers forKey:@"intervalsRoundsArray"];
     }
     if (![_roundsColors isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"colorsRoundsArray"]]) {
         [_roundsColors addObjectsFromArray: @[@timerYellowColor,
                                                @timerGreenColor,
                                                @timerRedColor,
                                                @timerBlueColor
                                                ]];
     }
    
    _soundIndex = [[SettingsManagerImplementation sharedInstance]songNames];
    
    _roundsCircleViewValuesArray = [NSMutableArray array];
    _roundsLeft = _roundsPickers[RoundsIndexCountIndex].integerValue;
    
    NSInteger rounds = _roundsPickers[RoundsIndexCountIndex].integerValue;
    
    _valuesForTimer = [NSMutableArray array];
    NSDictionary *dictionary = [NSDictionary new];
    
    if (_roundsPickers[RoundsPrepareIndex].integerValue > 0) {
        [_valuesForTimer addObject:_roundsPickers[RoundsPrepareIndex]];
        dictionary = @{kRoundsCircleTypeKey: @(RoundsPrepare), kRoundsTimeValue:_roundsPickers[RoundsPrepareIndex]};
        [_roundsCircleViewValuesArray addObject:dictionary];
    }
    
    for (int i=0; i<rounds; i++) {
        
        NSInteger restTime = _roundsPickers[RoundsRestIndex].integerValue;
        
        //set work
        [_valuesForTimer addObject:_roundsPickers[RoundsWorkIndex]];
        dictionary = @{kRoundsCircleTypeKey: @(RoundsWork) , kRoundsTimeValue: _roundsPickers[RoundsWorkIndex]};
        [_roundsCircleViewValuesArray addObject:dictionary];
        
        if (i != rounds - 1){
            if (restTime>0) {
                [_valuesForTimer addObject:_roundsPickers[RoundsRestIndex]];
                dictionary = @{kRoundsCircleTypeKey: @(RoundsRest), kRoundsTimeValue:_roundsPickers[RoundsRestIndex]};
                [_roundsCircleViewValuesArray addObject:dictionary];
            }
        }
    }
    
//    NSNumber *sum = [_valuesForTimer valueForKeyPath:@"@integerValue"];
    _roundsTotalTime = (_roundsPickers[RoundsWorkIndex].integerValue + _roundsPickers[RoundsRestIndex].integerValue) * rounds - (rounds > 1 ? _roundsPickers[RoundsRestIndex].integerValue : 0);
    NSLog(@"===== %ld", _roundsTotalTime);
    NSLog(@"values timer array -----------> %@", _valuesForTimer);
    
    
}


@end
