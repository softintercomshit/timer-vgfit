//
//  StopwatchUpNextDataModel.m
//  TestTimer
//
//  Created by Andrei on 11/24/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "StopwatchUpNextDataModel.h"

@implementation StopwatchUpNextDataModel

- (instancetype)init {
    
    self = [super init];
    self.stopwatchNextWorkType = @"";
    self.stopwatchUpNextString = @"";
    
    return self;
}


- (void)setStopwatchUpNextNames:(NSString *)stopwatchNextWork andStopwatchCircleType:(StopwatchCircleType)stopwatchCircleType {
    self.stopwatchNextWorkType = stopwatchNextWork;
    self.stopwatchUpNextString = [NSString stringWithFormat:@"%@:", [Utilities stopwatchTitle:stopwatchCircleType]];
}



@end
