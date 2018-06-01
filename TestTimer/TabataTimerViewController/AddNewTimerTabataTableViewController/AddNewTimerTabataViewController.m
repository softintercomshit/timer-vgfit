//
//  AddNewTimerTabataTableViewController.m
//  TestTimer
//
//  Created by a on 3/21/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "AddNewTimerTabataViewController.h"
#import "CustomIntervalsTableViewCell.h"
#import "PrepareTimeViewController.h"
#import "WorkTimeViewController.h"
#import "RestTimeViewController.h"
#import "RoundsViewController.h"
#import "CyclesViewController.h"
#import "RestBetweenCyclesViewController.h"
#import "AppTheme.h"
#import "TabatasWorkouts.h"
#import "DatabaseManager.h"
#import "CustomNavigationBarUIView.h"


@interface AddNewTimerTabataViewController ()<PrepareTimeViewControllerDelegate,
WorkTimeViewControllerDelegate,
RestTimeViewControllerDelegate,
RoundsViewControllerDelegate,
CyclesViewControllerDelegate,
RestBetweenCyclesViewControllerDelegate>


@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavBarView;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;


@end

@implementation AddNewTimerTabataViewController
{
    __weak IBOutlet NSLayoutConstraint *heightNavigationBarConstraint;
    NSArray *tabataTitlesForIntervals;
    NSArray *tabataDescriptionForIntervals;
    NSArray *tabataValuesForIntervals;
    NSArray *tabataTitleHeader;
    NSInteger countID;
    UITapGestureRecognizer *tapRecognizer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _workoutNameTextField.text=_inputTitleWorkoutTabata;
    _workoutNameTextField.placeholder = @"Tabata workout".localized;
    [self.uiViewForTextField addSubview:_workoutNameTextField];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    self.title = @"Tabata".localized;
    [self customBarButtonItem];
    [self updateUI];
    _roundsFullValue = 1;
    _cyclesFullValue = 1;
    _selectedWorkFullSecondsValue = 1;
    _selectedWorkSecValue = 1;
    
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
    
    self.tableView.tableFooterView = [UIView new];
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

-(void)customBarButtonItem
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
        _inputTitleWorkoutTabata =[NSString stringWithFormat:@"%@",[_managedObject valueForKey:@"workoutName"]];
        if ([_inputTitleWorkoutTabata isEqualToString:@""]) {
            self.inputTitleWorkoutTabata = @"Tabata workout".localized;
        }
        _workoutNameTextField.text =_inputTitleWorkoutTabata;
        
        _fullSecondsPrepare = [[_managedObject valueForKey:@"prepareTime"] integerValue];
        _selectedPrepareTimeMinute = _fullSecondsPrepare/60;
        _selectedPrepareTimeSeconds =_fullSecondsPrepare%60;
        
        _selectedWorkFullSecondsValue =[[_managedObject valueForKey:@"workTime"]integerValue];
        _selectedWorkMinValue = _selectedWorkFullSecondsValue/60;
        _selectedWorkSecValue = _selectedWorkFullSecondsValue%60;
        
        _fullSecondsRestTime = [[_managedObject valueForKey:@"restTime"]integerValue];
        _selectedRestMinValue =_fullSecondsRestTime/60;
        _selectedRestSecValue = _fullSecondsRestTime%60;
        _roundsFullValue =[[_managedObject valueForKey:@"roundsTabata"]integerValue];
        _selectedRoundsValue =_roundsFullValue-1;
        _cyclesFullValue =[[_managedObject valueForKey:@"cyclesTabata"]integerValue];
        _selectedCyclesValue = _cyclesFullValue-1;
        _fullSecondsRestBetweenCycles =[[_managedObject valueForKey:@"restBetweenCyclesTime"]integerValue];
        _selectedRestBetweenCyclesMinValue = _fullSecondsRestBetweenCycles/60;
        _selectedRestBetweenCyclesSecValue = _fullSecondsRestBetweenCycles%60;
        
    }
}


