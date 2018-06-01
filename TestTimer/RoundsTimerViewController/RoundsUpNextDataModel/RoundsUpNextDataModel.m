//
//  RoundsUpNextDataModel.m
//  TestTimer
//
//  Created by Andrei on 11/23/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "RoundsUpNextDataModel.h"

@implementation RoundsUpNextDataModel


- (instancetype)init {
    self = [super init];
    if (self) {
        self.roundsNextWorkType = @"";
        self.roundsUpNextString = @"";
        self.roundsTextColor = [UIColor blackColor];
    }
    return self;
}


- (void)setRoundsUpNextNames:(NSString *)roundsNextWork andRoundsCircleType:(RoundsCircleType)roundsCircleType {
    
    self.roundsNextWorkType = roundsNextWork;
    self.roundsUpNextString = [NSString stringWithFormat:@"%@:",[Utilities roundsTitle:roundsCircleType]];
}


@end
