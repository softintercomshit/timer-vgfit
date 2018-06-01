#import "AppleWatchClassesHandlers.h"

@implementation AppleWatchClassesHandlers


+ (NSDictionary *)getTabataWorkoutInfo:(NSArray*)workoutSets {
    NSMutableArray *arrayWithWorkoutInfo = [NSMutableArray new];
    NSMutableArray *arrayWithWorkouttitle = [NSMutableArray new];
    
    for (int i=0; i < workoutSets.count; i++) {
        NSDictionary *dict = [self getTabataWorkoutValues:workoutSets[i]];
        NSString *title = dict[@"title"];
        NSArray *workoutArrayContent = dict[@"content"];
        
        [arrayWithWorkouttitle addObject:title];
        [arrayWithWorkoutInfo addObject:workoutArrayContent];
    }
    
    return @{@"titles": arrayWithWorkouttitle,@"content": arrayWithWorkoutInfo};
}


+ (NSDictionary*)getTabataWorkoutValues:(TabatasWorkouts*)workout {
    
    NSArray *workoutArrayContent = @[workout.prepareTime,
                                     workout.workTime,
                                     workout.restTime,
                                     workout.roundsTabata,
                                     workout.cyclesTabata,
                                     workout.restBetweenCyclesTime
                                     ];
    
    NSString *roundsTitle = workout.workoutName;
    
    return @{@"title": roundsTitle,@"content": workoutArrayContent};
}


+ (NSDictionary *)getRoundsWorkoutInfo:(NSArray *)workoutSets {
    NSMutableArray *arrayWithRoundsWorkoutInfo = [NSMutableArray new];
    NSMutableArray *arrayWithRoundsWorkoutTitle = [NSMutableArray new];
    
    for (int i=0; i<[workoutSets count]; i++) {
        NSDictionary *dict = [self getRoundsWorkoutValues:workoutSets[i]];
        NSString *roundsTitle = dict[@"roundsTitle"];
        NSArray *roundsWorkoutArrayContent = dict[@"roundsContent"];
        
        [arrayWithRoundsWorkoutInfo addObject:roundsWorkoutArrayContent];
        [arrayWithRoundsWorkoutTitle addObject:roundsTitle];
        
    }
    return  @{@"roundsTitles": arrayWithRoundsWorkoutTitle,@"roundsContent": arrayWithRoundsWorkoutInfo};
}


+ (NSDictionary*)getRoundsWorkoutValues:(RoundsWorkouts*)workout {

    NSArray *workoutRoundsContent = @[workout.prepareTimeRounds,
                      workout.workTimeRounds,
                      workout.restTimeRounds,
                      workout.roundsRounds];
    NSString *title = workout.workoutNameRounds;
    
    return @{@"roundsTitle": title, @"roundsContent": workoutRoundsContent};
}


+ (NSDictionary *)getStopwatchWorkoutInfo:(NSArray *)workoutSets {
    NSMutableArray *arrayWithStopwatchWorkoutInfo = [NSMutableArray new];
    NSMutableArray *arrayWithStopwatchWorkoutTitle = [NSMutableArray new];
    for (int i=0; i<[workoutSets count]; i++) {
        NSDictionary *dict = [self getStopwatchWorkoutValues:workoutSets[i]];
        
        NSString *stopwatchTitle = dict[@"stopwatchTitle"];
        NSArray *stopwatchWorkoutArrayContent = dict[@"stopwatchContent"];
        
        [arrayWithStopwatchWorkoutInfo addObject:stopwatchWorkoutArrayContent];
        [arrayWithStopwatchWorkoutTitle addObject:stopwatchTitle];
    }
    return @{@"stopwatchTitles": arrayWithStopwatchWorkoutTitle,@"stopwatchContent": arrayWithStopwatchWorkoutInfo};;
}


+ (NSDictionary*)getStopwatchWorkoutValues:(StopwatchWorkouts*)workout {
   
    NSArray *workoutStopwatchContent = @[workout.prepareTimeStopwatch,
                         workout.timeLap];
    
    NSString *title = workout.workoutNameStopwatch;
    return @{@"stopwatchTitle":title, @"stopwatchContent":workoutStopwatchContent};
}


@end
