//
//  AppleWatchClassesHandlers.h
//  TestTimer
//
//  Created by Andrei on 12/19/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppleWatchClassesHandlers : NSObject

+ (NSDictionary*)getTabataWorkoutInfo:(NSArray*)workoutSets;
+ (NSDictionary*)getRoundsWorkoutInfo:(NSArray*)workoutSets;
+ (NSDictionary*)getStopwatchWorkoutInfo:(NSArray*)workoutSets;

@end
