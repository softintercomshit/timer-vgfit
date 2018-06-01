

#import <Foundation/Foundation.h>



@class TimerObject;

@protocol TimerObjectDelegate <NSObject>

@optional
-(void)timer:(TimerObject *)timerObject totalTimeString:(NSString *)totalTimeString currentTimeString:(NSString *)currentTimeString iterationCompleted:(BOOL)iterationCompleted needToPlaySound:(BOOL)needToPlaySound;

-(void)timer:(TimerObject *)timerObject isPrepare:(BOOL)isPrepare lapCompleted:(BOOL)lapCompleted timeString:(NSString *)timeString;
-(void)timer:(TimerObject *)timerObject totalTime:(NSTimeInterval)totalTime currentTime:(NSTimeInterval)currentTime;
-(void)timer:(TimerObject *)timerObject lapTime:(NSTimeInterval)lapTime totalTime:(NSTimeInterval)totalTime isPrepare:(BOOL)isPrepare;

@end

@interface TimerObject : NSObject

//+(instancetype)new __unavailable;
//-(instancetype)init __unavailable;

-(TimerObject *)initWithCountDownTimerModeAndTimerFormat:(TimerFormats)timerFormat timerIntervalsArray:(NSArray<NSNumber *> *)timerIntervalsArray;
-(TimerObject *)initWithCountUpTimerModeAndTimerFormat:(TimerFormats)timerFormat prepareTime:(NSInteger)prepareTime lapTime:(NSInteger)lapTime;

@property(nonatomic) TimerFormats timerFormat;

@property (weak, nonatomic) id<TimerObjectDelegate> delegate;

@property (nonatomic) BOOL resetAfterEnding;

@property (nonatomic, assign) BOOL isRunning;

//@property (nonatomic, readonly) BOOL isRunning;

@property (nonatomic) NSTimeInterval stoppedInterval;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (strong, nonatomic) NSDate *fireTime;

-(void)updateTimer;

-(void)start;
-(void)playPause;
-(void)reset;
-(void)requestInitialValues;
-(void)requestCurrentValues;
-(void)requestCurrentStopwatchValues;
-(NSDate *) getFireTime;


@end
