//
//  NSLayoutConstraint+Multiplier.h
//  TestTimer
//
//  Created by Andrei on 11/28/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (Multiplier)

-(instancetype)updateMultiplier:(CGFloat)multiplier;
-(instancetype)updatePriority:(CGFloat)priority;

@end
