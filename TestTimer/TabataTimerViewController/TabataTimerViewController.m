//
//  TabataTimerViewController.m
//  TestTimer
//
//  Created by Andrei on 10/24/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "TabataTimerViewController.h"
#import "TabataPortraitView.h"
#import "TabataLandscapeView.h"
#import "CircleTabataTimer.h"
#import "CircleCyclesEnumerate.h"
#import "CircleRoundsEnumerate.h"
#import "TabataObject.h"
#import "TabataIntervalsViewController.h"
#import "UpNextDataModel.h"
#import "SettingsManagerViewController.h"
#import "AppTheme.h"
#import "SettingsManagerImplementation.h"
#import "MainAppConnectivity.h"
#import "WorkoutDataStore.h"
#import "WorkoutSession.h"
#import "TabataWorkout.h"


@interface TabataTimerViewController ()  <UITabBarControllerDelegate,UITabBarDelegate,UISplitViewControllerDelegate,TimerObjectDelegate>
//TODO: setup as proprietes
{
    TimerObject *timerObj;
    TabataCircleType tabataCircleType;
    UpNextDataModel *upNextDataModel;
    TimerFormats timerFormat;
    BOOL runOnce;
//    HealthKitSetupAssistant *setupAssistant;
    WorkoutSession *workoutSession;
    WorkoutDataStore *workoutDateStore;
}

@property (weak, nonatomic) IBOutlet UILabel *completedWorkoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundsLeftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cyclesLeftTitleLabel;

@property (weak, nonatomic) IBOutlet TabataPortraitView *tabataPortraitView;
@property (weak, nonatomic) IBOutlet TabataLandscapeView *tabataLandscapeView;
@property (weak, nonatomic) IBOutlet CircleTabataTimer *circleTabataTimer;
@property (weak, nonatomic) IBOutlet CircleRoundsEnumerate *circleRoundsEnumerate;
@property (weak, nonatomic) IBOutlet CircleCyclesEnumerate *circleCyclesEnumerate;

#pragma mark - Outlets for bar button items

@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *intervalsBarButtonItem;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *totalTimeLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *playButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *resetButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *upNextButton;
@property (strong,nonatomic) IBOutletCollection(UILabel) NSArray *nextWorkLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalConstraintCircleTabataTimer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintCircleTabataTimer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomUpNextLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCircleRoundsEnumerateConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCircleRoundsEnumerateConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCircleCyclesEnumerateConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCircleCyclesEnumerateConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCircleRoundsEnumerateConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCircleCyclesEnumerateConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingTotalTimeLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingTotalTimeLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacingUpNextLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomTotalTimeLabelConstraint;
@property (weak, nonatomic) IBOutlet UILabel *playButtonTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *resetButtonTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingPlayButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingResetButtonConstraint;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;
@property (weak, nonatomic) IBOutlet UILabel *tabataCompletedLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomTotalTimeConstraint;

// Object property models

@property (strong,nonatomic) TabataObject *tabataObject;

@end

@implementation TabataTimerViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tabata".localized;
    if (IS_IPAD_PRO || IS_IPAD) {
        self.circleRoundsEnumerate.thickness = 14;
         self.circleCyclesEnumerate.thickness = 14;
    }
    upNextDataModel = [UpNextDataModel new];
    [[SettingsManagerImplementation sharedInstance] readText:@" "];
    [self setupTimerObject];
    [self setupColors];
    [self.tabataLandscapeView setHidden:true];
    [self.navigationController setNavbarAppearence];
//    setupAssistant = [HealthKitSetupAssistant new];
//    [setupAssistant authorizationHealthKit];
//
//    NSLog(@"authorize kit status == %@", setupAssistant.isAuthorized ? @"yes": @"no");
    
    workoutSession = [WorkoutSession new];
    workoutDateStore = [WorkoutDataStore new];
}



- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        
        [self.tabataPortraitView setHidden:true];
        [self.tabataLandscapeView setHidden:false];
        [self.tabBarController.tabBar setBackgroundImage:[UIImage new]];
        [self setupButtonOutletCollectionLandscape];
        [self setupLabelOutletCollectionLandsape];
        [self setupLandscapeIPadConstraintsAndLayout];
        [UIView animateWithDuration:.15 animations:^{
              [_circleTabataTimer setupLandscapeForSafeAreaConstraints];
        }];
      
        
    }else{
        
        [self.tabataPortraitView setHidden:false];
        [self.tabataLandscapeView setHidden:true];
        [self setupButtonOutletCollectionPortrait];
        [self setupLabelOutletCollectionPortrait];
        [self setupPortraitIPadConstraintsAndLayout];
        [self setPortraitConstraintForSafeAreaDevices];
        [UIView animateWithDuration:.15 animations:^{
            [_circleTabataTimer setupPortraitForSafeAreaConstraints];
        }];
        
    }
    
    [self.circleTabataTimer setNeedsDisplay];
    [self.circleRoundsEnumerate setNeedsDisplay];
    [self.circleCyclesEnumerate setNeedsDisplay];
    
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateInterfaceOrientation:toInterfaceOrientation];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [[AppTheme sharedManager]loadSavedTheme];
    for (UIButton *button in _playButton) {
        [button setTintColor:[[AppTheme sharedManager]buttonBackgroundColor]];
    }
    
    for (UIButton *button in _resetButton) {
        [button setTintColor:[[AppTheme sharedManager]buttonBackgroundColor]];
    }
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        [UIView animateWithDuration:.15 animations:^{
            [_circleTabataTimer setupLandscapeForSafeAreaConstraints];
        }];
    }else{
        [UIView animateWithDuration:.15 animations:^{
            [_circleTabataTimer setupPortraitForSafeAreaConstraints];
        }];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [timerObj requestCurrentValues];
     [self setupUpNextTitlesTexts];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserver];
    self.tabBarController.delegate = self;
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        [self.tabataPortraitView setHidden:true];
        [self.tabataLandscapeView setHidden:false];
        [self.tabBarController.tabBar setBackgroundImage:[UIImage new]];
        [self setupButtonOutletCollectionLandscape];
        [self setupLabelOutletCollectionLandsape];
        [self setupLandscapeIPadConstraintsAndLayout];
        [UIView animateWithDuration:.15 animations:^{
            [_circleTabataTimer setupLandscapeForSafeAreaConstraints];
        }];
        
    }else{
        [self.tabataPortraitView setHidden:false];
        [self.tabataLandscapeView setHidden:true];
        [self setupButtonOutletCollectionPortrait];
        [self setupLabelOutletCollectionPortrait];
        [self setupPortraitIPadConstraintsAndLayout];
         [self setPortraitConstraintForSafeAreaDevices];
        [UIView animateWithDuration:.15 animations:^{
            [_circleTabataTimer setupPortraitForSafeAreaConstraints];
        }];
        
    }
    
    [self.circleTabataTimer setNeedsDisplay];
    [self.circleRoundsEnumerate setNeedsDisplay];
    [self.circleCyclesEnumerate setNeedsDisplay];
    [self updateTabataArrays];
    [self updateUI];
//    [workoutSession clear];
//    [self updateButtonStatus];
    [self.navigationController setNavbarAppearence];
}


#pragma mark - TimerObj class delegates

