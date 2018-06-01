#import <Foundation/Foundation.h>
#import "TabataWorkout.h"

typedef NS_ENUM(NSInteger, WorkoutSessionState) {
    notStarted,
    active,
    finished
};

@interface WorkoutSession : NSObject

@property (readonly) NSDate* startDate;
@property (readonly) NSDate* endDate;

@property (nonatomic,assign) NSInteger state;

-(void)start;
-(void)end;
-(void)clear;


-(TabataWorkout*)completeWorkout;


@end
