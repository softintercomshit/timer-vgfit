#import "SettingsManagerViewController.h"
#import "SettingsManagerTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "SettingsManager.h"
#import "AppTheme.h"
#import "SoundPickerViewController.h"
#import "TimeFormatViewController.h"
#import "ColorSchemeViewController.h"
#import "CustomNavigationBarUIView.h"
#import "MainUITabbarController.h"
#import <HealthKit/HealthKit.h>


static NSString *healthWarningMessage = @"App is not allowed to write data to the Health app. You can turn it on in the Health app";
static NSString *healthSynchronizeMessage = @"Workout data is synced with Health app";

@interface SettingsManagerViewController () <SoundPickerViewControllerDelegate,TimeFormatViewControllerDelegate,ColorSchemeViewControllerDelegate>
{
    NSString *inputSong;
    NSString *pickedValueForTimeFormat;
    NSString *pickedValueForPrepareTime;
    NSString *selectedValueForPrepareTime;
    NSInteger selectedIndex;
    NSInteger selectedIndexFormatTime;
    NSString *myString;
    NSString *currentThemeName;
    NSInteger indexVisualStyle;
    HealthKitSetupAssistant *healthKitSetupAssistant;
}


@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavigationBarView;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;

@end

BOOL willDissapearCorrectly = NO;


@implementation SettingsManagerViewController
{
    NSArray *settingsTitleLabels;
    NSArray *settingsTitleCenteredLabels;
    NSArray *settingsDescriptionLabels;
    NSArray *settingsDetailTextLabels;
    NSArray *settingsCircleThemeImages;
    NSArray *settingsCircleThemeTitles;
    __weak IBOutlet NSLayoutConstraint *heightConstraintForNavigationBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavbarBackgroundImage];
//    [self datafromArraysToLabels];
    self.title = @"Settings".localized;
    [self navBarButtonItems];
    [self loadDataSettingsManagerTableViewCells];
    healthKitSetupAssistant = [HealthKitSetupAssistant new];
    [self addObserver];
    [self addForegroundObserver];
//    NSLog(@"authorize kit status == %@", healthKitSetupAssistant.isAuthorized ? @"yes": @"no");
//     [[SettingsManager sharedManager] updateHealthKit:healthKitSetupAssistant.isAuthorized];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    willDissapearCorrectly = NO;
    [self updateUI];
    [[SettingsManager sharedManager]loadSettings];
//    NSLog(@"authorize kit status == %@", healthKitSetupAssistant.isAuthorized ? @"yes": @"no");
    currentThemeName = [[AppTheme sharedManager]themeNameForStyle:[[AppTheme sharedManager] getCurrentStyle]];
    [self dataUserDefaults];
    self.dataTableView.tableFooterView = [UIView new];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
    [_dataTableView reloadData];
}

-(void)addForegroundObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHealth) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)updateHealth {
    if (!healthKitSetupAssistant.isAuthorized) {
        [[SettingsManager sharedManager] updateHealthKit:NO];
        [[SettingsManager sharedManager]loadSettings];
    }
    [_dataTableView reloadData];
}

- (void)removeForegroundObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}



- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
}


-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self updateInterfaceOrientation:toInterfaceOrientation];
    //    [_dataFromTableView reloadData];
}


- (void)navBarButtonItems {
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_doneButton setTitle:@"Done".localized forState:UIControlStateNormal];
    _doneButton.titleLabel.font= [UIFont fontWithName:@"Avenir Next" size:18];
    [_doneButton setImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateNormal];
    [_doneButton setTintColor:[UIColor colorWithRed:241.0f/255.0f green:163.0f/255.0f blue:34.0f/255.0f alpha:1.0f]];
    [_doneButton setTitleColor:[UIColor colorWithRed:241.0f/255.0f green:163.0f/255.0f blue:34.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_doneButton sizeToFit];
    _doneButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _doneButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _doneButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [ _doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _customRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_doneButton];
    self.navigationItem.rightBarButtonItem = _customRightBarButtonItem;
    _leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel".localized style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonAction:)];
    self.navigationItem.leftBarButtonItem =_leftBarButtonItem;
}