-(void)timer:(TimerObject *)timerObject totalTimeString:(NSString *)totalTimeString currentTimeString:(NSString *)currentTimeString iterationCompleted:(BOOL)iterationCompleted needToPlaySound:(BOOL)needToPlaySound {
    
    for (UIButton *button in _playButton) {
        [button setSelected:timerObj.isRunning];
    }
    NSDictionary *item = _tabataObject.tabataCircleViewValuesArray[_tabataObject.currentIndex];
    [_circleTabataTimer setSecondsValue:item[kTimeValue]];
    [_circleTabataTimer setTabataCircleType:tabataCircleType];
    _circleTabataTimer.timeLabel.text = currentTimeString;
    [_circleTabataTimer setTimerFormat:[SettingsManagerImplementation sharedInstance].timerFormat];
    
    for (UILabel *label  in self.totalTimeLabel) {
        label.text =  totalTimeString;
    }
    
    //    [_circleTabataTimer setPauseColor:[UIColor redColor]];
    
    if (_tabataObject.currentIndex + 1 < _tabataObject.tabataCircleViewValuesArray.count) {
        [self setupUpNextTitlesTexts];
        NSDictionary *item = _tabataObject.tabataCircleViewValuesArray[_tabataObject.currentIndex + 1];
        TabataCircleType circleType = [item[kCircleTypeKey]integerValue];
        [upNextDataModel setTabataUpNextNames:[Utilities timeFormatString:item[kTimeValue]] andTabataCircleType:circleType];
    }
    
    if (iterationCompleted) {
        
        [_circleTabataTimer setNullValue];
        
//        if (
//            (tabataCircleType == Rest && _tabataObject.tabataPickers[RestIndex].integerValue > 0) ||
//            (_tabataObject.tabataPickers[RoundsIndex].integerValue == 1 && tabataCircleType == Work) ||
//            (tabataCircleType == Work && _tabataObject.tabataPickers[RestIndex].integerValue == 0)
//            ) {
        BOOL case1 = tabataCircleType == Rest;
        BOOL case2 = tabataCircleType == Work && _tabataObject.tabataPickers[RestIndex].integerValue == 0;
        
        if (case1 || case2) {
            _tabataObject.roundsLeft--;
        }
        
        if (_circleRoundsEnumerate.totalTime -_circleRoundsEnumerate.elapsedTime <= 0.05) {
            _tabataObject.roundsLeft = _tabataObject.tabataPickers[RoundsIndex].integerValue;
            _tabataObject.cyclesLeft--;
            [_circleRoundsEnumerate reset];
        }
        
        [self setupRoundsCyclesTexts];
        
        _tabataObject.currentIndex++;
       
        NSLog(@"current == %ld", _tabataObject.currentIndex);
        NSLog(@"count tot == %ld",_tabataObject.tabataCircleViewValuesArray.count - 1);
        if (_tabataObject.currentIndex > _tabataObject.tabataCircleViewValuesArray.count - 1) {
            if (IS_IPHONE) {
                [self finishWorkout];
                [workoutDateStore save:workoutSession.completeWorkout andDuration:timerObj.elapsedTime completion:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        [workoutSession clear];
                    }else {
                        NSLog(@"There was a problem saving your workout");
                    }
                }];
            }
            [self showBlur];
            _tabataObject.currentIndex = 0;
            [_circleTabataTimer reset];
            [_circleRoundsEnumerate reset];
            [_circleCyclesEnumerate reset];
            [self setupTimerObject];
            return;
        }
        
        [_circleTabataTimer reset];
        tabataCircleType = [_tabataObject.tabataCircleViewValuesArray[_tabataObject.currentIndex][kCircleTypeKey]integerValue];
//         [[AppColorManager sharedInstanceManager] updateTabataColors];
//        [self setupColors];
        [self setupCirclesTotalTime];
        
        [_circleTabataTimer start];
        
        if (tabataCircleType != RestBetweenCycles && tabataCircleType != Prepare) {
            [_circleRoundsEnumerate start];
        }
        
        if (tabataCircleType != Prepare) {
            [_circleCyclesEnumerate start];
        }
        
        
        [[SettingsManagerImplementation sharedInstance]vibrate];
        NSThread *threadObj = [[NSThread alloc] initWithTarget:self selector:@selector(flashMethod) object:nil];
        [threadObj start];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SettingsManagerImplementation sharedInstance] playSound];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SettingsManagerImplementation sharedInstance] readText:[Utilities tabataTitle:tabataCircleType]];
        });
        [[SettingsManagerImplementation sharedInstance]rotateScreen];
        [[SettingsManagerImplementation sharedInstance]setTabataScreenFlashByCircleTypeColor:tabataCircleType];
    }
    
    if(needToPlaySound) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *speechText = [currentTimeString stringByReplacingOccurrencesOfString:@":" withString:@""];
            speechText = [speechText stringByReplacingOccurrencesOfString:@"0" withString:@" "];
            
            if ([SettingsManagerImplementation sharedInstance].timerFormat == MinSec) {
                [[SettingsManagerImplementation sharedInstance]readText:[NSString stringWithFormat:@"%ld",(long)speechText.integerValue]];
            }else{
                [[SettingsManagerImplementation sharedInstance]readText:[NSString stringWithFormat:@"%ld",(long)speechText.integerValue + 1]];
            }
        });
        
        [[SettingsManagerImplementation sharedInstance] playBeep];
    }
}


- (void)timer:(TimerObject *)timerObject totalTime:(NSTimeInterval)totalTime currentTime:(NSTimeInterval)currentTime {
    
}


- (IBAction)intervalsButtonAction:(id)sender {
    
    TabataIntervalsViewController *tabataViewCon  = [self.storyboard instantiateViewControllerWithIdentifier:@"TabataIntervalsViewController"];
    
    if (timerObj.isRunning) {
        timerObj.isRunning = true;
        [_circleTabataTimer stop];
        [_circleRoundsEnumerate stop];
        [_circleCyclesEnumerate stop];
        [timerObj playPause];
        for (UIButton *button in _playButton) {
            [button setSelected:timerObj.isRunning];
        }
    }
    [self.navigationController pushViewController:tabataViewCon animated:true];
}

