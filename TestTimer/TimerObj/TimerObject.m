//
//  TimerObject.m
//  TimerBackEnd
//
//  Created by user on 2/27/17.
//  Copyright © 2017 user. All rights reserved.
//
#import "TimerObject.h"
//#import "SettingsManagerImplementation.h"

typedef NS_ENUM(NSInteger,TimerMode){
    CountDown,
    CountUp
};

static NSInteger const kTotalTimeIndex = 0;
static NSInteger const kCurrentTimeIndex = 1;

@implementation TimerObject{
    TimerMode _timerMode;
    NSArray<NSNumber *> *_timerIntervalsArray;
    NSTimer *timer;
    NSTimeInterval totalTimerInterval, timerFormatIntervalValue, _prepareTime, needToPlaySoundLastValue;
    NSInteger currentArrayIndex, _lapTime, lastLapTimeValue;
    BOOL iterationCompleted, isPrepareTime;
//    NSDate *fireTime;
    NSString *totalTimeFormatString;
    NSString *currentTimeFormatString;
    NSTimeInterval initTimeInterval;
    NSInteger currentTimerInterval;
}

@synthesize isRunning;

#pragma mark - custom init

-(TimerObject *)initWithCountDownTimerModeAndTimerFormat:(TimerFormats)timerFormat timerIntervalsArray:(NSArray<NSNumber *> *)timerIntervalsArray{
    _timerIntervalsArray = timerIntervalsArray;
    _timerMode = CountDown;
    _timerFormat = timerFormat;
    timerFormatIntervalValue = [self timerFormatIntervalValue:timerFormat];
    
    if (timerIntervalsArray.count > 0) {
        NSNumber *sumNumbersFromArray = [timerIntervalsArray valueForKeyPath:@"@sum.self"];
        totalTimerInterval = sumNumbersFromArray.doubleValue;
    }
    
    return self;
}

-(TimerObject *)initWithCountUpTimerModeAndTimerFormat:(TimerFormats)timerFormat prepareTime:(NSInteger)prepareTime lapTime:(NSInteger)lapTime{
    _lapTime = lapTime;
    _prepareTime = prepareTime;
    _timerMode = CountUp;
    _timerFormat = timerFormat;
    timerFormatIntervalValue = [self timerFormatIntervalValue:timerFormat];
    return self;
}

#pragma mark public methods

-(void)start{
    timer = [NSTimer scheduledTimerWithTimeInterval:timerFormatIntervalValue target:self selector:@selector(updateTimer) userInfo:nil repeats:true];
    [timer fire];
    _fireTime = [NSDate date];
    isRunning = true;
}

-(void)playPause{
    if (isRunning) {
        [timer invalidate];
        _stoppedInterval += [[NSDate date] timeIntervalSinceDate:_fireTime];
        isRunning = false;
    }else{
        timer = [NSTimer scheduledTimerWithTimeInterval:timerFormatIntervalValue target:self selector:@selector(updateTimer) userInfo:nil repeats:true];
        _fireTime = [NSDate date];
        [timer fire];
        isRunning = true;
    }
}

-(void)reset{
    [self resetWithCallback:true];
}

-(void)requestInitialValues{
    NSTimeInterval initialTimerInterval = 0;
    if (_prepareTime > 0) {
        initialTimerInterval = _prepareTime;
    }
    initTimeInterval =  initialTimerInterval;
    [self sendCallbackDelegate:initialTimerInterval];
}

-(void)requestCurrentValues{
    
    [SettingsManagerImplementation sharedInstance].timerFormat == MinSec ?  [self sendCallbackDelegate:_stoppedInterval]:[self sendCallbackDelegate:_stoppedInterval + 0.99];
    
//    _timerFormat == MinSec ? [self sendCallbackDelegate:stoppedInterval]:[self sendCallbackDelegate:stoppedInterval + 0.99];
    
//    NSLog(@"current values::::::::::   %f", stoppedInterval +0.99);
    
}

-(void)requestCurrentStopwatchValues
{
    
    [self sendCallbackDelegate:_stoppedInterval - _prepareTime];
    NSLog(@"current stopwatch values  %f", _stoppedInterval + 0.99 - _prepareTime);
}

-(void)setTimerFormat:(TimerFormats)timerFormat{
    _timerFormat = timerFormat;
    timerFormatIntervalValue = [self timerFormatIntervalValue:timerFormat];
}

#pragma mark private methods

- (void)resetWithCallback:(BOOL)callback{
    [timer invalidate];
    _fireTime = nil;
    _stoppedInterval = 0;
    
    isRunning = false;
    if (_timerMode == CountDown) {
        currentArrayIndex = 0;
    }
    lastLapTimeValue = 0;
    if (callback) {
        [self requestInitialValues];
    }
}