-(void)loadDataSettingsManagerTableViewCells {
    NSUserDefaults *settingsSave = [NSUserDefaults standardUserDefaults];
    myString = [settingsSave objectForKey:@"dateToTransferSelectedSongToPlay"];
    selectedIndex = [ settingsSave integerForKey:@"selectedIndex"];
    pickedValueForTimeFormat = [settingsSave objectForKey:@"pickedValueForTimeFormat"];
    selectedIndexFormatTime = [settingsSave integerForKey:@"selectedIndexFormatTime"];
    currentThemeName = [settingsSave objectForKey:@"currentThemeKey"];
    indexVisualStyle = [settingsSave integerForKey:@"indexVisualStyle"];
}

#pragma mark - Navigation

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    
    if(!willDissapearCorrectly){
        [self cancelBarButtonAction:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SettingsManagerTableViewCell";
    SettingsManagerTableViewCell *cell = (SettingsManagerTableViewCell * )[self.dataTableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (SettingsManagerTableViewCell *) [nib objectAtIndex:0];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.dataTableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    cell.settingsSwitch.tag = indexPath.row;
    cell.volumeView.hidden = true;
    cell.minVolumeImageView.hidden = true;
    cell.maxVolumeImageView.hidden = true;
    cell.visualStyleView.hidden = YES;
    cell.titleLabelCentered.text = [cell cellSettingsTitle:indexPath.row];
    cell.descriptionLabel.text = [cell cellDescriptionText:indexPath.row];
    
    [cell setupCellSettings:indexPath.row];
    [cell.settingsSwitch addTarget:self action:@selector(switchesMethod:) forControlEvents:UIControlEventValueChanged];
    [cell setupSwitchStateSettings:indexPath.row];
    [cell setupTitlesAtIndex:indexPath.row setSoundTitle:myString.localized setTimerFormat:pickedValueForTimeFormat andVisualStyle:currentThemeName.localized];
    [cell setupVisualStyleAtIndex:indexPath.row visualStyleColor:[Utilities loadVisualStyleThemeIndexColor:indexVisualStyle]];
    return cell;
    
}


-(void)switchesMethod:(id)sender
{
    UISwitch* switchControl = sender;
    int tag = (int)switchControl.tag;
    //    NSLog(@"TAG = %d", tag);
    
    switch (tag)
    {
        case 0:
        {
            [[SettingsManager sharedManager] updateSound:switchControl.on];
            break;
        }
        case 3:
        {
            if (IS_IPHONE) {
            if (switchControl.isOn) {
                [healthKitSetupAssistant authorizeHealthKitWithCompletion:^(BOOL result, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!healthKitSetupAssistant.isAuthorized) {
                            [[SettingsManager sharedManager] updateHealthKit:NO];
                            [switchControl setOn:NO];
//                            NSLog(@"show apple health alert");
                            [self showMessages:healthWarningMessage.localized withTitle:@"WARNING!".localized];
                           
                        }else {
                            [switchControl setOn:YES];
                            [[SettingsManager sharedManager] updateHealthKit:YES];
                            [self showMessage:healthSynchronizeMessage.localized withTitle:@""];
//                             NSLog(@"show apple health alert 2");
                        }
                    });
                }];
            } else {
                [[SettingsManager sharedManager] updateHealthKit:NO];
                [switchControl setOn:NO];
            }
            } else {
                [[SettingsManager sharedManager] updateHealthKit:NO];
                [switchControl setOn:NO];
                [self showMessage:@"Apple Health is not available" withTitle:@""];
            }
            
             NSLog(@"authorize kit status == %@", healthKitSetupAssistant.isAuthorized ? @"yes": @"no");
            break;
        }
        case 4:
        {
            [[SettingsManager sharedManager] updateTextSpeech:switchControl.on];
            break;
        }
        case 5:
        {
            
            [[SettingsManager sharedManager] updateVibro:switchControl.on];
            if (switchControl.on) {
                if (IS_IPHONE)
                {
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                }
                else{
                    if (IS_IPHONE)
                    {
                        AudioServicesPlayAlertSound(NO);
                    }
                }
            }
            break;
        }
        case 6:
        {
            [[SettingsManager sharedManager] updateFlashLight:switchControl.on];
            if (switchControl.on) {
                if (IS_IPHONE){
                    [[SettingsManagerImplementation sharedInstance] flashlightOnOff];
                }
            }
            break;
        }
        case 7:
        {
            [[SettingsManager sharedManager] updateScreenFlash:switchControl.on];
            break;
        }
        case 8:
        {
            [[SettingsManager sharedManager] updateDucking:switchControl.on];
            break;
        }
        case 9:
        {
            [[SettingsManager sharedManager] updateRotation:switchControl.on];
            if(switchControl.on){
                [[NSNotificationCenter defaultCenter] postNotificationName:shouldRotate object:nil userInfo:nil];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:shouldNotRotate object:nil userInfo:nil];
            }
            break;
        }
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger  pickViewController = indexPath.row;
    SoundPickerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SoundPickerViewController"];
    TimeFormatViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeFormatViewController"];
    ColorSchemeViewController *vc3 = [self.storyboard instantiateViewControllerWithIdentifier:@"ColorSchemeViewController"];
    
    [[SettingsManager sharedManager]loadSettings];
    
    if (pickViewController == SoundScheme && ([[SettingsManager sharedManager]sound])) {
        vc.pickedSong = [myString mutableCopy];
        vc.pickedIndex = selectedIndex;
        vc.delegate = self;
        willDissapearCorrectly = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (pickViewController == TimeFormat) {
        vc2.selectedTimeFormat = [pickedValueForTimeFormat mutableCopy];
        vc2.selectedIndex = selectedIndexFormatTime;
        vc2.delegate = self;
        willDissapearCorrectly = YES;
        [self.navigationController pushViewController:vc2 animated:YES];
    }
    else if (pickViewController == VisualStyle) {
        vc3.selectedColorScheme = [currentThemeName mutableCopy];
        vc3.delegate = self;
        willDissapearCorrectly = YES;
        [self.navigationController pushViewController:vc3 animated:YES];
    }
}


