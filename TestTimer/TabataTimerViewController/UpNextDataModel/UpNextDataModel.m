//
//  UpNextDataModel.m
//  TestTimer
//
//  Created by Andrei on 11/14/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "UpNextDataModel.h"

@implementation UpNextDataModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.upNextString = @"";
        self.nextWorkType = @"";
        self.textColor = [UIColor blackColor];
    }
    return self;
}


- (void)setTabataUpNextNames:(NSString *)nextWork andTabataCircleType:(TabataCircleType)circleType {
    
    self.nextWorkType = nextWork;
    self.upNextString = [NSString stringWithFormat:@"%@:",[Utilities tabataTitle:circleType]];
    
}


@end
