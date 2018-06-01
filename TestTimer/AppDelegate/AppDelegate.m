//
//  AppDelegate.m
//  TestTimer
//
//  Created by a on 12/30/15.
//  Copyright © 2015 SoftIntercom. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsManagerViewController.h"
#import "SettingsManager.h"
#import "AppTheme.h"
#import "SettingsManagerViewController.h"
#import "CircleTimer.h"
#import "MainAppConnectivity.h"
#import "AppDelegate+RateButton.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "AppleWatchClassesHandlers.h"
#import <HealthKit/HealthKit.h>

@interface AppDelegate ()<CircleTimerDelegate, WCSessionDelegate>
{
    BOOL autoLockEnabled;
    BOOL rotationEnabled;
    BOOL duckingEnabled;
    BOOL soundEnabled;
    BOOL screenFlashEnabled;
    BOOL flashlightEnabled;
    BOOL vibrationEnabled;
    ConnectivityHandler *connectivityHandler;
    HealthKitSetupAssistant *healthAssistant;
    int counter;
}
@end

@implementation AppDelegate


- (void)dataRoundsCollectionViewColors
{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"selectedColorCollectionViewCellIndex"];
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"selectedColorCellIndexRoundsTime"];
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"pickedColorForCell"];
    
    
}

- (void)dataTabataCollectionViewColors
{
       [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"selectedColorForCell"];
      [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"selectedWorkTimeColorForCell"];
    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"selectedRestTimeColorForCell"];
     [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"selectedRoundsColorForCell"];
     [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"selectedCyclesColorForCell"];
    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"selectedRestBetweenCyclesTimeColorForCell"];
}


- (void)dataToSettingsFromNSUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:@"Boxing Bell" forKey:@"dateToTransferSelectedSongToPlay"];
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"selectedIndex"];
    [[NSUserDefaults standardUserDefaults] setObject:@"00:00" forKey:@"pickedValueForTimeFormat"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"selectedIndexFormatTime"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Black" forKey:@"currentThemeKey"];
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"indexVisualStyle"];
    //trebuie sa pun index-ul pentru black color
    
}
- (void) setAudioSession
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:&setCategoryErr];
    if (setCategoryErr)
    {
//        NSLog(@"Setting Audio Session Category Error: %@",[setCategoryErr description]);
    }
    [audioSession setActive:YES error:&activationErr];
    if (activationErr)
    {
//        NSLog(@"Activating Audio Session Error: %@",[activationErr description]);
    }
}
-(void)dataToMainRoundsFromNSUserDefaults
{
    //prepare
    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"dateFullSecPrepare"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"selectedPrepareTimeMin"];
    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"selectedPrepareTimeSec"];
    
    //work time
    [[NSUserDefaults standardUserDefaults] setInteger:30 forKey:@"fullValueSecRTVC"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"selectedPickedMinValue"];
    [[NSUserDefaults standardUserDefaults] setInteger:30 forKey:@"selectedPickedSecValue"];
    
    //rest time
    [[NSUserDefaults standardUserDefaults] setInteger:15 forKey:@"fullValueRestTimeValue"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"pickedRestMinValue"];
    [[NSUserDefaults standardUserDefaults] setInteger:15 forKey:@"pickedRestSecValue"];

    
    //rounds value
    [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"roundsValue"];
    [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"selectedRoundValue"];
    
    
    NSArray *pickerRoundsTimeIntervalsArray = @[@timerPrepareRoundsValue,
                                                @timerWorkRoundsValue,
                                                @timerRestRoundsValue,
                                                @timerRoundsCountValue];
    
    NSArray *arrayWithRoundsColors = @[@timerYellowColor,
                                        @timerGreenColor,
                                        @timerRedColor,
                                        @timerBlueColor];
    
    [[NSUserDefaults standardUserDefaults] setObject:pickerRoundsTimeIntervalsArray forKey:@"intervalsRoundsArray"];
    [[NSUserDefaults standardUserDefaults] setObject:arrayWithRoundsColors forKey:@"colorsRoundsArray"];
    
}
-(void)dataToStopWatchFromNSUserDefaults
{

    //prepare
    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"fullSecondsPrepareTime"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"selectedPrepareTimeMinValue"];
    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"selectedPrepareTimeSecValue"];
    
       //sound Each Sec
    [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"fullSecondsTimeLapSoundTime"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"selectedSoundEachTimeMinValue"];
    [[NSUserDefaults standardUserDefaults] setInteger:10 forKey:@"selectedSoundEachTimeSecValue"];
    
    NSArray *pickerStopwatchTimeIntervalsArray = @[@timerPrepareStopwatchValue,
                                                 @timerTimeLapStopwatchValue];
    
    [[NSUserDefaults standardUserDefaults] setObject:pickerStopwatchTimeIntervalsArray forKey:@"intervalsStopwatchArray"];
}