-(NSInteger)formattedTimeTableView1:(NSInteger)totalSeconds
{
    NSInteger seconds;
    NSInteger minutes;
    if (totalSeconds<60) {
        return  seconds = totalSeconds % 60;
    }
    else{
        return minutes = (totalSeconds / 60) % 60;
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
    tabataTitlesForIntervals = [NSArray arrayWithObjects:@"Prepare".localized,
                                @"Work".localized,
                                @"Rest".localized,
                                @"Rounds".localized,
                                @"Cycles".localized,
                                @"Rest between cycles".localized, nil];
    
    tabataDescriptionForIntervals = [NSArray arrayWithObjects:@"Countdown before you start".localized,
                                     @"Do exercises for this long".localized,
                                     @"Rest for this long".localized,
                                     @"One round is work + rest".localized,
                                     @"One cycle is 2 rounds".localized,
                                     @"Recovery interval".localized,nil];
    
    tabataValuesForIntervals = [NSArray arrayWithObjects:@":00",
                                @":01",
                                @":00",
                                @"1",
                                @"1",
                                @":00",
                                nil];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
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
    [self dataInTabataAddNewTimerTableViewCells];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor grayColor];
    cell.customIntervalsTitleLabel.text =[tabataTitlesForIntervals objectAtIndex:indexPath.row];
    cell.customIntervalsDescriptionLabel.text =[tabataDescriptionForIntervals objectAtIndex:indexPath.row];
    cell.customIntervalsTimeValueLabel.text =[tabataValuesForIntervals objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0)
    {
        cell.customIntervalsTimeValueLabel.text =[self formattedTimeTableView:_fullSecondsPrepare];
        
    }
    if (indexPath.row == 1) {
        cell.customIntervalsTimeValueLabel.text =[self formattedTimeTableView:_selectedWorkFullSecondsValue];
    }
    if (indexPath.row == 2) {
        cell.customIntervalsTimeValueLabel.text =[self formattedTimeTableView:_fullSecondsRestTime];
    }
    if (indexPath.row == 3) {
        
        cell.customIntervalsTimeValueLabel.text =[NSString stringWithFormat:@"%ld",_roundsFullValue];
    }
    if (indexPath.row == 4) {
        cell.customIntervalsTimeValueLabel.text = [NSString stringWithFormat:@"%ld",_cyclesFullValue];
    }
    
    if (indexPath.row == 5) {
        cell.customIntervalsTimeValueLabel.text =[self formattedTimeTableView:_fullSecondsRestBetweenCycles];
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int selectedIndexPath =(int)indexPath.row;
    
    PrepareTimeViewController *vc0 = [self.storyboard instantiateViewControllerWithIdentifier:@"PrepareTimeViewController"];
    WorkTimeViewController *vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkTimeViewController"];
    RestTimeViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"RestTimeViewController"];
    RoundsViewController *vc3 = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundsViewController"];
    CyclesViewController *vc4 = [self.storyboard instantiateViewControllerWithIdentifier:@"CyclesViewController"];
    RestBetweenCyclesViewController *vc5 = [self.storyboard instantiateViewControllerWithIdentifier:@"RestBetweenCyclesViewController"];
    switch (selectedIndexPath) {
        case 0:
            vc0.fullValuePrepareTimeSeconds = _fullSecondsPrepare;
            vc0.selectedRowMinForPrepare = _selectedPrepareTimeMinute;
            vc0.selectedRowSecForPrepare = _selectedPrepareTimeSeconds;
            vc0.type = @"1";
            vc0.delegate = self;
            [self.navigationController pushViewController:vc0 animated:YES];
            break;
        case 1:
            vc1.fullValue = _selectedWorkFullSecondsValue;
            vc1.selectedRowinMin = _selectedWorkMinValue;
            vc1.selectedRowinSec = _selectedWorkSecValue;
            vc1.type = @"1";
            vc1.delegate = self;
            [self.navigationController pushViewController:vc1 animated:YES];
            break;
        case 2:
            vc2.fullValueSeconds = _fullSecondsRestTime;
            vc2.selectedRowinMin = _selectedRestMinValue;
            vc2.selectedRowinSec = _selectedRestSecValue;
            vc2.type = @"1";
            vc2.delegate = self;
            [self.navigationController pushViewController:vc2 animated:YES];
            break;
        case 3:
            vc3.type = @"1";
            vc3.rounds = _roundsFullValue;
            vc3.selectedRowForRounds = _selectedRoundsValue;
            vc3.delegate = self;
            [self.navigationController pushViewController:vc3 animated:YES];
            break;
        case 4:
            vc4.type = @"1";
            vc4.cycles = _cyclesFullValue ;
            vc4.selectedRowForCycles = _selectedCyclesValue;
            vc4.delegate = self;
            [self.navigationController pushViewController:vc4 animated:YES];
            break;
        case 5:
            vc5.fullValuesRestBetweenCyclesSeconds = _fullSecondsRestBetweenCycles;
            vc5.selectedRestBetweenCyclesRowInMinutes = _selectedRestBetweenCyclesMinValue;
            vc5.selectedRestBetweenCyclesRowInSeconds = _selectedRestBetweenCyclesSecValue;
            vc5.type = @"1";
            vc5.delegate = self;
            [self.navigationController pushViewController:vc5 animated:YES];
            break;
        default:
            break;
    }
}


-(void)dataFromPrepareTimeViewController:(NSInteger)data pickedPrepareTimeMinValue:(NSInteger)minPick pickedPrepareTimeSecValue:(NSInteger)secPick pickedColorCollectionViewCell:(NSInteger)pickedColor
{
    _fullSecondsPrepare = data;
    _selectedPrepareTimeMinute = minPick;
    _selectedPrepareTimeSeconds = secPick;
    //    NSLog(@"%ld",(long)_fullSecondsPrepare);
    _selectedPrepareTimeColorForCell= pickedColor;
    [_tableView reloadData];
}


