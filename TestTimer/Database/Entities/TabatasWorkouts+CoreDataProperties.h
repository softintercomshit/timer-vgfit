//
//  TabatasWorkouts+CoreDataProperties.h
//  TestTimer
//
//  Created by user on 5/26/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TabatasWorkouts.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabatasWorkouts (CoreDataProperties)
@property (nonatomic) NSNumber* prepareTime;
@property (nonatomic) NSNumber* workTime;
@property (nonatomic) NSNumber* restTime;
@property (nonatomic) NSNumber* roundsTabata;
@property (nonatomic) NSNumber* cyclesTabata;
@property (nonatomic) NSNumber* restBetweenCyclesTime;
@property (nonatomic) NSNumber* colorIndex;
@property (nullable, nonatomic, retain) NSString *workoutName;
@property (nullable, nonatomic, retain) NSString *workoutTimeStamp;
@property (nonatomic) NSNumber* tabataID;
@end

NS_ASSUME_NONNULL_END
