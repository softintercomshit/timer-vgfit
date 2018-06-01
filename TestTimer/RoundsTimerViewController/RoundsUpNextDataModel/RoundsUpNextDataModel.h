//
//  RoundsUpNextDataModel.h
//  TestTimer
//
//  Created by Andrei on 11/23/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoundsUpNextDataModel : NSObject

@property (strong, nonatomic) NSString *roundsUpNextString;
@property (strong, nonatomic) NSString *roundsNextWorkType;

@property (strong, nonatomic) UIColor *roundsTextColor;

- (void)setRoundsUpNextNames:(NSString*)roundsNextWork andRoundsCircleType:(RoundsCircleType)roundsCircleType;


@end
