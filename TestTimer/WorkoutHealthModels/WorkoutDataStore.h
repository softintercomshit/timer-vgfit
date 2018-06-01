#import <Foundation/Foundation.h>
#import "TabataWorkout.h"

@interface WorkoutDataStore : NSObject

- (void)save:(TabataWorkout*_Nonnull)tabataWorkout andDuration:(NSTimeInterval)duration completion:(void (^_Nonnull)(BOOL success, NSError* _Nullable error))block;

@end
