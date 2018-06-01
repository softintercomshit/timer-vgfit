//
//  StopwatchTimerViewController.m
//  TestTimer
//
//  Created by Andrei on 11/6/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//


#import "StopwatchTimerViewController.h"
#import "CircleStopwatchTimer.h"
#import "StopwatchPortraitView.h"
#import "StopwatchLandscapeView.h"
#import "StopwatchObject.h"
#import "StopWatchIntervalsViewController.h"
#import "StopwatchUpNextDataModel.h"
#import "SettingsManagerViewController.h"
#import "AppTheme.h"
#import "SettingsManagerImplementation.h"



@interface StopwatchTimerViewController () <UITabBarControllerDelegate, UITabBarDelegate, UISplitViewControllerDelegate, TimerObjectDelegate>
{
    TimerObject *stopwatchTimerObject;
    StopwatchCircleType stopwatchCircleType;
    StopwatchUpNextDataModel *stopwatchUpNextDataModel;
    TimerFormats timerFormat;
    BOOL runStopwatchOnce;
}

@property (weak, nonatomic) IBOutlet StopwatchLandscapeView *stopwatchLandscapeView;
@property (weak, nonatomic) IBOutlet StopwatchPortraitView *stopwatchPortraitView;
@property (weak, nonatomic) IBOutlet CircleStopwatchTimer *circleStopwatchTimer;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *intervalsBarButtonItem;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *playButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *resetButton;
@property (weak, nonatomic) IBOutlet UILabel *playTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *resetTitleLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *upNextButton;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nextWorkLabel;

@property (strong, nonatomic) StopwatchObject *stopwatchObject;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalConstraintCircleStopwatchTimer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintCircleStopwatchTimer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomUpNextLabelConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacingUpNextLabelConstraint;

@property (weak, nonatomic) IBOutlet UILabel *playButtonTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *resetButtonTitleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingPlayButtonConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingResetButtonConstraint;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *stopwatchVisualEffectView;

@property (weak, nonatomic) IBOutlet UILabel *completedLabel;

@end


@implementation StopwatchTimerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Stopwatch".localized;
    stopwatchUpNextDataModel = [StopwatchUpNextDataModel new];
    [[SettingsManagerImplementation sharedInstance]readText:@" "];
    [self setupStopwatchTimerObject];
    [self.stopwatchLandscapeView setHidden:true];
    [self.navigationController setNavbarAppearence];
}


- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        
        [self.stopwatchPortraitView setHidden:true];
        [self.stopwatchLandscapeView setHidden:false];
        [self.tabBarController.tabBar setBackgroundImage:[UIImage new]];
        [self setupStopwatchButtonOutletCollectionLandscape];
        [self setupStopwatchLandscapeIPadConstraintsAndLayout];
        [_circleStopwatchTimer setupLandscapeConstraintsForSafeAreaDevice];

    }else{
       
        [self.stopwatchPortraitView setHidden:false];
        [self.stopwatchLandscapeView setHidden:true];
        [self setupStopwatchButtonOutletCollectionPortrait];
        [self setupStopwatchPortraitIPadConstraintsAndLayout];
        [_circleStopwatchTimer setupPortraitConstraintsForSafeAreaDevice];
        
    }
 
    [self.circleStopwatchTimer setNeedsDisplay];
    
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateInterfaceOrientation:toInterfaceOrientation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [stopwatchTimerObject requestCurrentStopwatchValues];
    [self setupNextTitleTexts];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserver];
    self.tabBarController.delegate = self;
    if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        
        [self.stopwatchPortraitView setHidden:true];
        [self.stopwatchLandscapeView setHidden:false];
        [self setupStopwatchButtonOutletCollectionLandscape];
        [self setupStopwatchLandscapeIPadConstraintsAndLayout];
        [_circleStopwatchTimer setupLandscapeConstraintsForSafeAreaDevice];


    }else{
        [self.stopwatchPortraitView setHidden:false];
        [self.stopwatchLandscapeView setHidden:true];
        [self setupStopwatchButtonOutletCollectionPortrait];
        [self setupStopwatchPortraitIPadConstraintsAndLayout];
        [_circleStopwatchTimer setupPortraitConstraintsForSafeAreaDevice];
    
        
        
    }
    [self.circleStopwatchTimer setNeedsDisplay];
    [self updateStopwatchArray];
    [self updateStopwatchUI];
    [self.navigationController setNavbarAppearence];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self updateInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
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
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [_circleStopwatchTimer setupLandscapeConstraintsForSafeAreaDevice];
    }else {
        [_circleStopwatchTimer setupPortraitConstraintsForSafeAreaDevice];
    }
}


