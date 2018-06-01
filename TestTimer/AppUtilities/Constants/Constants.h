//
//  Constants.h
//  TestTimer
//
//  Created by a on 4/8/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

//Database Constants:
extern NSString * const CORE_DATA_DATABASE_FOLDER_NAME;
extern NSString * const CORE_DATA_DATABASE_NAME;

FOUNDATION_EXPORT NSString *const kTabataSelectedWorkoutSet;
FOUNDATION_EXPORT NSString *const kRoundsSelectedWorkoutSet;
FOUNDATION_EXPORT NSString *const kStopWatchSelectedWorkoutSet;

FOUNDATION_EXPORT NSString *const kRateUsButtonPushedKey;
FOUNDATION_EXPORT NSString *const kiOSAppIsRatedKey;
FOUNDATION_EXPORT NSString *const kLastCoreDataChangeKey;

@end
