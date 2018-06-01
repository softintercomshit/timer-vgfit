//
//  StopwatchWorkouts+CoreDataProperties.h
//  TestTimer
//
//  Created by user on 5/30/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "StopwatchWorkouts.h"

NS_ASSUME_NONNULL_BEGIN

@interface StopwatchWorkouts (CoreDataProperties)
@property (nonatomic) NSNumber *prepareTimeStopwatch;
@property (nonatomic) NSNumber *timeLap;
@property (nullable, nonatomic, retain) NSString *workoutNameStopwatch;
@property (nullable, nonatomic, retain) NSString *workoutTimeStampStopwatch;
@property (nonatomic) NSNumber *stopWatchID;
@end

NS_ASSUME_NONNULL_END
