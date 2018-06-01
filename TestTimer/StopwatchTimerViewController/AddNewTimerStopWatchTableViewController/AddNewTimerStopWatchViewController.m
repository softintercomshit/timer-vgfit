
#import "AddNewTimerStopWatchViewController.h"
#import "CustomIntervalsTableViewCell.h"
#import "PrepareTimeViewController.h"
#import "SoundEachViewController.h"
#import "AppTheme.h"
#import "CustomNavigationBarUIView.h"



@interface AddNewTimerStopWatchViewController ()<PrepareTimeViewControllerDelegate,SoundEachViewControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavBarView;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightNavigationBarConstraint;

@end


@implementation AddNewTimerStopWatchViewController {
    NSArray *stopWatchTitlesForIntervals;
    NSArray *stopWatchDescriptionForIntervals;
    NSArray *stopWatchValuesForIntervals;
    UITapGestureRecognizer *tapRecognizer;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _addWorkoutTextfield.text = _inputTitleStopwatchWorkout;
    _addWorkoutTextfield.placeholder = @"Stopwatch workout".localized;
    [self.uiViewForTextField addSubview:_addWorkoutTextfield];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    self.title = @"Stopwatch".localized;
    [self dataInTabataAddNewTimerTableViewCells];
    [self customBarButtonItems];
    [self updateUI];
    _fullSecondsPrepareTime = 0;
    _secondsSoundTime = 5;
    
    if (self.isEditingTimer) {
        [self editModeButton];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        [_customNavBarView setupLandscapeConstraint];
    }else{
        [_customNavBarView setupPortraitConstraint];
    }
    
    self.dataIntervalsTableView.tableFooterView = [UIView new];
}

- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        [_customNavBarView setupLandscapeConstraint];
    }else{
        [_customNavBarView setupPortraitConstraint];
    }
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [_customNavBarView setupLandscapeConstraint];
    }else{
        [_customNavBarView setupPortraitConstraint];
    }
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateInterfaceOrientation:toInterfaceOrientation];
    
}

-(void)customBarButtonItems
{
    _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_saveButton setTitle:@"Save".localized forState:UIControlStateNormal];
    _saveButton.titleLabel.font= [UIFont fontWithName:@"Avenir Next" size:18];
    // [_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_saveButton setImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateNormal];
    [_saveButton setTintColor:[UIColor colorWithRed:38.0f/255.0f green:182.0f/255.0f blue:155.0f/255.0f alpha:1.0f]];
    [_saveButton setTitleColor:[UIColor colorWithRed:38.0f/255.0f green:182.0f/255.0f blue:155.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_saveButton sizeToFit];
    _saveButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _saveButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _saveButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [ _saveButton addTarget:self action:@selector(saveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _customRightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
    self.navigationItem.rightBarButtonItem = _customRightBarButtonItem;
    _leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel".localized style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonAction:)];
    self.navigationItem.leftBarButtonItem =_leftBarButtonItem;
}


-(void)editModeButton
{
    if (self.isEditingTimer) {
        
        _inputTitleStopwatchWorkout =[NSString stringWithFormat:@"%@",[_managedObject valueForKey:@"workoutNameStopwatch"]];
        if([_inputTitleStopwatchWorkout isEqualToString:@""])
        {
            _inputTitleStopwatchWorkout =@"Stopwatch workout".localized;
        }

        _addWorkoutTextfield.text = _inputTitleStopwatchWorkout;
        _fullSecondsPrepareTime = [[_managedObject valueForKey:@"prepareTimeStopwatch"]integerValue];

        _minPrepareTime =_fullSecondsPrepareTime/60;
        _secPrepareTime =_fullSecondsPrepareTime%60;
        
        _secondsSoundTime =[[_managedObject valueForKey:@"timeLap"]integerValue];
        _choosenSoundEachTimeMinAmount = _secondsSoundTime/60;
        _choosenSoundEachTimeSecAmount = _secondsSoundTime%60;
        
        
    }
}


-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [_addWorkoutTextfield resignFirstResponder];
}


-(void) keyboardWillShow:(NSNotification *) note {
    [self.view addGestureRecognizer:tapRecognizer];
}


-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:tapRecognizer];
}


