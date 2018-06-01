//
//  AppColorManager.h
//  TestTimer
//
//  Created by Andrei on 11/20/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppColorManager : NSObject


// Tabata timer colors

@property (nonatomic, strong) NSMutableArray <UIColor*> *arrayWithTabataCircleColors;
@property (nonatomic, strong) NSMutableArray <UIColor*> *arrayWithRoundsAndCyclesCirclesColors;


// Rounds timer colors

@property (nonatomic, strong) NSMutableArray <UIColor*> *arrayWithRoundsCircleColors;
@property (nonatomic, strong) NSMutableArray <UIColor*> *arrayWithRoundsCountCircleColor;

// Stopwatch timer colors



//@property (nonatomic, strong) NSMutableArray <UIColor*> *arrayWithLabelTextColors;

+ (instancetype)sharedInstanceManager;

- (void)updateTabataColors;
- (void)updateRoundsColors;





//@property(nonatomic) TabataCircleType tabataCircleType;

@end
