//
//  SettingsManagerImplementation.m
//  TestTimer
//
//  Created by Andrei on 11/20/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "SettingsManagerImplementation.h"

@interface SettingsManagerImplementation() <AVAudioPlayerDelegate,AVSpeechSynthesizerDelegate,AVAudioSessionDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioPlayer *audioBeep;
@property (nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;
@property (nonatomic, strong) AVAudioSession *audioSession;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@end

@implementation SettingsManagerImplementation


+ (instancetype) sharedInstance
{
    
    static SettingsManagerImplementation *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SettingsManagerImplementation alloc] init];
        sharedInstance.audioSession = [AVAudioSession sharedInstance];
        sharedInstance.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
        sharedInstance.speechSynthesizer.delegate = sharedInstance;
        sharedInstance.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
    });
    return sharedInstance;
}


#pragma mark - Vibration set On
- (void)vibrate
{
    [[SettingsManager sharedManager]loadSettings];
    if([[SettingsManager sharedManager] vibro] == YES){
        if (IS_IPHONE){
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        //        NSLog(@"vibro On");
    }
}


#pragma mark - Flashlight set off
- (void)flashLightOff
{
    
    _device =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([_device hasTorch]&& [_device hasFlash]) {
        [_device lockForConfiguration:nil];
        [_device setTorchMode:AVCaptureTorchModeOff];
        [_device setFlashMode:AVCaptureFlashModeOff];
    }
}

#pragma mark - Flashlight set on

- (void)flashlightOnOff
{
    
    [[SettingsManager sharedManager]loadSettings];
    if([[SettingsManager sharedManager] flash] == YES){
        _device =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([_device hasTorch]&& [_device hasFlash]) {
            [_device lockForConfiguration:nil];
            [_device setTorchMode:AVCaptureTorchModeOn];
            [_device setFlashMode:AVCaptureFlashModeOn];
            [_device unlockForConfiguration];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self flashLightOff];
        });
    }
}


- (SongNames)songNames {
    
    NSInteger soundIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedIndex"];
    NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[Utilities setSongTitle:soundIndex] ofType:@"wav"]];
    NSLog(@"------> %@",soundURL);
    assert(soundURL);
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    _audioPlayer.delegate = self;
    
    return soundIndex;
}


- (void)playSound {
    
    [[SettingsManager sharedManager]loadSettings];
    if([[SettingsManager sharedManager] sound] == YES){
        
        if([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground){
            
            [self.audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
            
        }
        else if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
            
            // activate audioSession to play utterance
            [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
            
        }
        
        
        if (_audioPlayer.playing) {
            
            [_audioPlayer pause];
            
        }
        
        _audioPlayer.currentTime = 0;
        [_audioPlayer play];
        
    }
}


- (void)playBeep
{
    [[SettingsManager sharedManager]loadSettings];
    
    if([[SettingsManager sharedManager] sound] == YES){
        
        if([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground){
            
            [self.audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
            
        }
        else if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
            
            // activate audioSession to play utterance
            [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
            
        }
        
        NSURL *heroSoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"BeepSound" ofType:@"wav"]];
        assert(heroSoundURL);
        _audioBeep = [[AVAudioPlayer alloc] initWithContentsOfURL:heroSoundURL error:nil];
        _audioBeep.delegate = self;
        [_audioBeep play];
        
    }
    
}

- (void) readText:(NSString *)text
{
 [[SettingsManager sharedManager]loadSettings];
    if([[SettingsManager sharedManager] textSpeech] == YES){

        if([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground){
            
            [self.audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
            
        }
        else if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
            
            // activate audioSession to play utterance
            [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
            
        }
        [self.audioSession setActive:YES error:nil];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
        [_speechSynthesizer speakUtterance:utterance];

    }
}


- (void)setTabataScreenFlashByCircleTypeColor:(TabataCircleType)tabataCircleType
{
    [[SettingsManager sharedManager] loadSettings];
    if ([[SettingsManager sharedManager]screenFlash] == YES) {
        UIWindow *window = [[UIApplication sharedApplication]keyWindow];
        UIView *flashView = [[UIView alloc] initWithFrame:UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ?
                             window.bounds : (IS_IPAD || IS_IPAD_PRO) ? CGRectMake(0, 0, window.frame.size.width, window.frame.size.height * .78) : CGRectMake(0, 0, window.frame.size.width, window.frame.size.height * .67)];
        flashView.backgroundColor = [AppColorManager sharedInstanceManager].arrayWithTabataCircleColors[tabataCircleType];

        [window addSubview:flashView];
        
        [UIView animateWithDuration:.3 animations:^{
            [UIView setAnimationRepeatCount:3];
            flashView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [flashView removeFromSuperview];
            
        }];
    }
}


- (void)setRoundsScreenFlashByCircleTypeColor:(RoundsCircleType)roundsCircleType {
    [[SettingsManager sharedManager] loadSettings];
    if ([[SettingsManager sharedManager]screenFlash] == YES) {
        UIWindow *window = [[UIApplication sharedApplication]keyWindow];
        UIView *flashView = [[UIView alloc] initWithFrame:UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ?
                             window.bounds : (IS_IPAD || IS_IPAD_PRO) ? CGRectMake(0, 0, window.frame.size.width, window.frame.size.height * .78) : CGRectMake(0, 0, window.frame.size.width, window.frame.size.height * .67)];
        flashView.backgroundColor = [AppColorManager sharedInstanceManager].arrayWithRoundsCircleColors[roundsCircleType];
        
        [window addSubview:flashView];
        
        [UIView animateWithDuration:.3 animations:^{
            [UIView setAnimationRepeatCount:3];
            flashView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [flashView removeFromSuperview];
            
        }];
    }
}


- (void)setStopwatchScreenFlashByCircleTypeColor {
    if ([[SettingsManager sharedManager]screenFlash] == YES) {
        UIWindow *window = [[UIApplication sharedApplication]keyWindow];
        UIView *flashView = [[UIView alloc] initWithFrame:UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ?
                             window.bounds : (IS_IPAD || IS_IPAD_PRO) ? CGRectMake(0, 0, window.frame.size.width, window.frame.size.height * .78) : CGRectMake(0, 0, window.frame.size.width, window.frame.size.height * .67)];
        flashView.backgroundColor = [UIColor whiteColor];
        
        [window addSubview:flashView];
        
        [UIView animateWithDuration:.3 animations:^{
            [UIView setAnimationRepeatCount:3];
            flashView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [flashView removeFromSuperview];
            
        }];
    }
}


- (void)rotateScreen
{
    [[SettingsManager sharedManager]loadSettings];
    if([[SettingsManager sharedManager] rotation] == YES){
        [[NSNotificationCenter defaultCenter] postNotificationName:shouldRotate object:nil userInfo:nil];
    }
}


- (TimerFormats)timerFormat {

    NSInteger timerFormatIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedIndexFormatTime"];
    switch (timerFormatIndex) {
        case 0:
            _timerFormat = MinSec;
            break;
        case 1:
            _timerFormat = MilisecondsOneDigit;
            break;
        case 2:
            _timerFormat = MilisecondsTwoDigits;
            break;
        default:
            _timerFormat = MinSec;
            break;
    }
    return timerFormatIndex;
}


@end
