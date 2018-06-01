#import "WorkoutDataStore.h"
#import <HealthKit/HealthKit.h>

@implementation WorkoutDataStore


- (void)save:(TabataWorkout*_Nonnull)tabataWorkout andDuration:(NSTimeInterval)duration completion:(void (^_Nonnull)(BOOL success, NSError* _Nullable error))block {
    
    HKWorkout *workout = [HKWorkout workoutWithActivityType:HKWorkoutActivityTypeOther
                                                  startDate:tabataWorkout.start
                                                    endDate:tabataWorkout.end
                                                   duration:duration
                                          totalEnergyBurned:nil
                                              totalDistance:nil
                                                     device:[HKDevice localDevice]
                                                   metadata:nil];
    
    NSLog(@"Start Date tabata workout == %@", tabataWorkout.start);
    NSLog(@"End Date tabata workout == %@", tabataWorkout.end);
//    NSLog(@"Duration tabata workout == %f", tabataWorkout.duration);
     NSLog(@"Duration tabata workout == %f", duration);
    
    HKHealthStore *healthStore = [HKHealthStore new];
    HealthKitSetupAssistant *healthKitSetup = [HealthKitSetupAssistant new];
    if(healthKitSetup.isAuthorized) {
        [healthStore saveObject:workout withCompletion:^(BOOL success, NSError * _Nullable error) {
            block(success, error);
        }];
    }
}

@end