- (IBAction)settingsButtonAction:(id)sender {
    
    SettingsManagerViewController *settingsMananagerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsManagerViewController"];
    
    [UIView transitionWithView:self.navigationController.view
                      duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:nil
                    completion:nil];
    if (timerObj.isRunning) {
        timerObj.isRunning = true;
        [_circleTabataTimer stop];
        [_circleRoundsEnumerate stop];
        [_circleCyclesEnumerate stop];
        [timerObj playPause];
        for (UIButton *button in _playButton) {
            [button setSelected:timerObj.isRunning];
        }
    }
    [self.navigationController pushViewController:settingsMananagerVC animated:false];
    
}

- (BOOL)runOnceMethod{
    
    if (runOnce == false) {
        [[SettingsManagerImplementation sharedInstance]vibrate];
        NSThread *threadObj = [[NSThread alloc] initWithTarget:self selector:@selector(flashMethod) object:nil];
        [threadObj start];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SettingsManagerImplementation sharedInstance] playSound];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SettingsManagerImplementation sharedInstance] readText:[Utilities tabataTitle:tabataCircleType]];
        });
        [[SettingsManagerImplementation sharedInstance]rotateScreen];
        [[SettingsManagerImplementation sharedInstance]setTabataScreenFlashByCircleTypeColor:tabataCircleType];
        runOnce = true;
    }
    return runOnce;
}

- (IBAction)playButton:(id)sender {
    if (!timerObj.isRunning) {
        _playButtonTitleLabel.text = @"Pause".localized;
        [_circleTabataTimer start];
        
        [self runOnceMethod];
        
        if (tabataCircleType != RestBetweenCycles && tabataCircleType != Prepare) {
            [_circleRoundsEnumerate start];
        }
        if (tabataCircleType != Prepare) {
            [_circleCyclesEnumerate start];
        }
         [self beginWorkout];
    }else{
         _playButtonTitleLabel.text = @"Resume".localized;
        [_circleRoundsEnumerate stop];
        [_circleCyclesEnumerate stop];
        [_circleTabataTimer stop];
        [self finishWorkout];
    }
//    [self startStopButtonPressed];
    [timerObj playPause];
    NSLog(@"timerOBject elapsed time == %f", timerObj.elapsedTime);
    for (UIButton *button in _playButton) {
        [button setSelected:timerObj.isRunning];
    }
}

- (IBAction)resetButtonAction:(id)sender {
    
    if (_circleTabataTimer.elapsedTime>0.1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"Do you want to reset the timer?".localized
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* cancelAlertAction = [UIAlertAction actionWithTitle:@"Cancel".localized
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction *action)
                                            {
                                                
                                                NSLog(@"Cancel action");
                                                //                                            [self dismissViewControllerAnimated:true completion:nil];
                                            }];
        UIAlertAction* yesAlertAction = [UIAlertAction actionWithTitle:@"Yes".localized
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action)
                                         {
                                             [self resetTabataTimer];
                                             NSLog(@"Yes action");
                                         }];
        
        [alertController addAction:cancelAlertAction];
        [alertController addAction:yesAlertAction];
        alertController.view.backgroundColor = [UIColor whiteColor];
        alertController.view.layer.cornerRadius = 25;
        [self presentViewController:alertController animated:false completion:nil];
    }
}


#pragma mark - Other methods


- (void)setupTimerObject {
    
    self.tabataObject = [[TabataObject alloc]init];
    [self.tabataObject setupTimer];
    
    tabataCircleType = [_tabataObject.tabataCircleViewValuesArray[_tabataObject.currentIndex][kCircleTypeKey]integerValue];
    
    timerObj = [[TimerObject alloc] initWithCountDownTimerModeAndTimerFormat:[[SettingsManagerImplementation sharedInstance]timerFormat] timerIntervalsArray:self.tabataObject.valuesForTimer];
    
    [timerObj setDelegate:self];
    [timerObj setResetAfterEnding:false];
    [timerObj requestInitialValues];
    
    [self setupRoundsCyclesTexts];
    
    [self setupCirclesTotalTime];
    
    [self setupUpNextTitlesTexts];
    
}


- (void)setupRoundsCyclesTexts{
    
    for (UILabel *label in _circleRoundsEnumerate.roundsLabel) {
        [label setText:[NSString stringWithFormat:@"%ld",(long)_tabataObject.roundsLeft]];
        [label setTextColor:[AppColorManager sharedInstanceManager].arrayWithRoundsAndCyclesCirclesColors[0]];
    }
    for (UILabel *label in _circleCyclesEnumerate.cyclesLabel) {
        [label setText:[NSString stringWithFormat:@"%ld",(long)_tabataObject.cyclesLeft]];
        [label setTextColor:[AppColorManager sharedInstanceManager].arrayWithRoundsAndCyclesCirclesColors[1]];
    }
}