-(void)timer:(TimerObject *)timerObject isPrepare:(BOOL)isPrepare lapCompleted:(BOOL)lapCompleted timeString:(NSString *)timeString{
    
    for(UIButton *button in _playButton) {
        [button setSelected:stopwatchTimerObject.isRunning];
    }
    
    [_circleStopwatchTimer.stopwatchTimeLabel setText:timeString];
    [_circleStopwatchTimer setStopwatchCircleType:stopwatchCircleType];
    
    [_circleStopwatchTimer setTimerFormat:[SettingsManagerImplementation sharedInstance].timerFormat];
    
    if (self.stopwatchObject.currentIndex + 1 < self.stopwatchObject.stopwatchCircleViewValuesArray.count) {
        [self setupNextTitleTexts];
        NSDictionary *item = self.stopwatchObject.stopwatchCircleViewValuesArray[_stopwatchObject.currentIndex + 1];
        StopwatchCircleType circleType = [item[kStopwatchCircleTypeKey]integerValue];
        [stopwatchUpNextDataModel setStopwatchUpNextNames:[Utilities timeFormatString:item[kStopwatchTimeValue]] andStopwatchCircleType:circleType];
    }

    if (_circleStopwatchTimer.totalTime - _circleStopwatchTimer.elapsedTime <= 0.01 && _stopwatchObject.stopwatchPickers[StopwatchPrepare].integerValue > 0) {
        [self.circleStopwatchTimer reset];
        [self.circleStopwatchTimer setTotalTime:_stopwatchObject.stopwatchPickers[StopwatchTimeLap].integerValue];
        stopwatchCircleType = [self.stopwatchObject.stopwatchCircleViewValuesArray[StopwatchTimeLap][kStopwatchCircleTypeKey]integerValue];
        [self setupStopwatchTimeLapColors];
        [self.circleStopwatchTimer start];
        [[SettingsManagerImplementation sharedInstance]vibrate];
        NSThread *threadObj = [[NSThread alloc] initWithTarget:self selector:@selector(stopwatchFlashMethod) object:nil];
        [threadObj start];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SettingsManagerImplementation sharedInstance] playSound];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SettingsManagerImplementation sharedInstance] readText:[Utilities stopwatchTitle:stopwatchCircleType]];
        });
        [[SettingsManagerImplementation sharedInstance]rotateScreen];
        [[SettingsManagerImplementation sharedInstance]setStopwatchScreenFlashByCircleTypeColor];
        
       
        
    }
   
    if (lapCompleted) { 
        
        [self.circleStopwatchTimer reset];
        
        [self.circleStopwatchTimer setTotalTime:_stopwatchObject.stopwatchPickers[StopwatchTimeLap].integerValue];
        stopwatchCircleType = [self.stopwatchObject.stopwatchCircleViewValuesArray[StopwatchTimeLap][kStopwatchCircleTypeKey]integerValue];
        [self setupStopwatchTimeLapColors];
        [[SettingsManagerImplementation sharedInstance]vibrate];
        NSThread *threadObj = [[NSThread alloc] initWithTarget:self selector:@selector(stopwatchFlashMethod) object:nil];
        [threadObj start];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SettingsManagerImplementation sharedInstance] playSound];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SettingsManagerImplementation sharedInstance] readText:[Utilities stopwatchTitle:stopwatchCircleType]];
        });
        [[SettingsManagerImplementation sharedInstance]rotateScreen];
        [[SettingsManagerImplementation sharedInstance]setStopwatchScreenFlashByCircleTypeColor];
        
        [self.circleStopwatchTimer start];
    }
    
}


- (void)timer:(TimerObject *)timerObject lapTime:(NSTimeInterval)lapTime totalTime:(NSTimeInterval)totalTime isPrepare:(BOOL)isPrepare {
    
}





#pragma mark - Actions methods for bar button items

- (BOOL)runOnceMethod {
    if (runStopwatchOnce == false) {
        [[SettingsManagerImplementation sharedInstance]vibrate];
        NSThread *threadObj = [[NSThread alloc] initWithTarget:self selector:@selector(stopwatchFlashMethod) object:nil];
        [threadObj start];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SettingsManagerImplementation sharedInstance] playSound];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SettingsManagerImplementation sharedInstance] readText:[Utilities stopwatchTitle:stopwatchCircleType]];
        });
        [[SettingsManagerImplementation sharedInstance]rotateScreen];
        [[SettingsManagerImplementation sharedInstance]setStopwatchScreenFlashByCircleTypeColor];
        
        runStopwatchOnce = true;
    }
    return runStopwatchOnce;
}

- (IBAction)stopwatchPlayButtonAction:(id)sender {
    
    if (!stopwatchTimerObject.isRunning) {
        [self runOnceMethod];
        [_circleStopwatchTimer start];
        _playButtonTitleLabel.text = @"Pause".localized;
        
    }else{
        [_circleStopwatchTimer stop];
        _playButtonTitleLabel.text = @"Resume".localized;
    }
    [stopwatchTimerObject playPause];
    
    for (UIButton *button in _playButton) {
        [button setSelected:stopwatchTimerObject.isRunning];
    }
    
}




