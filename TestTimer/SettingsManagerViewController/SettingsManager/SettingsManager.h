//
//  SettingsManager.h
//  TestTimer
//
//  Created by a on 1/26/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

@property (nonatomic, assign) BOOL sound;
@property (nonatomic, assign) BOOL textSpeech;
@property (nonatomic, assign) BOOL vibro;
@property (nonatomic,assign) BOOL healthKit;
@property (nonatomic,assign) BOOL flash;
@property (nonatomic,assign) BOOL screenFlash;
@property (nonatomic,assign) BOOL ducking;
//@property (nonatomic,assign) BOOL screenLock;
@property (nonatomic,assign) BOOL rotation;




+ (instancetype) sharedManager;
- (void) loadSettings;
- (void) updateSound:(BOOL) soundState;
- (void) updateTextSpeech:(BOOL) textSpeechState;
- (void) updateHealthKit:(BOOL) healthKitState;
- (void) updateVibro:(BOOL) vibroState;
- (void) updateFlashLight:(BOOL) flashLightState;
- (void) updateScreenFlash:(BOOL) screenFlashState;
- (void) updateDucking:(BOOL) duckingState;
//- (void) updateScreenLock:(BOOL) screenLockState;
- (void) updateRotation:(BOOL) rotationState;


@end