- (void)setupCirclesTotalTime {
    
    [_circleTabataTimer setTotalTime:[_tabataObject.tabataCircleViewValuesArray[_tabataObject.currentIndex][kTimeValue] doubleValue]];
    [_circleRoundsEnumerate setTotalTime:_tabataObject.roundsTotalTime];
    if (_tabataObject.cyclesLeft == 1 && _tabataObject.tabataPickers[RestBetweenCyrclesIndex].integerValue >= 0) {
        NSInteger roundstotal = (_tabataObject.tabataPickers[WorkIndex].integerValue + _tabataObject.tabataPickers[RestIndex].integerValue) * _tabataObject.tabataPickers[RoundsIndex].integerValue - _tabataObject.tabataPickers[RestIndex].integerValue;
        [_circleRoundsEnumerate setTotalTime:roundstotal];
    }
    
    [_circleCyclesEnumerate setTotalTime:_tabataObject.cyclesTotalTime];
}


- (void)setupUpNextTitlesTexts {
    
    for (UIButton *button in self.upNextButton) {
        [button setTitle:upNextDataModel.upNextString forState:UIControlStateNormal];
    }
    for (UILabel *label in self.nextWorkLabel) {
        [label setText:upNextDataModel.nextWorkType];
    }
}


- (void)setupButtonOutletCollectionLandscape {
    for (UIButton *button in self.playButton) {
        if (button.tag == PlayButtonLandscape) {
            [self.view addSubview:button];
        }
    }
    for (UIButton *button in self.resetButton) {
        if (button.tag == ResetButtonLandscape) {
            [self.view addSubview:button];
        }
    }
}


- (void)setupButtonOutletCollectionPortrait {
    for (UIButton *button in self.playButton) {
        if (button.tag == PlayButtonLandscape) {
            [button removeFromSuperview];
        }
    }
    for (UIButton *button in self.resetButton) {
        if (button.tag == ResetButtonLandscape) {
            [button removeFromSuperview];
        }
    }
}


- (void)setupLabelOutletCollectionPortrait {
    for (UILabel *label in self.totalTimeLabel) {
        if (label.tag == 1) {
            [label removeFromSuperview];
        }
    }
}


- (void)setupLabelOutletCollectionLandsape {
    for (UILabel *label in self.totalTimeLabel) {
        if (label.tag == 1) {
            [self.view addSubview:label];
        }
    }
}

- (void)updateTabataArrays {
    
    if (![_tabataObject.tabataPickers isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"intervalsTabataArray"]]) {
        NSLog(@"diferit");
        [_tabataObject updateTabataPickersValues];
        [self resetTabataTimer];
        //
    }
    if (![_tabataObject.tabataColors isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"colorsTabataArray"]]) {
        NSLog(@"diferit");
        [self setupColors];
        [_tabataObject updateTabataColors];
        [self.circleTabataTimer setNeedsDisplay];
        [self.circleTabataTimer.timeLabel setNeedsDisplay];
        [self.circleTabataTimer.titleLabel setNeedsDisplay];
        //         [self setupTimerObject];
    }
    if (_tabataObject.soundIndex !=  [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedIndex"]) {
        _tabataObject.soundIndex = [[SettingsManagerImplementation sharedInstance]songNames];
    }
}


- (void)resetTabataTimer {
    
    if (_circleTabataTimer.elapsedTime > 0.1) {
        if (IS_IPHONE) {
            [self finishWorkout];
            [workoutDateStore save:workoutSession.completeWorkout andDuration:timerObj.elapsedTime completion:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    [workoutSession clear];
                }else {
                    NSLog(@"There was a problem saving your workout");
                }
            }];
        }
    }
    
    [timerObj reset];
    runOnce = false;
    _tabataObject.currentIndex = 0;
    for (UIButton *button in _playButton) {
        [button setSelected:timerObj.isRunning];
    }
    
    [_circleTabataTimer reset];
    [_circleRoundsEnumerate reset];
    [_circleCyclesEnumerate reset];
    _playButtonTitleLabel.text = @"Play".localized;
    [self setupTimerObject];
}


- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:AppUpdateThemeNotificationName object:nil];
}


- (void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AppUpdateThemeNotificationName object:nil];
}


