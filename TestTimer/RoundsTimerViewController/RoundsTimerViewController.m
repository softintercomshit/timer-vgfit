//
//  RoundsTimerViewController.m
//  TestTimer
//
//  Created by Andrei on 11/6/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "RoundsTimerViewController.h"
#import "RoundsPortraitView.h"
#import "RoundsLandscapeView.h"
#import "CircleRoundsCount.h"
#import "CircleRoundsTimer.h"
#import "RoundsObject.h"
#import "RoundsIntervalsViewController.h"
#import "RoundsUpNextDataModel.h"
#import "SettingsManagerViewController.h"
#import "AppTheme.h"
#import "SettingsManagerImplementation.h"

@interface RoundsTimerViewController () <UITabBarControllerDelegate,UITabBarDelegate,UISplitViewControllerDelegate,TimerObjectDelegate>
{
    TimerObject *roundsTimerObject;
    RoundsCircleType roundsCircleType;
    RoundsUpNextDataModel *roundsUpNextDataModel;
    TimerFormats timerFormat;
    BOOL runRoundsOnce;
}


@property (weak, nonatomic) IBOutlet RoundsPortraitView *roundsPortraitView;
@property (weak, nonatomic) IBOutlet RoundsLandscapeView *roundsLandscapeView;
@property (weak, nonatomic) IBOutlet CircleRoundsTimer *circleRoundsTimer;
@property (weak, nonatomic) IBOutlet CircleRoundsCount *circleRoundsCount;

@property (strong, nonatomic) IBOutlet UILabel *roundsLeftTitleLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *intervalsBarButtonItem;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *totalTimeLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *playButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *resetButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *upNextButton;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nextWorkLabel;

@property (strong, nonatomic) RoundsObject *roundsObject;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalConstraintCircleRoundsTimer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintCircleRoundsTimer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomUpNextLabelConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCircleRoundsCountConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCircleRoundsCountConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCircleRoundsCountConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingTotalTimeLabelConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingTotalTimeLabelConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpacingUpNextLabelConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomTotalTimeLabelConstraint;

@property (weak, nonatomic) IBOutlet UILabel *playButtonTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *resetButtonTitleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingPlayButtonConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingResetButtonConstraint;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *roundsVisualEffectView;

@property (weak, nonatomic) IBOutlet UILabel *roundsCompletedLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roundsTotalTimeBottomConstraint;


@end

@implementation RoundsTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPAD_PRO || IS_IPAD) {
        self.circleRoundsCount.thickness = 14;
    }
    self.title = @"Rounds".localized;
    roundsUpNextDataModel = [RoundsUpNextDataModel new];
     [[SettingsManagerImplementation sharedInstance]readText:@" "];
    [self setupRoundsTimerObject];
    [self setupRoundsColors];
    [self.roundsLandscapeView setHidden:true];
    [self.navigationController setNavbarAppearence];
}


- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        [self.roundsPortraitView setHidden:true];
        [self.roundsLandscapeView setHidden:false];
        [self.tabBarController.tabBar setBackgroundImage:[UIImage new]];
        [self setupRoundsButtonOutletCollectionLandscape];
        [self setupRoundsLabelOutletCollectionLandscape];
        [self setupRoundsLandscapeIPadConstraintsAndLayout];
        [_circleRoundsTimer setupLandscapeConstraintsForSafeArea];
        
        
    }else{
        [self.roundsPortraitView setHidden:false];
        [self.roundsLandscapeView setHidden:true];
        [self setupRoundsButtonOutletCollectionPortrait];
        [self setupRoundsLabelOutletCollectionPortrait];
        [self setupRoundsPortraitIPadConstraintsAndLayout];
        [_circleRoundsTimer setupPortraitConstraintsForSafeArea];
        [self setPortraitConstraintForSafeAreaDevices];
    }
    
    [self.circleRoundsTimer setNeedsDisplay];
    [self.circleRoundsCount setNeedsDisplay];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateInterfaceOrientation:toInterfaceOrientation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [roundsTimerObject requestCurrentValues];
    [self setupUpNextTitlesTexts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.delegate = self;
    [self addObserver];
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [self.roundsPortraitView setHidden:true];
        [self.roundsLandscapeView setHidden:false];
        [self.tabBarController.tabBar setBackgroundImage:[UIImage new]];
        [self setupRoundsButtonOutletCollectionLandscape];
        [self setupRoundsLabelOutletCollectionLandscape];
        [self setupRoundsLandscapeIPadConstraintsAndLayout];
        [_circleRoundsTimer setupLandscapeConstraintsForSafeArea];
        
    }else{
        [self.roundsPortraitView setHidden:false];
        [self.roundsLandscapeView setHidden:true];
        [self setupRoundsButtonOutletCollectionPortrait];
        [self setupRoundsLabelOutletCollectionPortrait];
        [self setupRoundsPortraitIPadConstraintsAndLayout];
         [_circleRoundsTimer setupPortraitConstraintsForSafeArea];
        [self setPortraitConstraintForSafeAreaDevices];
        
    }
    
    [self.circleRoundsTimer setNeedsDisplay];
    [self.circleRoundsCount setNeedsDisplay];
    [self updateRoundsArrays];
    [self updateRoundsUI];
    [self.navigationController setNavbarAppearence];
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
        [_circleRoundsTimer setupLandscapeConstraintsForSafeArea];
    }else {
        [_circleRoundsTimer setupPortraitConstraintsForSafeArea];
    }
}