- (void)updateTimer{
   _elapsedTime = [[NSDate date] timeIntervalSinceDate:_fireTime] + _stoppedInterval;
    
    if (_timerMode == CountDown) {
        if (_elapsedTime >= totalTimerInterval) {
            iterationCompleted = true;
            [timer invalidate];
            isRunning = false;
            if (_resetAfterEnding) {
                [self resetWithCallback:false];
                [self start];
            }else{
                currentArrayIndex = 0;
                [self requestInitialValues];
                return;
            }
        }
        
        // set new value of current time interval
        if (_elapsedTime >= [self currentTimerInterval]) {
            iterationCompleted = true;
            currentArrayIndex++;
        }else{
            iterationCompleted = false;
        }
        [SettingsManagerImplementation sharedInstance].timerFormat == MinSec ?  [self sendCallbackDelegate:_elapsedTime]:[self sendCallbackDelegate:_elapsedTime+1];
//        _timerFormat == MinSec ? [self sendCallbackDelegate:elapsedTime]:[self sendCallbackDelegate:elapsedTime+1];
        
        //        [self sendCallbackDelegate:elapsedTime];
    }else{
        if (_prepareTime > 0) {
            NSTimeInterval remainingPrepareTime = _elapsedTime -_prepareTime;//2-27
            if (remainingPrepareTime <= 0) {
                isPrepareTime = true;
            }else{
                isPrepareTime = false;
            }
            [self sendCallbackDelegate:remainingPrepareTime];
        }else{
            [self sendCallbackDelegate:_elapsedTime];
        }
    }
}

- (void)sendCallbackDelegate:(NSTimeInterval)elapsedTime{
    
    if (_timerMode == CountUp) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(timer:isPrepare:lapCompleted:timeString:)]) {
            NSArray<NSString*> *timeFormatArray = [self timeFormatArray:elapsedTime];
            if (_lapTime > 0) {
                BOOL lapCompleted = false;
                if (lastLapTimeValue + _lapTime == (NSInteger)elapsedTime && !isPrepareTime) {
                    lastLapTimeValue = elapsedTime;
                    lapCompleted = true;
                }
                [self.delegate timer:self isPrepare:isPrepareTime lapCompleted:lapCompleted timeString:timeFormatArray[kTotalTimeIndex]];
                if (!isPrepareTime) {
                    [self.delegate timer:self lapTime:fabs(elapsedTime-lastLapTimeValue) totalTime:_lapTime isPrepare:isPrepareTime];
                }else{
                    [self.delegate timer:self lapTime:fabs(elapsedTime) totalTime:_prepareTime isPrepare:isPrepareTime];
                }
                
            }else{
                
                [self.delegate timer:self isPrepare:true lapCompleted:false timeString:timeFormatArray[kTotalTimeIndex]];
                
            }
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(timer:totalTimeString:currentTimeString:iterationCompleted:needToPlaySound:)]) {
            NSArray<NSString*> *timeFormatArray = [self timeFormatArray:elapsedTime];
            
            BOOL needToPlaySound = false;
            
            if([SettingsManagerImplementation sharedInstance].timerFormat==MinSec) {
//            if (_timerFormat == MinSec) {
            
                currentTimerInterval = [self currentTimerInterval] - elapsedTime;
            }else{
                
                currentTimerInterval = [self currentTimerInterval] - elapsedTime + 1;
            }
//            NSLog(@"current time interval:  %f", [self currentTimerInterval] - elapsedTime + 1);
       
            
            BOOL condition1 = (NSUInteger)currentTimerInterval-2 == 0;
            BOOL condition2 = (NSUInteger)currentTimerInterval-1 == 0;
            BOOL condition3 = (NSUInteger)currentTimerInterval == 0;

            if ((condition1 || condition2 || condition3) && needToPlaySoundLastValue != currentTimerInterval && isRunning == true) {
                needToPlaySoundLastValue = currentTimerInterval;
                needToPlaySound = true;
            }
            
            [self.delegate timer:self
                 totalTimeString:timeFormatArray[kTotalTimeIndex]
               currentTimeString:timeFormatArray[kCurrentTimeIndex]
              iterationCompleted:iterationCompleted
                 needToPlaySound:needToPlaySound];
            
            double totCurentMinSeconds = fabs(elapsedTime - [self currentTimerInterval]);
            double totCurentMiliseconds = fabs(elapsedTime - 1 - [self currentTimerInterval]);
            
            
            double currentProgressMiliseconds = fabs(_timerIntervalsArray[currentArrayIndex].doubleValue - totCurentMiliseconds);
            double currentProgressMinSec = fabs(_timerIntervalsArray[currentArrayIndex].doubleValue - totCurentMinSeconds);
            
//            [self.delegate timer:self totalTime:_timerIntervalsArray[currentArrayIndex].doubleValue currentTime:_timerFormat == MinSec ? currentProgressMinSec : currentProgressMiliseconds];
            [self.delegate timer:self totalTime:_timerIntervalsArray[currentArrayIndex].doubleValue currentTime: [SettingsManagerImplementation sharedInstance].timerFormat == MinSec ? currentProgressMinSec : currentProgressMiliseconds];
        }
    }
}