- (void)updateUI {
    
    [[AppTheme sharedManager]loadSavedTheme];
    
    [_tabataPortraitView setBackgroundColor:[[AppTheme sharedManager]backgroundColor]];
    [_tabataLandscapeView setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    
    [_tabataPortraitView setAlpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[AppTheme sharedManager] labelColor],
       NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0]}];
    
    for (UILabel *label in _totalTimeLabel) {
        [label setTextColor:[[AppTheme sharedManager]labelColor]];
    }
    
    for (UIButton *button in self.upNextButton) {
        [button setTitleColor:[[AppTheme sharedManager]labelColor] forState:UIControlStateNormal];
        [button setTintColor:[[AppTheme sharedManager]labelColor]];
    }
    for (UILabel *label in self.nextWorkLabel) {
        [label setTextColor:[[AppTheme sharedManager]labelColor]];
    }
    
    [_roundsLeftTitleLabel setTextColor:[[AppTheme sharedManager]labelColor]];
    [_cyclesLeftTitleLabel setTextColor:[[AppTheme sharedManager]labelColor]];
    
    
    
    [_circleTabataTimer setBackgroundColor:[[AppTheme sharedManager] circleBackgroundColor]];
    [_circleRoundsEnumerate setBackgroundColor:[[AppTheme sharedManager] circleBackgroundColor]];
    [_circleCyclesEnumerate setBackgroundColor:[[AppTheme sharedManager] circleBackgroundColor]];
    
    
    [self.intervalsBarButtonItem setTintColor:[[AppTheme sharedManager]labelColor]];
    [self.settingsBarButtonItem setTintColor:[[AppTheme sharedManager]labelColor]];
    
}


- (void)setupColors {
    
    [_circleTabataTimer setPauseColor:[AppColorManager sharedInstanceManager].arrayWithTabataCircleColors[tabataCircleType]];
    [_circleTabataTimer setActiveColor:[AppColorManager sharedInstanceManager].arrayWithTabataCircleColors[tabataCircleType]];
    
    
    [_circleRoundsEnumerate setPauseColor:[AppColorManager sharedInstanceManager].arrayWithRoundsAndCyclesCirclesColors[0]];
    [_circleRoundsEnumerate setActiveColor:[AppColorManager sharedInstanceManager].arrayWithRoundsAndCyclesCirclesColors[0]];
    
    [_circleCyclesEnumerate setPauseColor:[AppColorManager sharedInstanceManager].arrayWithRoundsAndCyclesCirclesColors[1]];
    [_circleCyclesEnumerate setActiveColor:[AppColorManager sharedInstanceManager].arrayWithRoundsAndCyclesCirclesColors[1]];
    
    
    // Setup label colors
    
    [_circleTabataTimer.titleLabel setTextColor:[AppColorManager sharedInstanceManager].arrayWithTabataCircleColors[tabataCircleType]];
    [_circleTabataTimer.timeLabel setTextColor:[AppColorManager sharedInstanceManager].arrayWithTabataCircleColors[tabataCircleType]];
    
    for (UILabel *label in _circleRoundsEnumerate.roundsLabel) {
        [label setTextColor:[AppColorManager sharedInstanceManager].arrayWithRoundsAndCyclesCirclesColors[0]];
    }
    
    for (UILabel *label in _circleCyclesEnumerate.cyclesLabel) {
        [label setTextColor:[AppColorManager sharedInstanceManager].arrayWithRoundsAndCyclesCirclesColors[1]];
    }
}

