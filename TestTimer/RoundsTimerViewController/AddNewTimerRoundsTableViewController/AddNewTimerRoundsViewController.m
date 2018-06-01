//
//  AddNewTimerRoundsTableViewController.m
//  TestTimer
//
//  Created by a on 3/21/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "AddNewTimerRoundsViewController.h"
#import "CustomIntervalsTableViewCell.h"
#import "PrepareTimeViewController.h"
#import "RoundsTimeViewController.h"
#import "RoundsViewController.h"
#import "AppTheme.h"
#import "DatabaseManager.h"
#import "RestTimeViewController.h"
#import "CustomNavigationBarUIView.h"


@interface AddNewTimerRoundsViewController()<PrepareTimeViewControllerDelegate,RoundsTimeViewControllerDelegate,RestTimeViewControllerDelegate,RoundsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavBarView;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;

@end

@implementation AddNewTimerRoundsViewController
{
    NSArray *roundsTitlesForIntervals;
    NSArray *roundsDescriptionForIntervals;
    NSArray *roundsValuesForIntervals;
    UITextField *roundsWorkoutTextField;
    UITapGestureRecognizer *tapRecognizer;
    __weak IBOutlet NSLayoutConstraint *heightNavigationBarConstraint;
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self updateUI];
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        [_customNavBarView setupLandscapeConstraint];
    }else{
        [_customNavBarView setupPortraitConstraint];
    }
    
    self.dataFromTableView.tableFooterView = [UIView new];
}


- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        [_customNavBarView setupLandscapeConstraint];
    }else{
        [_customNavBarView setupPortraitConstraint];
    }
    [self.dataFromTableView reloadData];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        [_customNavBarView setupLandscapeConstraint];
    }else{
        [_customNavBarView setupPortraitConstraint];
    }
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateInterfaceOrientation:toInterfaceOrientation];
    
}


-(void)customBarButtonItems {
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInTabataAddNewTimerTableViewCells];
    _workoutNameTextField.text=_inputRoundsTitle;
    _workoutNameTextField.placeholder = @"Rounds workout".localized;
    [self.uiViewForTextField addSubview:_workoutNameTextField];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    [self customBarButtonItems];
    self.title =@"Rounds".localized;
    [self updateUI];
    _roundsAmount = 1;
    _fullSecRestTime = 1;
    _pickedRestTimeSecAmount = 1;
    _pickedWorkTimeSecAmount = 1;
    _fullSecWorkTime = 1;
    if (self.isEditingTimer) {
        [self editModeButton];
    }
}
-(void)editModeButton
{
    if (_isEditingTimer) {
        _inputRoundsTitle = [NSString stringWithFormat:@"%@",[_managedObject valueForKey:@"workoutNameRounds"]];
        if([_inputRoundsTitle isEqualToString:@""])
        {
            _inputRoundsTitle =@"Rounds workout".localized;
        }
        _workoutNameTextField.text = _inputRoundsTitle;
        _fullSecondsPrepare = [[_managedObject valueForKey:@"prepareTimeRounds"]integerValue];
        _pickedMinutesPrepare =_fullSecondsPrepare/60;
        _pickedSecondsPrepare =_fullSecondsPrepare%60;
        
        _roundsAmount = [[_managedObject valueForKey:@"roundsRounds"]integerValue];
        _pickedRoundAmount =_roundsAmount-1;
        _fullSecWorkTime = [[_managedObject valueForKey:@"workTimeRounds"]integerValue];
        _pickedWorkTimeMinAmount =_fullSecWorkTime/60;
        _pickedWorkTimeSecAmount =_fullSecWorkTime%60;
        
        
        _fullSecRestTime = [[_managedObject valueForKey:@"restTimeRounds"]integerValue];
        _pickedRestTimeMinAmount =_fullSecRestTime/60;
        _pickedRestTimeSecAmount =_fullSecRestTime%60;
    }
}


-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [_workoutNameTextField resignFirstResponder];
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