- (IBAction)stopwatchResetButtonAction:(id)sender {
    if (_circleStopwatchTimer.elapsedTime > 0.1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"Do you want to reset the timer?".localized
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* cancelAlertAction = [UIAlertAction actionWithTitle:@"Cancel".localized
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction *action)
                                            {
                                                
                                                NSLog(@"Cancel action");
                                            }];
        UIAlertAction* yesAlertAction = [UIAlertAction actionWithTitle:@"Yes".localized
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action)
                                         {
                                             [self resetStopwatchTimer];
                                             NSLog(@"Yes action");
                                         }];
        
        [alertController addAction:cancelAlertAction];
        [alertController addAction:yesAlertAction];
        alertController.view.backgroundColor = [UIColor whiteColor];
        alertController.view.layer.cornerRadius = 25;
        [self presentViewController:alertController animated:false completion:nil];
    }
}



- (IBAction)settingsButtonAction:(id)sender {
    SettingsManagerViewController *settingsMananagerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsManagerViewController"];
    
    [UIView transitionWithView:self.navigationController.view
                      duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:nil
                    completion:nil];
    if (stopwatchTimerObject.isRunning) {
        stopwatchTimerObject.isRunning = true;
        [_circleStopwatchTimer stop];
        [stopwatchTimerObject playPause];
        for (UIButton *button in _playButton) {
            [button setSelected:stopwatchTimerObject.isRunning];
        }
    }
    [self.navigationController pushViewController:settingsMananagerVC animated:false];
    
    
}


- (IBAction)intervalsButtonAction:(id)sender {
    
    StopWatchIntervalsViewController  *stopwatchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StopWatchIntervalsViewController"];
    if (stopwatchTimerObject.isRunning) {
        stopwatchTimerObject.isRunning = true;
        [_circleStopwatchTimer stop];
        [stopwatchTimerObject playPause];
        for (UIButton *button in _playButton) {
            [button setSelected:stopwatchTimerObject.isRunning];
        }
    }
    [self.navigationController pushViewController:stopwatchVC animated:true];
}

#pragma mark - Other methods

- (void)setupStopwatchTimerObject {
    
    self.stopwatchObject = [StopwatchObject new];
    [self.stopwatchObject setupStopwatchTimer];
    
    stopwatchTimerObject = [[TimerObject alloc] initWithCountUpTimerModeAndTimerFormat:[[SettingsManagerImplementation sharedInstance]timerFormat] prepareTime:self.stopwatchObject.stopwatchPickers[StopwatchPrepare].integerValue
                                                                               lapTime:self.stopwatchObject.stopwatchPickers[StopwatchTimeLap].integerValue];
    
    if (self.stopwatchObject.stopwatchPickers[StopwatchPrepare].integerValue == 0) {
        [self.circleStopwatchTimer setTotalTime:[self.stopwatchObject.stopwatchCircleViewValuesArray[StopwatchTimeLap][kStopwatchTimeValue]doubleValue]];
        stopwatchCircleType = [self.stopwatchObject.stopwatchCircleViewValuesArray[StopwatchTimeLap][kStopwatchCircleTypeKey]integerValue];
        [self setupStopwatchTimeLapColors];
    } else {
        [self.circleStopwatchTimer setTotalTime:[self.stopwatchObject.stopwatchCircleViewValuesArray[StopwatchPrepare][kStopwatchTimeValue]doubleValue]];
        stopwatchCircleType = [self.stopwatchObject.stopwatchCircleViewValuesArray[StopwatchPrepare][kStopwatchCircleTypeKey]integerValue];
        [self setupStopwatchPrepareColors];
    }
    
    
    [stopwatchTimerObject setDelegate:self];
    [stopwatchTimerObject requestInitialValues];
    
    [self setupNextTitleTexts];
    
}


- (void)setupNextTitleTexts {
    for (UIButton *button in self.upNextButton) {
        [button setTitle:stopwatchUpNextDataModel.stopwatchUpNextString forState:UIControlStateNormal];
    }
    
    for (UILabel *label in self.nextWorkLabel) {
        [label setText:stopwatchUpNextDataModel.stopwatchNextWorkType];
    }
}


- (void)setupStopwatchButtonOutletCollectionLandscape {
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


- (void)setupStopwatchButtonOutletCollectionPortrait{
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


- (void)resetStopwatchTimer {
    
    [self.circleStopwatchTimer reset];
    runStopwatchOnce = false;
    for (UIButton *button in _playButton) {
        [button setSelected:stopwatchTimerObject.isRunning];
    }
    _playButtonTitleLabel.text = @"Play".localized;
    [self setupStopwatchTimerObject];
    
}


- (void)addObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStopwatchUI) name:AppUpdateThemeNotificationName object:nil];
}


