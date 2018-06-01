//
//  CircleRoundsCount.h
//  TestTimer
//
//  Created by Andrei on 11/6/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleTimer.h"

@interface CircleRoundsCount : CircleTimer

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *roundsCountLabel;

@end