-(void)dataInTabataAddNewTimerTableViewCells
{
    roundsTitlesForIntervals = [NSArray arrayWithObjects:@"Prepare".localized,
                                                         @"Work".localized,
                                                         @"Rest".localized,
                                                         @"Rounds".localized,
                                                         nil];
    roundsDescriptionForIntervals = [NSArray arrayWithObjects:@"Countdown before you start".localized,
                                                              @"Work for this long".localized,
                                                              @"Rest for this long".localized,
                                                              @"One round is work + rest".localized,
                                                         nil];
    roundsValuesForIntervals = [NSArray arrayWithObjects:@":00",@":01",@":01",@"1",nil];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self dataInTabataAddNewTimerTableViewCells];
    static NSString *cellIdentifier = @"CustomIntervalsTableViewCell";
    CustomIntervalsTableViewCell *cell = (CustomIntervalsTableViewCell * )[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (CustomIntervalsTableViewCell *) [nib objectAtIndex:0];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor grayColor];
    cell.customIntervalsTitleLabel.text =[roundsTitlesForIntervals objectAtIndex:indexPath.row];
    cell.customIntervalsDescriptionLabel.text =[roundsDescriptionForIntervals objectAtIndex:indexPath.row];
    cell.customIntervalsTimeValueLabel.text =[roundsValuesForIntervals objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    if (indexPath.row == 0) {
        cell.customIntervalsTimeValueLabel.text = [self formattedTimeTableView:_fullSecondsPrepare];
    }
    if (indexPath.row == 1) {
        cell.customIntervalsTimeValueLabel.text = [self formattedTimeTableView:_fullSecWorkTime];
    }
    if (indexPath.row == 2) {
        cell.customIntervalsTimeValueLabel.text = [self formattedTimeTableView:_fullSecRestTime];
    }
    if (indexPath.row == 3) {
        cell.customIntervalsTimeValueLabel.text = [NSString stringWithFormat:@"%ld",_roundsAmount];
    }
    return cell;
}


-(NSString *)formattedTimeTableView:(NSInteger)totalSeconds {
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    if (totalSeconds<60) {
        return [NSString stringWithFormat:@":%02ld",seconds];
    }
    else
        return [NSString stringWithFormat:@"%02ld:%02ld",minutes,seconds];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSString* input=_workoutNameTextField.text;
    _workoutNameTextField.text=input;
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int indexSelectedPath = (int)indexPath.row;
    PrepareTimeViewController *vc0 = [self.storyboard instantiateViewControllerWithIdentifier:@"PrepareTimeViewController"];
    RoundsTimeViewController *vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundsTimeViewController"];
    RestTimeViewController *vc3 = [self.storyboard instantiateViewControllerWithIdentifier:@"RestTimeViewController"];
    RoundsViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundsViewController"];
    
    switch (indexSelectedPath) {
            
        case 0:
            vc0.fullValuePrepareTimeSeconds = _fullSecondsPrepare;
            vc0.selectedRowMinForPrepare = _pickedMinutesPrepare;
            vc0.selectedRowSecForPrepare = _pickedSecondsPrepare;
            vc0.type = @"1";
            vc0.delegate = self;
            [self.navigationController pushViewController:vc0 animated:YES];
            break;
        case 1:
            vc1.fullValuesSeconds = _fullSecWorkTime;
            vc1.roundTimeMin = _pickedWorkTimeMinAmount;
            vc1.roundTimeSec = _pickedWorkTimeSecAmount;
            vc1.type = @"1";
            vc1.delegate = self;
            [self.navigationController pushViewController:vc1 animated:YES];
            break;
        case 2:
            vc3.fullValueSeconds =_fullSecRestTime;
            vc3.selectedRowinMin =_pickedRestTimeMinAmount;
            vc3.selectedRowinSec = _pickedRestTimeSecAmount;
            vc3.type = @"1";
            vc3.delegate = self;
            [self.navigationController pushViewController:vc3 animated:YES];
            break;
        case 3:
            vc2.rounds = _roundsAmount;
            vc2.selectedRowForRounds = _pickedRoundAmount;
            vc2.delegate = self;
            vc2.type = @"1";
            [self.navigationController pushViewController:vc2 animated:YES];
            break;
        default:
            break;
    }
}


