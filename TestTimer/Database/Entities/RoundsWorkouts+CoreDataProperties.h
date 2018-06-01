//
//  RoundsWorkouts+CoreDataProperties.h
//  TestTimer
//
//  Created by user on 5/30/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RoundsWorkouts.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoundsWorkouts (CoreDataProperties)
@property (nonatomic) NSNumber *prepareTimeRounds;
@property (nonatomic) NSNumber *workTimeRounds;
@property (nonatomic) NSNumber *restTimeRounds;
@property (nonatomic) NSNumber *roundsRounds;
@property (nullable, nonatomic, retain) NSString *workoutNameRounds;
@property (nullable, nonatomic, retain) NSString *workoutTimeStampRounds;
@property (nonatomic) NSNumber *roundsID;
@end

NS_ASSUME_NONNULL_END