-(void)dataFromWorkTimeMinViewController:(NSInteger)dataFullValue pickedMinuteValue:(NSInteger)minPick pickedSecondValue:(NSInteger)secPick pickedColorIndexValue:(NSInteger)colorIndex
{
    _selectedWorkFullSecondsValue = dataFullValue;
    _selectedWorkMinValue = minPick;
    _selectedWorkSecValue = secPick;
    _selectedWorkTimeColorForCell = colorIndex;
    [_tableView reloadData];
}


-(void)dataFromRestTimeMinViewController:(NSInteger)fullData pickedMinuteValue:(NSInteger)minPick pickedSecondValue:(NSInteger)secPick pickedColor:(NSInteger)secColor
{
    _fullSecondsRestTime = fullData;
    _selectedRestMinValue = minPick;
    _selectedRestSecValue = secPick;
    _selectedRestTimeColorForCell = secColor;
    [_tableView reloadData];
    
}


-(void)dataFromRoundsViewController:(NSInteger)data pickedRoundsValue:(NSInteger)roundsPick pickedColorCollectionViewCell:(NSInteger)pickedColor
{
    _roundsFullValue = data;
    _selectedRoundsValue = roundsPick;
    [_tableView reloadData];
}


-(void)dataFromCyclesViewController:(NSInteger)data pickedCyclesValue:(NSInteger)cyclesPick pickedColorCollectionViewCell:(NSInteger)pickedColor
{
    _cyclesFullValue = data;
    _selectedCyclesValue = cyclesPick;
    [_tableView reloadData];
}


-(void)dataFromRestBetweenCyclesViewController:(NSInteger)data pickedMinValue:(NSInteger)minPick pickedSecValue:(NSInteger)secPick pickedColorValue:(NSInteger)colorPick
{
    _fullSecondsRestBetweenCycles = data;
    _selectedRestBetweenCyclesMinValue = minPick;
    _selectedRestBetweenCyclesSecValue = secPick;
    _selectedRestBetweenCyclesTimeColorForCell = colorPick;
    [_tableView reloadData];
}


-(void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:AppUpdateThemeNotificationName object:nil];
}


-(void)removeObserver
{
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


- (IBAction)saveButtonTapped:(id)sender
{
    NSNumber* prepareTime = [NSNumber numberWithInteger:_fullSecondsPrepare];
    NSNumber* workTime = [NSNumber numberWithInteger:_selectedWorkFullSecondsValue];
    NSNumber* restTime = [NSNumber numberWithInteger:_fullSecondsRestTime];
    NSNumber* roundsTabata = [NSNumber numberWithInteger:_roundsFullValue];
    NSNumber* cyclesTabata = [NSNumber numberWithInteger:_cyclesFullValue];
    NSNumber* restBetweenCycles = [NSNumber numberWithInteger:_fullSecondsRestBetweenCycles];
    _customTimerDict  = [[NSMutableDictionary alloc] init];
    
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *ts = [NSString stringWithFormat:@"%f", timeStamp];
    
    if ([_workoutNameTextField.text isEqualToString:@""]) {
        _workoutNameTextField.text = @"Tabata workout".localized;
    }
    
    _customTimerDict[@"workoutName"]=_workoutNameTextField.text;
    _customTimerDict[@"prepareTime"]=prepareTime;
    _customTimerDict[@"workTime"]=workTime;
    _customTimerDict[@"restTime"]=restTime;
    _customTimerDict[@"roundsTabata"]=roundsTabata;
    _customTimerDict[@"workoutTimeStamp"] =ts;
    _customTimerDict[@"cyclesTabata"] = cyclesTabata;
    _customTimerDict[@"restBetweenCyclesTime"] =restBetweenCycles;
    //    NSLog(@"Dictionary with data: %@",_customTimerDict);
    if(self.isEditingTimer)
    {
        [_managedObject setValue:_workoutNameTextField.text forKey:@"workoutName"];
        [_managedObject setValue:prepareTime forKey:@"prepareTime"];
        [_managedObject setValue:workTime forKey:@"workTime"];
        [_managedObject setValue:restTime forKey:@"restTime"];
        [_managedObject setValue:roundsTabata forKey:@"roundsTabata"];
        [_managedObject setValue:ts forKey:@"workoutTimeStamp"];
        [_managedObject setValue:cyclesTabata forKey:@"cyclesTabata"];
        [_managedObject setValue:restBetweenCycles forKey:@"restBetweenCyclesTime"];
        [[DatabaseManager sharedInstance]saveContext];
        //        NSLog(@"%@",_managedObject);
        [[DatabaseManager sharedInstance]getTabataWorkouts];
    }
    else
    {
        [[DatabaseManager sharedInstance] insertTabataWorkout:_customTimerDict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)dealloc
{
    [self removeObserver];
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString* input=_workoutNameTextField.text;
    _workoutNameTextField.text=input;
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_workoutNameTextField resignFirstResponder];
    return YES;
}


@end
