//
//  SettingsManagerImplementation.h
//  TestTimer
//
//  Created by Andrei on 11/20/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingsManagerImplementation : NSObject

@property (nonatomic) TimerFormats timerFormat;

+ (instancetype)sharedInstance;

- (void)vibrate;
- (void)flashlightOnOff;
- (void)playSound;
- (void)playBeep;
- (void)readText:(NSString *)text;

- (void)setTabataScreenFlashByCircleTypeColor:(TabataCircleType)tabataCircleType;
- (void)setRoundsScreenFlashByCircleTypeColor:(RoundsCircleType)roundsCircleType;
- (void)setStopwatchScreenFlashByCircleTypeColor;

- (void)rotateScreen;

-(TimerFormats)timerFormat;
-(SongNames)songNames;

@end