#pragma mark - RoundsTimerObj class delegates

-(void)timer:(TimerObject *)timerObject totalTimeString:(NSString *)totalTimeString currentTimeString:(NSString *)currentTimeString iterationCompleted:(BOOL)iterationCompleted needToPlaySound:(BOOL)needToPlaySound {
    
    for(UIButton *button in _playButton) {
         [button setSelected:roundsTimerObject.isRunning];
    }
    
    NSDictionary *item = _roundsObject.roundsCircleViewValuesArray[_roundsObject.currentIndex];
    [_circleRoundsTimer setRoundsSecondsValue:item[kRoundsTimeValue]];
    [_circleRoundsTimer setRoundsCircleType:roundsCircleType];
    _circleRoundsTimer.roundsTimeLabel.text = currentTimeString;
    
    [_circleRoundsTimer setTimerFormat:[SettingsManagerImplementation sharedInstance].timerFormat];
    
    for (UILabel *label in self.totalTimeLabel) {
        label.text = totalTimeString;
    }
    
    
    if (_roundsObject.currentIndex + 1 < _roundsObject.roundsCircleViewValuesArray.count) {
        [self setupUpNextTitlesTexts];
        NSDictionary *item = _roundsObject.roundsCircleViewValuesArray[_roundsObject.currentIndex + 1];
        RoundsCircleType circleType = [item[kRoundsCircleTypeKey]integerValue];
        [roundsUpNextDataModel setRoundsUpNextNames:[Utilities timeFormatString:item[kRoundsTimeValue]] andRoundsCircleType:circleType];
    }
    
    if (iterationCompleted) {
        
        [_circleRoundsTimer setNullValue];
        
        if ((roundsCircleType == RoundsRest && _roundsObject.roundsPickers[RoundsRestIndex].integerValue > 0) ||
            (_roundsObject.roundsPickers[RoundsIndexCountIndex].integerValue == 1 && roundsCircleType == RoundsWork) ||
            (roundsCircleType == RoundsWork && _roundsObject.roundsPickers[RoundsRestIndex].integerValue == 0)
            ) {
            _roundsObject.roundsLeft --;
            [_circleRoundsTimer reset];
        }
        
        [self setupRoundsTexts];
        
        _roundsObject.currentIndex++;
        
        if (_roundsObject.currentIndex > _roundsObject.roundsCircleViewValuesArray.count - 1) {
            [self showBlur];
            _roundsObject.currentIndex = 0;
            [_circleRoundsTimer reset];
            [_circleRoundsCount reset];
            [self setupRoundsTimerObject];
            return;
        }
        
        [_circleRoundsTimer reset];
        roundsCircleType = [_roundsObject.roundsCircleViewValuesArray[_roundsObject.currentIndex][kRoundsCircleTypeKey]integerValue];
        
        [self setupCirclesTotalTime];
        
        [_circleRoundsTimer start];
        
        if (roundsCircleType != RoundsPrepare) {
            [_circleRoundsCount start];
        }
        
        [[SettingsManagerImplementation sharedInstance]vibrate];
        NSThread *threadObj = [[NSThread alloc] initWithTarget:self selector:@selector(roundsFlashMethod) object:nil];
        [threadObj start];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SettingsManagerImplementation sharedInstance] playSound];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SettingsManagerImplementation sharedInstance] readText:[Utilities roundsTitle:roundsCircleType]];
        });
        [[SettingsManagerImplementation sharedInstance]rotateScreen];
        [[SettingsManagerImplementation sharedInstance]setRoundsScreenFlashByCircleTypeColor:roundsCircleType];
        
    }
    if (needToPlaySound) {
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


#pragma mark - IBActions outlets


- (IBAction)intervalsRoundsButtonAction:(id)sender {
    RoundsIntervalsViewController *roundsViewCon = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundsIntervalsViewController"];
    if (roundsTimerObject.isRunning) {
        roundsTimerObject.isRunning = true;
        [_circleRoundsTimer stop];
        [_circleRoundsCount stop];
        [roundsTimerObject playPause];
        for (UIButton *button in _playButton) {
            [button setSelected:roundsTimerObject.isRunning];
        }
    }
    [self.navigationController pushViewController:roundsViewCon animated:true];
}


- (IBAction)settingsRoundsButtonAction:(id)sender {
    
    SettingsManagerViewController *settingsMananagerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsManagerViewController"];
    
    [UIView transitionWithView:self.navigationController.view
                      duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:nil
                    completion:nil];
    if (roundsTimerObject.isRunning) {
        roundsTimerObject.isRunning = true;
        [_circleRoundsTimer stop];
        [_circleRoundsCount stop];
        [roundsTimerObject playPause];
        for (UIButton *button in _playButton) {
            [button setSelected:roundsTimerObject.isRunning];
        }
    }
    [self.navigationController pushViewController:settingsMananagerVC animated:false];
    
}


- (BOOL)runOnceMethod {
    if (runRoundsOnce == false) {
        [[SettingsManagerImplementation sharedInstance]vibrate];
        NSThread *threadObj = [[NSThread alloc] initWithTarget:self selector:@selector(roundsFlashMethod) object:nil];
        [threadObj start];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SettingsManagerImplementation sharedInstance] playSound];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [[SettingsManagerImplementation sharedInstance] readText:[Utilities roundsTitle:roundsCircleType]];
        });
        [[SettingsManagerImplementation sharedInstance]rotateScreen];
        [[SettingsManagerImplementation sharedInstance]setRoundsScreenFlashByCircleTypeColor:roundsCircleType];
        
        runRoundsOnce = true;
    }
    return runRoundsOnce;
}