- (void)setupLandscapeIPadConstraintsAndLayout {
    if (IS_IPAD || IS_IPAD_PRO) {
        [_circleTabataTimer setupLandscapeConstraints];
        
        self.heightConstraint = [self.heightConstraint updateMultiplier:0.78];
        self.widthConstraint = [self.widthConstraint updateMultiplier:0.58];
        self.horizontalConstraintCircleTabataTimer.constant = 20;
        self.topConstraintCircleTabataTimer.constant = 80;
        self.topConstraintCircleTabataTimer = [self.topConstraintCircleTabataTimer updatePriority:1000];
        
        if (IS_IPAD) {
            for (UIButton *button in _upNextButton) {
                [button.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:50]];
            }
            if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits ) {
                for (UILabel *label in _nextWorkLabel) {
                    [label setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:110]];
                }
            }else{
                for (UILabel *label in _nextWorkLabel) {
                    [label setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:160]];
                }
            }
            
        }
        else if(IS_IPAD_PRO){
            for (UIButton *button in _upNextButton) {
                [button.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:75]];
            }
            if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits ) {
                for (UILabel *label in _nextWorkLabel) {
                    [label setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:150]];
                }
            }else{
                for (UILabel *label in _nextWorkLabel) {
                    [label setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:200]];
                }
            }
        }
        
        
        if (IS_IPAD) {
            _verticalSpacingUpNextLabelConstraint.constant = -90;
             _bottomUpNextLabelConstraint.constant = 70;
        }else if(IS_IPAD_PRO){
            _verticalSpacingUpNextLabelConstraint.constant = -148;
            _bottomUpNextLabelConstraint.constant = 90;
        }
        
        self.heightCircleRoundsEnumerateConstraint = [self.heightCircleRoundsEnumerateConstraint updateMultiplier:0.25];
        self.widthCircleRoundsEnumerateConstraint = [self.widthCircleRoundsEnumerateConstraint updateMultiplier:0.18];
        
        self.heightCircleCyclesEnumerateConstraint = [self.heightCircleCyclesEnumerateConstraint updateMultiplier:0.25];
        self.widthCircleCyclesEnumerateConstraint = [self.widthCircleCyclesEnumerateConstraint updateMultiplier:0.18];
        
        if (IS_IPAD) {
            _topCircleRoundsEnumerateConstraint.constant = -510;
            _topCircleCyclesEnumerateConstraint.constant = -510;
            
        }else if(IS_IPAD_PRO){
            _topCircleRoundsEnumerateConstraint.constant = -715;
            _topCircleCyclesEnumerateConstraint.constant = -715;
        }
        
        _trailingTotalTimeLabelConstraint.active = false;
        _leadingTotalTimeLabelConstraint.constant = 20;
        _bottomTotalTimeLabelConstraint.constant = -40;
        
        for (UILabel *label in _totalTimeLabel) {
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:50]];
        }
        
        [_playButtonTitleLabel setHidden:true];
        [_resetButtonTitleLabel setHidden:true];
        
        
        if (IS_IPAD) {
            
            _leadingPlayButtonConstraint.constant = 190;
            _trailingResetButtonConstraint.constant = 190;
            
        }else if(IS_IPAD_PRO){
            
            _leadingPlayButtonConstraint.constant = 280;
            _trailingResetButtonConstraint.constant = 280;
        }
        
    }
}


- (void)setupPortraitIPadConstraintsAndLayout {
    if (IS_IPAD || IS_IPAD_PRO) {
        [_circleTabataTimer setupPortraitConstraints];
        
        self.heightConstraint = [self.heightConstraint updateMultiplier:0.55];
        self.widthConstraint = [self.widthConstraint updateMultiplier:0.68];
        self.horizontalConstraintCircleTabataTimer.constant = -40;
        self.topConstraintCircleTabataTimer.constant = -100;
        
        self.topConstraintCircleTabataTimer = [self.topConstraintCircleTabataTimer updatePriority:999];
        
        if (IS_IPAD) {
            for (UIButton *button in _upNextButton) {
                [button.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:30]];
            }
        }else if (IS_IPAD_PRO) {
            for (UIButton *button in _upNextButton) {
                [button.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:50]];
            }
        }
        
        
        for (UILabel *label in _nextWorkLabel) {
            [label setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:150]];
        }
        
        if (IS_IPAD) {
            _bottomUpNextLabelConstraint.constant = 190;
        }else if (IS_IPAD_PRO) {
            _bottomUpNextLabelConstraint.constant = 240;
        }
        _verticalSpacingUpNextLabelConstraint.constant = 7;
        
        self.heightCircleRoundsEnumerateConstraint = [self.heightCircleRoundsEnumerateConstraint updateMultiplier:0.2];
        self.widthCircleRoundsEnumerateConstraint = [self.widthCircleRoundsEnumerateConstraint updateMultiplier:0.24];
        
        self.heightCircleCyclesEnumerateConstraint = [self.heightCircleCyclesEnumerateConstraint updateMultiplier:0.2];
        self.widthCircleCyclesEnumerateConstraint = [self.widthCircleCyclesEnumerateConstraint updateMultiplier:0.24];
        
        if (IS_IPAD) {
            _topCircleRoundsEnumerateConstraint.constant = -110;
            _topCircleCyclesEnumerateConstraint.constant = -110;
        }else if (IS_IPAD_PRO) {
            _topCircleRoundsEnumerateConstraint.constant = -160;
            _topCircleCyclesEnumerateConstraint.constant = -160;
        }
        
        
        _leadingTotalTimeLabelConstraint.constant = 309;
        _trailingTotalTimeLabelConstraint.active = true;
        _bottomTotalTimeLabelConstraint.constant = -20;
        
        
        if (IS_IPAD) {
            for (UILabel *label in _totalTimeLabel) {
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:30]];
            }
        }else if (IS_IPAD_PRO) {
            for (UILabel *label in _totalTimeLabel) {
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:50]];
            }
        }
        
        [_playButtonTitleLabel setHidden:false];
        [_resetButtonTitleLabel setHidden:false];
        
        if (IS_IPAD) {
            _leadingPlayButtonConstraint.constant = 190;
            _trailingResetButtonConstraint.constant = 190;
        }else if (IS_IPAD_PRO) {
            _leadingPlayButtonConstraint.constant = 320;
            _trailingResetButtonConstraint.constant = 320;
        }
        
    }
}