- (NSTimeInterval)currentTimerInterval{
    NSMutableArray *tmpIntervalsArray = _timerIntervalsArray.mutableCopy;
//    NSLog(@"mutable array %@",tmpIntervalsArray);
    [tmpIntervalsArray removeObjectsInRange:NSMakeRange(currentArrayIndex+1, _timerIntervalsArray.count-currentArrayIndex-1)];
//    NSLog(@"mutable array after modifications %@",tmpIntervalsArray);
    double currentTimerIntervals = [[tmpIntervalsArray valueForKeyPath:@"@sum.self"] doubleValue];
//    NSLog(@"current timer intervals %f",currentTimerIntervals);
    return currentTimerIntervals;
}

-(float)timerFormatIntervalValue:(TimerFormats)timerFormat{
    //    switch (timerFormat) {
    //        case MinSec:
    //            return 1;
    //        case MilisecondsOneDigit:
    //            return 1.f/10;
    //        case MilisecondsTwoDigits:
    //            return 1.f/100;
    //        default:
    //            return 1;
    //    }
    return 0.001;
}

-(NSArray<NSString*> *)timeFormatArray:(NSTimeInterval)timerInterval{
    //    return @[@"", @""];
    
    NSInteger totalTimeMinutes = labs((NSInteger)(totalTimerInterval + 1 - timerInterval)/60);
    
    NSInteger totalTimeSeconds = 0;
    if (totalTimeSeconds>59) {
        totalTimeSeconds = labs((NSInteger)(totalTimerInterval - 1 -(NSInteger)timerInterval) % 60);
    }
    else{
        totalTimeSeconds = labs((NSInteger)(totalTimerInterval - (NSInteger)timerInterval) % 60);
    }
    
    NSInteger currentTimeMinutes = labs(((NSInteger)[self currentTimerInterval] - (NSInteger)timerInterval)/60);
    NSInteger currentTimeSeconds = labs(((NSInteger)[self currentTimerInterval] - (NSInteger)timerInterval) % 60);
    //    NSLog(@"current time seconds ---------> %f",currentTimeSeconds);
    
    float miliseconds = fabs((timerInterval - (NSInteger)timerInterval) * ([SettingsManagerImplementation sharedInstance].timerFormat==MilisecondsOneDigit ? 10 : 100));
//    float miliseconds = fabs(timerInterval - (NSInteger)timerInterval) * (_timerFormat == MilisecondsOneDigit ? 10 : 100);
    
    if (_timerMode == CountDown && miliseconds > 0) {
        miliseconds = ([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsOneDigit ? 9 : 99) - miliseconds;
//        miliseconds = (_timerFormat == MilisecondsOneDigit ? 9 : 99) - miliseconds;
//        NSLog(@" miliseconds --------> %f",milliseconds);
    }
    
    
    
    switch ([SettingsManagerImplementation sharedInstance].timerFormat) {
//    switch(_timerFormat){
        case MinSec:
            totalTimeFormatString = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)totalTimeMinutes, (long)totalTimeSeconds];
            currentTimeFormatString = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)currentTimeMinutes, (long)currentTimeSeconds];
            break;
        case MilisecondsOneDigit:
            totalTimeFormatString = [NSString stringWithFormat:@"%.1ld:%.2ld.%.1ld", (long)totalTimeMinutes, (long)totalTimeSeconds,(long)miliseconds];
            currentTimeFormatString = [NSString stringWithFormat:@"%.1ld:%.2ld.%.1ld", (long)currentTimeMinutes, (long)currentTimeSeconds,(long)miliseconds];
            break;
        case MilisecondsTwoDigits:
            totalTimeFormatString = [NSString stringWithFormat:@"%.2ld:%.2ld.%.2ld", (long)totalTimeMinutes, (long)totalTimeSeconds,(long)miliseconds];
            currentTimeFormatString = [NSString stringWithFormat:@"%.2ld:%.2ld.%.2ld", (long)currentTimeMinutes, (long)currentTimeSeconds,(long)miliseconds];
            break;
        default:
            totalTimeFormatString = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)totalTimeMinutes, (long)totalTimeSeconds];
            currentTimeFormatString = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)currentTimeMinutes, (long)currentTimeSeconds];
            break;
    }
    
    //    NSLog(@"))))))))))))))))))))))) total time time interval %ld: %ld",(long)totalTimeMinutes,(long)totalTimeSeconds);
    
    return @[totalTimeFormatString, currentTimeFormatString];
}

-(NSDate *) getFireTime {
    return _fireTime;
}

@end