- (IBAction)roundsPlayButtonAction:(id)sender {
    if (!roundsTimerObject.isRunning) {
        [_circleRoundsTimer start];
        _playButtonTitleLabel.text = @"Pause".localized;
        [self runOnceMethod];
        
        if (roundsCircleType != RoundsPrepare) {
            [_circleRoundsCount start];
        }
    }else{
        _playButtonTitleLabel.text = @"Resume".localized;
        [_circleRoundsCount stop];
        [_circleRoundsTimer stop];
    }
    [roundsTimerObject playPause];
    
    for (UIButton *button in _playButton) {
        [button setSelected:roundsTimerObject.isRunning];
    }
    
}


- (IBAction)roundsResetButtonAction:(id)sender {
    
    if (_circleRoundsTimer.elapsedTime>0.1) {
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
                                             [self resetRoundsTimer];
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

- (void)setupRoundsTimerObject {
    
    self.roundsObject = [RoundsObject new];
    [self.roundsObject setupRoundsTimer];
    
    roundsCircleType = [_roundsObject.roundsCircleViewValuesArray[_roundsObject.currentIndex][kRoundsCircleTypeKey]integerValue];
    
    roundsTimerObject = [[TimerObject alloc] initWithCountDownTimerModeAndTimerFormat:[[SettingsManagerImplementation sharedInstance]timerFormat] timerIntervalsArray:self.roundsObject.valuesForTimer];
    
    [roundsTimerObject setDelegate:self];
    [roundsTimerObject setResetAfterEnding:false];
    [roundsTimerObject requestInitialValues];
    
    
    [self setupRoundsTexts];
    [self setupCirclesTotalTime];
    [self setupUpNextTitlesTexts];
}

- (void)setupCirclesTotalTime {
    
    [_circleRoundsTimer setTotalTime:[_roundsObject.roundsCircleViewValuesArray[_roundsObject.currentIndex][kRoundsTimeValue]doubleValue]];
    [_circleRoundsCount setTotalTime:_roundsObject.roundsTotalTime];
}


- (void)setupRoundsTexts {
    for (UILabel *label in _circleRoundsCount.roundsCountLabel) {
        [label setText:[NSString stringWithFormat:@"%ld",(long)_roundsObject.roundsLeft]];
        [label setTextColor:[AppColorManager sharedInstanceManager].arrayWithRoundsCountCircleColor[0]];
    }
}


- (void)setupUpNextTitlesTexts {
    
    for (UIButton *button in self.upNextButton) {
        [button setTitle:roundsUpNextDataModel.roundsUpNextString forState:UIControlStateNormal];
    }
    
    for (UILabel *label in self.nextWorkLabel) {
        [label setText:roundsUpNextDataModel.roundsNextWorkType];
    }
}


- (void)setupRoundsButtonOutletCollectionLandscape {
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


- (void)setupRoundsLabelOutletCollectionLandscape {
    for (UILabel *label in self.totalTimeLabel) {
        if (label.tag == 1) {
            [self.view addSubview:label];
        }
    }
}


- (void)setupRoundsButtonOutletCollectionPortrait {
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


- (void)setupRoundsLabelOutletCollectionPortrait {
    for (UILabel *label in self.totalTimeLabel) {
        if (label.tag == 1) {
            [label removeFromSuperview];
        }
    }
}


- (void)updateRoundsArrays {
    
    if (![_roundsObject.roundsPickers isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"intervalsRoundsArray"]]) {
        NSLog(@"diferit");
        [_roundsObject updateRoundsPickersValues];
        [self resetRoundsTimer];
    }
    if (![_roundsObject.roundsColors isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"colorsRoundsArray"]]) {
        NSLog(@"diferit");
        [self setupRoundsColors];
        [_roundsObject updateRoundsColorsValues];
        [self.circleRoundsTimer setNeedsDisplay];
        [self.circleRoundsTimer.roundsTimeLabel setNeedsDisplay];
        [self.circleRoundsTimer.roundsTitleLabel setNeedsDisplay];
    }
    if (_roundsObject.soundIndex !=  [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedIndex"]) {
        _roundsObject.soundIndex = [[SettingsManagerImplementation sharedInstance]songNames];
    }
}


- (void)resetRoundsTimer {
    
    [roundsTimerObject reset];
    runRoundsOnce = false;
    _roundsObject.currentIndex = 0;
    for (UIButton *button in _playButton) {
        [button setSelected:roundsTimerObject.isRunning];
    }
    
    [_circleRoundsTimer reset];
    [_circleRoundsCount reset];
    _playButtonTitleLabel.text = @"Play".localized;
    [self setupRoundsTimerObject];
}


- (void)addObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRoundsUI) name:AppUpdateThemeNotificationName object:nil];
}


