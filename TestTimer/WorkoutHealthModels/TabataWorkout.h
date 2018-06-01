#import <Foundation/Foundation.h>
#import "TimerObject.h"

@interface TabataWorkout : NSObject

@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *end;
//@property (nonatomic) NSTimeInterval duration;

-(id)initWithDate:(NSDate*)startDate andEndDate:(NSDate*)endDate;

//-(NSTimeInterval)duration:(TimerObject*)timerObject;

@end