-(void)dataToTabataFromNSUserDefaults
{

    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"fullSecPrepare"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"selectedPrepareMinTimeValue"];
    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"selectedPrepareSecTimeValue"];
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:30 forKey:@"selectedSecondsFullValue"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"workTimePickedMinValue"];
    [[NSUserDefaults standardUserDefaults] setInteger:30 forKey:@"workTimePickedSecValue"];
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:15 forKey:@"fullValueSecRV"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"selectedPickedMinValueR"];
    [[NSUserDefaults standardUserDefaults] setInteger:15 forKey:@"selectedPickedSecValueR"];
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"fullRoundsValue"];
    [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"selectedPickedRoundsValue"];
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:3  forKey:@"fullCyclesValue"];
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"selectedPickedCyclesValue"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:30 forKey:@"fullValueSecRBC"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"selectedPickedMinValueRBC"];
    [[NSUserDefaults standardUserDefaults] setInteger:30 forKey:@"selectedPickedSecValueRBC"];
    
    NSArray *pickerTabataTimeIntervalsArray = @[@5,
                                                @30,
                                                @15,
                                                @4,
                                                @3,
                                                @30];
    
    NSArray *arrayWithTabataColors = @[@timerYellowColor,
                                                 @timerGreenColor,
                                                 @timerRedColor,
                                                 @timerBlueColor,
                                                 @timerTurquoiseColor,
                                                 @timerRedColor];
    

    [[NSUserDefaults standardUserDefaults] setObject:arrayWithTabataColors forKey:@"colorsTabataArray"];
    [[NSUserDefaults standardUserDefaults] setObject:pickerTabataTimeIntervalsArray forKey:@"intervalsTabataArray"];
   
}


- (void)dataFromSettingsManager
{
    soundEnabled = YES;
    [[SettingsManager sharedManager]updateSound:soundEnabled];
    screenFlashEnabled = YES;
    [[SettingsManager sharedManager]updateScreenFlash:screenFlashEnabled];
    rotationEnabled = YES;
    [[SettingsManager sharedManager]updateRotation:rotationEnabled];
    duckingEnabled = YES;
    [[SettingsManager sharedManager]updateDucking:duckingEnabled];
    flashlightEnabled = YES;
    [[SettingsManager sharedManager]updateFlashLight:flashlightEnabled];
    vibrationEnabled = YES;
    [[SettingsManager sharedManager] updateVibro:vibrationEnabled];
    
}


- (void)isAppAlreadyLaunchedOnce {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstRun"])
    {
//        NSLog(@"First run");
        
        [self dataTabataCollectionViewColors];
        [self dataToStopWatchFromNSUserDefaults];
        [self dataToMainRoundsFromNSUserDefaults];
        [self dataToTabataFromNSUserDefaults];
        [self dataToSettingsFromNSUserDefaults];
        [self dataRoundsCollectionViewColors];
        [self dataFromSettingsManager];
       
        [[AppTheme sharedManager] updateThemeWithStyle:3];
        [[AppTheme sharedManager] getCurrentStyle];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstRun"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
//        NSLog(@"Not first run");
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [Fabric with:@[[Crashlytics class]]];
    
    [self setupAppirater];
    [self syncICloudKeyValueStore];
//    [self resetRateUsButton];
    
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    if ([WCSession isSupported]) {
        connectivityHandler = [ConnectivityHandler new];
    }else{
        NSLog(@"WCSession not supported (f.e. on iPad).");
    }

    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
     [self setAudioSession];
    [self initiateObservers];

    [[AppInfo sharedManager] updateInfoWithCompletion:nil];
    [self isAppAlreadyLaunchedOnce];
    
    [[AppTheme sharedManager] loadSavedTheme];
    [[SettingsManager sharedManager]loadSettings];
    rotationEnabled = [[SettingsManager sharedManager]rotation];

    if(rotationEnabled)
    {
        [self canRotate];
    }
    else{
        [self canNotRotate];
    }
    
    return YES;
}


-(void) initiateObservers{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(canRotate) name:shouldRotate object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(canNotRotate) name:shouldNotRotate object:nil];
}

- (void) canRotate
{
    _allowRotation = YES;
}

- (void) canNotRotate
{
    _allowRotation = NO;
}


- (void)setupAppirater {
    
    [Appirater setDelegate:self];
    [Appirater setAppId:@"1160713176"];
    [Appirater setDaysUntilPrompt:2];
    [Appirater setUsesUntilPrompt:2];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
}

#pragma mark - Set Orientations
- (UIInterfaceOrientationMask) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_allowRotation)
    {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kRateUsButtonPushedKey]) {
        [self handleBackground:application];
    }
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
//     [[SettingsManager sharedManager] updateHealthKit:healthAssistant.isAuthorized];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    self.stopBackgroundTask = false;
    [self checkRateUsButton];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - iCloud


- (void)syncICloudKeyValueStore {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ubiquitousKeyValueStoreDidChange:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:[NSUbiquitousKeyValueStore defaultStore]];
    
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}


- (void)ubiquitousKeyValueStoreDidChange:(NSNotification*)notification {
    NSUbiquitousKeyValueStore *ubiquitousKeyValueStore = notification.object;
    [ubiquitousKeyValueStore synchronize];
    [self checkRateUsButton];
}

#pragma mark - AppiraterDelegate


- (void)appiraterDidOptToRate:(Appirater *)appirater {
    
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:kRateUsButtonPushedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)openWatchSession{
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

-(void)applicationShouldRequestHealthAuthorization:(UIApplication *)application {
    healthAssistant = [HealthKitSetupAssistant new];
    [healthAssistant authorizationHealthKit];
}





@end