- (void)removeObserver {
    
     [[NSNotificationCenter defaultCenter]removeObserver:self name:AppUpdateThemeNotificationName object:nil];
    
}

- (void)updateRoundsUI {
    
    [[AppTheme sharedManager]loadSavedTheme];
    
    [_roundsPortraitView setBackgroundColor:[[AppTheme sharedManager]backgroundColor]];
    [_roundsLandscapeView setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    
    [_roundsPortraitView setAlpha:1.0];
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

    
    [_circleRoundsTimer setBackgroundColor:[[AppTheme sharedManager] circleBackgroundColor]];
    [_circleRoundsCount setBackgroundColor:[[AppTheme sharedManager] circleBackgroundColor]];
    
    
    [self.intervalsBarButtonItem setTintColor:[[AppTheme sharedManager]labelColor]];
    [self.settingsBarButtonItem setTintColor:[[AppTheme sharedManager]labelColor]];
}


- (void)setupRoundsColors {
    
    [_circleRoundsTimer setPauseColor:[AppColorManager sharedInstanceManager].arrayWithRoundsCircleColors[roundsCircleType]];
    [_circleRoundsTimer setActiveColor:[AppColorManager sharedInstanceManager].arrayWithRoundsCircleColors[roundsCircleType]];
    
    
    [_circleRoundsCount setPauseColor:[AppColorManager sharedInstanceManager].arrayWithRoundsCountCircleColor[0]];
    [_circleRoundsCount setActiveColor:[AppColorManager sharedInstanceManager].arrayWithRoundsCountCircleColor[0]];
    
    
    // Setup label colors
    
    [_circleRoundsTimer.roundsTitleLabel setTextColor:[AppColorManager sharedInstanceManager].arrayWithRoundsCircleColors[roundsCircleType]];
   [_circleRoundsTimer.roundsTimeLabel setTextColor:[AppColorManager sharedInstanceManager].arrayWithRoundsCircleColors[roundsCircleType]];
    
    for (UILabel *label in _circleRoundsCount.roundsCountLabel) {
        [label setTextColor:[AppColorManager sharedInstanceManager].arrayWithRoundsCountCircleColor[0]];
    }
}

- (void)setupRoundsLandscapeIPadConstraintsAndLayout {
    
    if (IS_IPAD || IS_IPAD_PRO) {
        [_circleRoundsTimer setupLandscapeConstraints];
        
        self.heightConstraint = [self.heightConstraint updateMultiplier:0.78];
        self.widthConstraint = [self.widthConstraint updateMultiplier:0.58];
        self.horizontalConstraintCircleRoundsTimer.constant = 20;
        self.topConstraintCircleRoundsTimer.constant = 80;
        self.topConstraintCircleRoundsTimer = [self.topConstraintCircleRoundsTimer updatePriority:1000];
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
        
        self.heightCircleRoundsCountConstraint = [self.heightCircleRoundsCountConstraint updateMultiplier:0.25];
        self.widthCircleRoundsCountConstraint = [self.widthCircleRoundsCountConstraint updateMultiplier:0.18];
        
        
        if (IS_IPAD) {
            
            _topCircleRoundsCountConstraint.constant = -510;
            
        }else if(IS_IPAD_PRO){
            
            _topCircleRoundsCountConstraint.constant = -715;
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

- (void)setupRoundsPortraitIPadConstraintsAndLayout {
    if (IS_IPAD || IS_IPAD_PRO) {
        [_circleRoundsTimer setupPortraitConstraints];
        
        self.heightConstraint = [self.heightConstraint updateMultiplier:0.55];
        self.widthConstraint = [self.widthConstraint updateMultiplier:0.68];
        self.horizontalConstraintCircleRoundsTimer.constant = -40;
        self.topConstraintCircleRoundsTimer.constant = -100;
        
        self.topConstraintCircleRoundsTimer = [self.topConstraintCircleRoundsTimer updatePriority:999];
        
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
        
        self.heightCircleRoundsCountConstraint = [self.heightCircleRoundsCountConstraint updateMultiplier:0.2];
        self.widthCircleRoundsCountConstraint = [self.widthCircleRoundsCountConstraint updateMultiplier:0.24];
        
        
        if (IS_IPAD) {
            _topCircleRoundsCountConstraint.constant = -110;
        }else if (IS_IPAD_PRO) {
            _topCircleRoundsCountConstraint.constant = -160;
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


- (void)setPortraitConstraintForSafeAreaDevices {
    if (Utilities.deviceHasAreaInsets) {
        _roundsTotalTimeBottomConstraint.constant = -80;
    }
}


- (void)roundsFlashMethod {
      [[SettingsManagerImplementation sharedInstance]flashlightOnOff];
}


- (void)showBlur {
    [UIView animateWithDuration:0.2
                     animations:^{
                         [_roundsVisualEffectView setHidden:false];
                         [_roundsCompletedLabel setTextColor:[UIColor whiteColor]];
                         
                         
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
                         
                         [_roundsVisualEffectView setHidden:true];
                     }];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController != [self.tabBarController.viewControllers objectAtIndex:1] && roundsTimerObject.isRunning) {
        roundsTimerObject.isRunning = true;
        [_circleRoundsTimer stop];
        [_circleRoundsCount stop];
        [roundsTimerObject playPause];
        for (UIButton *button in _playButton) {
            [button setSelected:roundsTimerObject.isRunning];
        }
    }
    return true;
}


- (void)dealloc {
    [self removeObserver];
    [_roundsVisualEffectView removeFromSuperview];
}



@end
