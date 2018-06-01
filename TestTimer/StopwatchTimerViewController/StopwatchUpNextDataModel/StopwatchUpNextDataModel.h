//
//  StopwatchUpNextDataModel.h
//  TestTimer
//
//  Created by Andrei on 11/24/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopwatchUpNextDataModel : NSObject

@property (strong, nonatomic) NSString *stopwatchUpNextString;
@property (strong, nonatomic) NSString *stopwatchNextWorkType;

//@property (strong, nonatomic) UIColor *roundsTextColor;

- (void)setStopwatchUpNextNames:(NSString*)stopwatchNextWork andStopwatchCircleType:(StopwatchCircleType)stopwatchCircleType;




@end