-(void)dataFromColorSchemeViewControllerDelegate:(NSString *)data indexVisualStyleForView:(NSInteger)index
{
    currentThemeName = data;
    indexVisualStyle = index;
    [_dataTableView reloadData];
    
}


-(void)dataFromSoundPickerViewController:(NSString *)data indexFromSoundPickerViewController:(NSInteger)index
{
    inputSong=data;
    selectedIndex=index;
    myString = [inputSong stringByReplacingOccurrencesOfString:@".wav" withString:@""];
    myString = [myString stringByReplacingOccurrencesOfString:@"%@/" withString:@""];;
    
    [_dataTableView reloadData];
}


-(void)dataFromTimeFormatViewController:(NSString *)data indexFromTimeFormatViewController:(NSInteger)index
{
    pickedValueForTimeFormat=data;
    selectedIndexFormatTime=index;
    [_dataTableView reloadData];
}


-(IBAction)cancelBarButtonAction:(id)sender{
    willDissapearCorrectly = YES;
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dataUserDefaults
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:myString forKey:@"dateToTransferSelectedSongToPlay"];
    [defaults setInteger:selectedIndex forKey:@"selectedIndex"];
    [defaults setObject:pickedValueForTimeFormat forKey:@"pickedValueForTimeFormat"];
    [defaults setInteger:selectedIndexFormatTime forKey:@"selectedIndexFormatTime"];
    [defaults setObject:currentThemeName forKey:@"currentThemeKey"];
    [defaults setInteger:indexVisualStyle forKey:@"indexVisualStyle"];
}


- (IBAction)doneButtonAction:(id)sender{
    
    willDissapearCorrectly = YES;
    [self dataUserDefaults];
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:AppUpdateThemeNotificationName object:nil];
}


- (void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AppUpdateThemeNotificationName object:nil];
}


- (void)updateUI{
    [_customNavigationBarView setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    [_customNavigationBarViewIpad setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[AppTheme sharedManager] labelColor],
       NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]}];
    [self.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[[AppTheme sharedManager]labelColor],
                                                     NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]} forState:UIControlStateNormal];
}


-(void)showMessage:(NSString*)message withTitle:(NSString *)title {
    
    UIAlertController * alert =   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)showMessages:(NSString*)message withTitle:(NSString *)title {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel".localized style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }];
    
    UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"Open".localized style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (@available (iOS 10.0,*)) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"x-apple-health://"]];
        }
    }];
    
   
    [alert addAction:cancelAction];
    [alert addAction:openAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)dealloc{
    [self removeObserver];
    [self removeForegroundObserver];
}





@end