- (void) flashMethod {
    [[SettingsManagerImplementation sharedInstance]flashlightOnOff];
}


- (void)showBlur {
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [_visualEffectView setHidden:false];
                         
//                         [_completedWorkoutLabel setTextColor:[[AppTheme sharedManager]labelColor]];
                         [_tabataCompletedLabel setTextColor:[UIColor whiteColor]];
                         
                         for (UIButton *button in _playButton) {
                             [button setHidden:true];
                         }
                         
                         for (UIButton *button in _resetButton) {
                             [button setHidden:true];
                         }
                         
                         for (UILabel *label in _totalTimeLabel) {
                             [label setHidden:true];
                         }
                         
                         [_playButtonTitleLabel setHidden:true];
                         [_resetButtonTitleLabel setHidden:true];
                         
                         [self.intervalsBarButtonItem setEnabled:false];
                         [self.intervalsBarButtonItem setTintColor:[UIColor clearColor]];

                         [self.settingsBarButtonItem setEnabled:false];
                         [self.settingsBarButtonItem setTintColor:[UIColor clearColor]];
                         [self.tabBarController.tabBar setHidden:true];
                         [self.navigationController.navigationBar setTitleTextAttributes:
                          @{NSForegroundColorAttributeName:[[AppTheme sharedManager] labelColor],
                            NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0]}];
                     }completion:^(BOOL finished) {
                         [self performSelector:@selector(hideBlur) withObject:nil afterDelay:1.0];
                     }];
}


- (void)setPortraitConstraintForSafeAreaDevices {
    if (Utilities.deviceHasAreaInsets) {
        _bottomTotalTimeConstraint.constant = -80;
    }
}

- (void)hideBlur {
    [UIView animateWithDuration:0.2
                     animations:^{
                         for (UIButton *button in _playButton) {
                             [button setHidden:false];
                         }
                         
                         for (UIButton *button in _resetButton) {
                             [button setHidden:false];
                         }
                         for (UILabel *label in _totalTimeLabel) {
                             [label setHidden:false];
                         }
                         
                         [_playButtonTitleLabel setHidden:false];
                         [_resetButtonTitleLabel setHidden:false];
                         
                         [self.tabBarController.tabBar setHidden:false];
                         [self.navigationController.navigationBar setTitleTextAttributes:
                          @{NSForegroundColorAttributeName:[[AppTheme sharedManager] labelColor],
                            NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0]}];
                         [self.intervalsBarButtonItem setEnabled:true];
                         [self.settingsBarButtonItem setEnabled:true];
                         [self.intervalsBarButtonItem setTintColor:[[AppTheme sharedManager]labelColor]];
                         [self.settingsBarButtonItem setTintColor:[[AppTheme sharedManager]labelColor]];
                         
                         [_visualEffectView setHidden:true];
                     }];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSInteger selectedIndex = tabBarController.selectedIndex;
    if (viewController != [self.tabBarController.viewControllers objectAtIndex:selectedIndex] && timerObj.isRunning) {
        timerObj.isRunning = true;
        [_circleTabataTimer stop];
        [_circleRoundsEnumerate stop];
        [_circleCyclesEnumerate stop];
        [timerObj playPause];
        for (UIButton *button in _playButton) {
            [button setSelected:timerObj.isRunning];
        }
    }
    return true;
}


- (void)dealloc {
    [self removeObserver];
    [_visualEffectView removeFromSuperview];
}


-(void)beginWorkout {
    if (IS_IPHONE) {
        [workoutSession start];
    }
}

-(void)finishWorkout {
    if (IS_IPHONE) {
        [workoutSession end];
    }
}

-(void)startStopButtonPressed {

    switch (workoutSession.state) {
        case notStarted:
            [self beginWorkout];
            break;
        case finished:
            [self beginWorkout];
            break;
        case active:
            [self finishWorkout];
            break;
        default:
            break;
    }
}


@end
