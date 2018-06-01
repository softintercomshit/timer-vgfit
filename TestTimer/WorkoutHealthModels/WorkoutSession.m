#import "WorkoutSession.h"

@interface WorkoutSession()

@property (readwrite) NSDate* startDate;
@property (readwrite) NSDate* endDate;
@end

@implementation WorkoutSession


-(instancetype)init {
    if (self == [super init]) {
        self.state = notStarted;
    }
    return self;
}

-(void)start {
    self.startDate = [NSDate date];
    self.state = active;
}

-(void)end {
    self.endDate = [NSDate date];
    self.state = finished;
}

-(void)clear {
    self.startDate = nil;
    self.endDate = nil;
    self.state = notStarted;
}


-(TabataWorkout*)completeWorkout {
    if (self.state == finished) {
        NSDate *start = self.startDate;
        NSDate *end  = self.endDate;
        
        if (end != self.endDate) {
            return nil;
        }
        return [[TabataWorkout new] initWithDate:start andEndDate:end];
    }else {
        return nil;
    }
}


@end
