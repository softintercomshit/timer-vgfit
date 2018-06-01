#import "TabataWorkout.h"

@implementation TabataWorkout


-(id)initWithDate:(NSDate*)startDate andEndDate:(NSDate*)endDate {
    self = [super init];
    if(self) {
        self.start = startDate;
        self.end = endDate;
    }
    return self;
}

@end