-(void)cancelBarButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
-(void)dataInTabataAddNewTimerTableViewCells
{
    stopWatchTitlesForIntervals = [NSArray arrayWithObjects:@"Prepare".localized,@"Time lap".localized,nil];
    stopWatchDescriptionForIntervals = [NSArray arrayWithObjects:@"Countdown before you start".localized,
                                                                 @"Clock will make a sound at each lap".localized,
                                                                 nil];
    stopWatchValuesForIntervals = [NSArray arrayWithObjects:@":00",@":05",nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CustomIntervalsTableViewCell";
    CustomIntervalsTableViewCell *cell = (CustomIntervalsTableViewCell * )[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (CustomIntervalsTableViewCell *) [nib objectAtIndex:0];
    }
    self.dataIntervalsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.dataIntervalsTableView.separatorColor = [UIColor grayColor];
    cell.customIntervalsTitleLabel.text =[stopWatchTitlesForIntervals objectAtIndex:indexPath.row];
    cell.customIntervalsDescriptionLabel.text =[stopWatchDescriptionForIntervals objectAtIndex:indexPath.row];
    cell.customIntervalsTimeValueLabel.text =[stopWatchValuesForIntervals objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.customIntervalsTimeValueLabel.text =[self formattedTimeTableView:_fullSecondsPrepareTime];
    }
    if (indexPath.row == 1) {
        cell.customIntervalsTimeValueLabel.text = [self formattedTimeTableView:_secondsSoundTime];
    }
    return cell;
}


-(NSString *)formattedTimeTableView:(NSInteger)totalSeconds
{
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    if (totalSeconds<60) {
        return [NSString stringWithFormat:@":%02ld",seconds];
    }
    else
        return [NSString stringWithFormat:@"%02ld:%02ld",minutes,seconds];
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString* input=_addWorkoutTextfield.text;
    _addWorkoutTextfield.text=input;
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrepareTimeViewController *vc0 = [self.storyboard instantiateViewControllerWithIdentifier:@"PrepareTimeViewController"];
    SoundEachViewController *vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"SoundEachViewController"];
    switch (indexPath.row) {
        case 0:
            vc0.fullValuePrepareTimeSeconds = _fullSecondsPrepareTime;
            vc0.selectedRowMinForPrepare = _minPrepareTime;
            vc0.selectedRowSecForPrepare = _secPrepareTime;
            vc0.type = @"1";
            vc0.delegate = self;
            [self.navigationController pushViewController:vc0 animated:YES];
            break;
        case 1:
            vc1.fullSecSoundEach = _secondsSoundTime;
            vc1.soundEachMin = _choosenSoundEachTimeMinAmount;
            vc1.soundEachSec = _choosenSoundEachTimeSecAmount;
            vc1.delegate = self;
            [self.navigationController pushViewController:vc1 animated:YES];
            break;
        default:
            break;
    }
}


-(void)dataFromPrepareTimeViewController:(NSInteger)data pickedPrepareTimeMinValue:(NSInteger)minPick pickedPrepareTimeSecValue:(NSInteger)secPick pickedColorCollectionViewCell:(NSInteger)pickedColor
{
    _fullSecondsPrepareTime = data;
    _minPrepareTime = minPick;
    _secPrepareTime =  secPick;
    [_dataIntervalsTableView reloadData];
}


-(void)dataFromSoundEachMinViewController:(NSInteger)data pickedMinValue:(NSInteger)minPicked pickedSecValue:(NSInteger)secPicked
{
    _secondsSoundTime = data;
    _choosenSoundEachTimeMinAmount = minPicked;
    _choosenSoundEachTimeSecAmount = secPicked;
    [_dataIntervalsTableView reloadData];
}


-(void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:AppUpdateThemeNotificationName object:nil];
}


-(void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AppUpdateThemeNotificationName object:nil];
}


-(void)updateUI{
    [_customNavBarView setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
     [_customNavigationBarViewIpad setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[AppTheme sharedManager] labelColor],
       NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]}];
    [self.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[[AppTheme sharedManager]labelColor],
                                                     NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]} forState:UIControlStateNormal];
    [self.customRightBarButtonItem setTintColor:[[AppTheme sharedManager]buttonBackgroundColor]];
    //    [_saveButton setTitleColor:[[AppTheme sharedManager]buttonBackgroundColor] forState:UIControlStateNormal];
}


- (void)dealloc {
    [self removeObserver];
}


- (IBAction)saveButtonTapped:(id)sender
{
    NSNumber *prepareTimeStopwatch = [NSNumber numberWithInteger:_fullSecondsPrepareTime];
    NSNumber *timelapStopwatch = [NSNumber numberWithInteger:_secondsSoundTime];
    _customStopwatchNewTimerDict = [[NSMutableDictionary alloc] init];
    NSTimeInterval timeStamp = [[NSDate date]timeIntervalSince1970];
    NSString *timeSt =[NSString stringWithFormat:@"%f",timeStamp];
    
    if ([_addWorkoutTextfield.text isEqualToString:@""]) {
        _addWorkoutTextfield.text = @"Stopwatch workout".localized;
    }
    
    if (self.isEditingTimer) {
        [_managedObject setValue:_addWorkoutTextfield.text forKey:@"workoutNameStopwatch"];
        [_managedObject setValue:prepareTimeStopwatch forKey:@"prepareTimeStopwatch"];
        [_managedObject setValue:timelapStopwatch forKey:@"timeLap"];
        [_managedObject setValue:timeSt forKey:@"workoutTimeStampStopwatch"];
        [[DatabaseManager sharedInstance] saveContext];
        [[DatabaseManager sharedInstance]getStopwatchWorkouts];
    }
    else
    {
        _customStopwatchNewTimerDict[@"workoutNameStopwatch"] = _addWorkoutTextfield.text;
        _customStopwatchNewTimerDict[@"prepareTimeStopwatch"] = prepareTimeStopwatch;
        _customStopwatchNewTimerDict[@"timeLap"] = timelapStopwatch;
        _customStopwatchNewTimerDict[@"workoutTimeStampStopwatch"] = timeSt;
        [[DatabaseManager sharedInstance]insertStopwatchWorkout:_customStopwatchNewTimerDict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
