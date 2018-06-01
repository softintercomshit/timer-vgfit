//
//  AppColorManager.m
//  TestTimer
//
//  Created by Andrei on 11/20/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "AppColorManager.h"

@implementation AppColorManager

static AppColorManager *sharedInstance = nil;


+ (instancetype)sharedInstanceManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[AppColorManager alloc] init];
        sharedInstance.arrayWithTabataCircleColors = [NSMutableArray new];
        sharedInstance.arrayWithRoundsAndCyclesCirclesColors = [NSMutableArray new];

        sharedInstance.arrayWithRoundsCircleColors = [NSMutableArray new];
        sharedInstance.arrayWithRoundsCountCircleColor = [NSMutableArray new];
        
        [sharedInstance updateTabataColors];
        [sharedInstance updateRoundsColors];
    });
    return  sharedInstance;
}

- (void)updateTabataColors {
    [sharedInstance.arrayWithTabataCircleColors removeAllObjects];
    [sharedInstance.arrayWithRoundsAndCyclesCirclesColors removeAllObjects];
//    [sharedInstance.arrayWithLabelTextColors removeAllObjects];
    

    
    NSArray *colorsDefaultData = [[NSUserDefaults standardUserDefaults] objectForKey:@"colorsTabataArray"];
    [sharedInstance.arrayWithTabataCircleColors addObject:[Utilities circleColor:[colorsDefaultData[PrepareIndex]integerValue]]];
    [sharedInstance.arrayWithTabataCircleColors addObject:[Utilities circleColor:[colorsDefaultData[WorkIndex]integerValue]]];
    [sharedInstance.arrayWithTabataCircleColors addObject:[Utilities circleColor:[colorsDefaultData[RestIndex]integerValue]]];
    [sharedInstance.arrayWithTabataCircleColors addObject:[Utilities circleColor:[colorsDefaultData[RestBetweenCyrclesIndex]integerValue]]];
    
    [sharedInstance.arrayWithRoundsAndCyclesCirclesColors addObject:[Utilities circleColor:[colorsDefaultData[RoundsIndex]integerValue]]];
    [sharedInstance.arrayWithRoundsAndCyclesCirclesColors addObject:[Utilities circleColor:[colorsDefaultData[CyrclesIndex]integerValue]]];
    
    if (![colorsDefaultData isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"colorsTabataArray"]]) {
        [sharedInstance.arrayWithTabataCircleColors removeAllObjects];
        [sharedInstance.arrayWithRoundsAndCyclesCirclesColors removeAllObjects];
        [sharedInstance.arrayWithTabataCircleColors addObject:[Utilities getYellowColor]];
        [sharedInstance.arrayWithTabataCircleColors addObject:[Utilities getGreenColor]];
        [sharedInstance.arrayWithTabataCircleColors addObject:[Utilities getRedColor]];
        [sharedInstance.arrayWithTabataCircleColors addObject:[Utilities getRedColor]];
        
        [sharedInstance.arrayWithRoundsAndCyclesCirclesColors addObject:[Utilities getBlueColor]];
        [sharedInstance.arrayWithRoundsAndCyclesCirclesColors addObject:[Utilities getTurquoiseColor]];
    }
}



- (void)updateRoundsColors {
    
    [sharedInstance.arrayWithRoundsCircleColors removeAllObjects];
    [sharedInstance.arrayWithRoundsCountCircleColor removeAllObjects];
    
    //colorsRoundsArray
     NSArray *colorsDefaultData = [[NSUserDefaults standardUserDefaults] objectForKey:@"colorsRoundsArray"];
    [sharedInstance.arrayWithRoundsCircleColors addObject:[Utilities circleColor:[colorsDefaultData[RoundsPrepareIndex]integerValue]]];
    [sharedInstance.arrayWithRoundsCircleColors addObject:[Utilities circleColor:[colorsDefaultData[RoundsWorkIndex]integerValue]]];
    [sharedInstance.arrayWithRoundsCircleColors addObject:[Utilities circleColor:[colorsDefaultData[RoundsRestIndex]integerValue]]];
    
    [sharedInstance.arrayWithRoundsCountCircleColor addObject:[Utilities circleColor:[colorsDefaultData[RoundsIndexCountIndex]integerValue]]];
    
    
     if (![colorsDefaultData isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"colorsRoundsArray"]]) {
         [sharedInstance.arrayWithRoundsCircleColors removeAllObjects];
         [sharedInstance.arrayWithRoundsCountCircleColor removeAllObjects];
         [sharedInstance.arrayWithRoundsCircleColors addObject:[Utilities getYellowColor]];
         [sharedInstance.arrayWithRoundsCircleColors addObject:[Utilities getGreenColor]];
         [sharedInstance.arrayWithRoundsCircleColors addObject:[Utilities getRedColor]];
         
         [sharedInstance.arrayWithRoundsCountCircleColor addObject:[Utilities getBlueColor]];
     }
    
}





@end
