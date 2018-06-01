//
//  SettingsManager.m
//  TestTimer
//
//  Created by a on 1/26/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "SettingsManager.h"
#import <AudioToolbox/AudioToolbox.h>
#define soundKey @"soundKey"
#define textSpeechKey @"textSpeechKey"
#define healthKitKey @"healthKitKey"
#define vibroKey @"vibroKey"
#define flashLightKey @"flashLightKey"
#define screenFlashKey @"screenFlashKey"
#define duckingKey @"duckingKey"
#define screenLockKey @"screenLockKey"
#define rotationKey @"rotationKey"




@implementation SettingsManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) loadSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.sound = [defaults boolForKey:soundKey];
    self.textSpeech = [defaults boolForKey:textSpeechKey];
    self.healthKit = [defaults boolForKey:healthKitKey];
    self.vibro = [defaults boolForKey:vibroKey];
    self.flash = [defaults boolForKey:flashLightKey];
    self.screenFlash = [defaults boolForKey:screenFlashKey];
    self.ducking = [defaults boolForKey:duckingKey];
    self.rotation = [defaults boolForKey:rotationKey];
}

-(void) updateSound:(BOOL)soundState {
    self.sound = soundState;
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setBool:soundState forKey:soundKey];
    [defaults synchronize];
}

-(void)updateTextSpeech:(BOOL)textSpeechState {
    self.textSpeech = textSpeechState;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:textSpeechState forKey:textSpeechKey];
    [defaults synchronize];
}

-(void)updateHealthKit:(BOOL)healthKitState {
    self.healthKit = healthKitState;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:healthKitState forKey:healthKitKey];
    [defaults synchronize];
}

-(void)updateVibro:(BOOL) vibroState {
    self.vibro = vibroState;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:vibroState forKey:vibroKey];
    [defaults synchronize];
}

-(void)updateFlashLight:(BOOL) flashLightState {
    self.flash =flashLightState;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:flashLightState forKey:flashLightKey];
    [defaults synchronize];
}

-(void)updateScreenFlash:(BOOL)screenFlashState {
    self.screenFlash =screenFlashState;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:screenFlashState forKey:screenFlashKey];
    [defaults synchronize];
}

-(void)updateDucking:(BOOL)duckingState {
    self.ducking=duckingState;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:duckingState forKey:duckingKey];
    [defaults synchronize];
}

-(void)updateRotation:(BOOL)rotationState {
    self.rotation = rotationState;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:rotationState forKey:rotationKey];
    [defaults synchronize];
}


@end