- (void)updateStopwatchUI {
    
    [[AppTheme sharedManager]loadSavedTheme];
    [_stopwatchPortraitView setBackgroundColor:[[AppTheme sharedManager]backgroundColor]];
    [_stopwatchLandscapeView setBackgroundColor:[[AppTheme sharedManager]backgroundColor]];
    [_stopwatchPortraitView setAlpha:1.0];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[AppTheme sharedManager] labelColor],
       NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0]}];
    
    for (UIButton *button in self.upNextButton) {
        [button setTitleColor:[[AppTheme sharedManager]labelColor] forState:UIControlStateNormal];
        [button setTintColor:[[AppTheme sharedManager]labelColor]];
    }
    for (UILabel *label in self.nextWorkLabel) {
        [label setTextColor:[[AppTheme sharedManager]labelColor]];
    }
    
    [_circleStopwatchTimer setBackgroundColor:[[AppTheme sharedManager] circleBackgroundColor]];
    [self.intervalsBarButtonItem setTintColor:[[AppTheme sharedManager]labelColor]];
    [self.settingsBarButtonItem setTintColor:[[AppTheme sharedManager]labelColor]];
}


- (void)updateStopwatchArray {
    
    if (![_stopwatchObject.stopwatchPickers isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"intervalsStopwatchArray"]]) {
        NSLog(@"diferit");
        [_stopwatchObject updateStopwatchPickersValues];
        [self resetStopwatchTimer];
    }
    
    if(_stopwatchObject.soundIndex !=  [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedIndex"]){
        _stopwatchObject.soundIndex = [[SettingsManagerImplementation sharedInstance]songNames];
    }
}

- (void)setupStopwatchPrepareColors {
    
    [_circleStopwatchTimer setPauseColor:[Utilities getYellowColor]];
    [_circleStopwatchTimer setActiveColor:[Utilities getYellowColor]];
    [_circleStopwatchTimer.stopwatchTimeLabel setTextColor:[Utilities getYellowColor]];
    [_circleStopwatchTimer.stopwatchTitleLabel setTextColor:[Utilities getYellowColor]];
}


- (void)setupStopwatchTimeLapColors {
    
    [_circleStopwatchTimer setPauseColor:[Utilities getGreenColor]];
    [_circleStopwatchTimer setActiveColor:[Utilities getGreenColor]];
    [_circleStopwatchTimer.stopwatchTimeLabel setTextColor:[Utilities getGreenColor]];
    [_circleStopwatchTimer.stopwatchTitleLabel setTextColor:[Utilities getGreenColor]];
    
}


- (void)removeObserver {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AppUpdateThemeNotificationName object:nil];
    
}


- (void)setupStopwatchLandscapeIPadConstraintsAndLayout {
    if (IS_IPAD || IS_IPAD_PRO) {
        [_circleStopwatchTimer setupLandscapeConstraints];
        
        self.heightConstraint = [self.heightConstraint updateMultiplier:0.78];
        self.widthConstraint = [self.widthConstraint updateMultiplier:0.58];
        self.horizontalConstraintCircleStopwatchTimer.constant = 20;
        self.topConstraintCircleStopwatchTimer.constant = 80;
        self.topConstraintCircleStopwatchTimer = [self.topConstraintCircleStopwatchTimer updatePriority:1000];
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
        } else if(IS_IPAD_PRO){
            for (UIButton *button in _upNextButton) {
                [button.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:75]];
            }
            if([SettingsManagerImplementation sharedInstance].timerFormat == MilisecondsTwoDigits) {
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


- (void)setupStopwatchPortraitIPadConstraintsAndLayout {
    if (IS_IPAD || IS_IPAD_PRO) {
        [_circleStopwatchTimer setupPortraitConstraints];
        
        self.heightConstraint = [self.heightConstraint updateMultiplier:0.55];
        self.widthConstraint = [self.widthConstraint updateMultiplier:0.68];
        self.horizontalConstraintCircleStopwatchTimer.constant = -40;
 
        self.topConstraintCircleStopwatchTimer.constant = -100;
        
        self.topConstraintCircleStopwatchTimer = [self.topConstraintCircleStopwatchTimer updatePriority:999];
        
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


- (void)stopwatchFlashMethod {
    [[SettingsManagerImplementation sharedInstance]flashlightOnOff];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController != [self.tabBarController.viewControllers objectAtIndex:2] && stopwatchTimerObject.isRunning) {
        stopwatchTimerObject.isRunning = true;
        [_circleStopwatchTimer stop];
        [stopwatchTimerObject playPause];
        for (UIButton *button in _playButton) {
            [button setSelected:stopwatchTimerObject.isRunning];
        }
    }
    return true;
}


- (void)dealloc {
    
    [self removeObserver];
}



@end