-(void)dataFromPrepareTimeViewController:(NSInteger)data pickedPrepareTimeMinValue:(NSInteger)minPick pickedPrepareTimeSecValue:(NSInteger)secPick pickedColorCollectionViewCell:(NSInteger)pickedColor
{
    _fullSecondsPrepare = data;
    _pickedMinutesPrepare = minPick;
    _pickedSecondsPrepare = secPick;
    _pickedColorCellIndex = pickedColor;
    [_dataFromTableView reloadData];
}


-(void)dataFromRoundTimeMinViewController:(NSInteger)fullSecData pickedMinValue:(NSInteger)minPicked pickedSecValue:(NSInteger)secPick pickedColorCell:(NSInteger)selectedColorIndex
{
    _fullSecWorkTime = fullSecData;
    _pickedWorkTimeMinAmount = minPicked;
    _pickedWorkTimeSecAmount = secPick;
    [_dataFromTableView reloadData];
}


-(void)dataFromRestTimeMinViewController:(NSInteger)fullData pickedMinuteValue:(NSInteger)minPick pickedSecondValue:(NSInteger)secPick pickedColor:(NSInteger)secColor
{
    _fullSecRestTime = fullData;
    _pickedRestTimeMinAmount = minPick;
    _pickedRestTimeSecAmount  =secPick;
    [_dataFromTableView reloadData];
}


-(void)dataFromRoundsViewController:(NSInteger)data pickedRoundsValue:(NSInteger)roundsPick pickedColorCollectionViewCell:(NSInteger)pickedColor
{
    _roundsAmount = data;
    _pickedRoundAmount = roundsPick;
    [_dataFromTableView reloadData];
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
}


-(void)dealloc{
    [self removeObserver];
}



- (IBAction)saveButtonTapped:(id)sender
{
    NSNumber* prepareTimeRounds = [NSNumber numberWithInteger:_fullSecondsPrepare];
    NSNumber* roundsRounds = [NSNumber numberWithInteger:_roundsAmount];
    NSNumber* workTimeRounds = [NSNumber numberWithInteger:_fullSecWorkTime];
    NSNumber* restTimeRounds  =[NSNumber numberWithInteger:_fullSecRestTime];
    _customRoundsNewTimerDict  = [[NSMutableDictionary alloc] init];
    
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *ts = [NSString stringWithFormat:@"%f", timeStamp];
    
    if ([_workoutNameTextField.text isEqualToString:@""]) {
        _workoutNameTextField.text = @"Rounds workout".localized;
    }
    
    if (self.isEditingTimer) {
       
        [_managedObject setValue:_workoutNameTextField.text forKey:@"workoutNameRounds"];
        [_managedObject setValue:prepareTimeRounds forKey:@"prepareTimeRounds"];
        [_managedObject setValue:roundsRounds forKey:@"roundsRounds"];
        [_managedObject setValue:workTimeRounds forKey:@"workTimeRounds"];
        [_managedObject setValue:restTimeRounds forKey:@"restTimeRounds"];
        [_managedObject setValue:ts forKey:@"workoutTimeStampRounds"];
        [[DatabaseManager sharedInstance] saveContext];
        
        [[DatabaseManager sharedInstance]getRoundsWorkouts];
    }
    else{
        _customRoundsNewTimerDict[@"workoutNameRounds"] = _workoutNameTextField.text;
        _customRoundsNewTimerDict[@"prepareTimeRounds"] = prepareTimeRounds;
        _customRoundsNewTimerDict[@"roundsRounds"] = roundsRounds;
        _customRoundsNewTimerDict[@"workTimeRounds"] = workTimeRounds;
        _customRoundsNewTimerDict[@"restTimeRounds"] = restTimeRounds;
        _customRoundsNewTimerDict[@"workoutTimeStampRounds"] = ts;
        [[DatabaseManager sharedInstance] insertRoundsWorkout:_customRoundsNewTimerDict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
