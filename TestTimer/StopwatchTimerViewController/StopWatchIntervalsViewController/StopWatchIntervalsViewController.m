//
// StopWatchIntervalsTableViewController.m
//  TestTimer
//
//  Created by a on 4/13/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "StopWatchIntervalsViewController.h"
#import "CustomHeaderTableViewCell.h"
#import "CustomIntervalsTableViewCell.h"
#import "AddNewTimerStopWatchViewController.h"
#import "PrepareTimeViewController.h"
#import "SoundEachViewController.h"
#import "AppTheme.h"
#import "SettingsManager.h"
#import "NewCustomHeaderTableViewCell.h"
#import "CustomWorkoutTableViewCell.h"
#import "CustomNavigationBarUIView.h"

@interface StopWatchIntervalsViewController ()<PrepareTimeViewControllerDelegate,SoundEachViewControllerDelegate>
{
    NSArray *stopWatchTitlesForIntervals;
    NSArray *stopWatchDescriptionForIntervals;
    NSArray *stopWatchValuesForIntervals;
    NSArray *stopWatchTitleHeader;
    NSArray *headerStopWatchImages;
    NSString *secondsValuePrepareTime;
    NSString *secondsValueSoundEachValue;
    BOOL rotationEnabled;
    BOOL allowRotation;
    
    __weak IBOutlet NSLayoutConstraint *heightConstraintForNavigationBar;
    NSIndexPath *previousIndexPath,*currentIndexPath;
    
    NSMutableArray *intervalsStopwatchArray;
    NSMutableArray *colorsStopwatchArray;
    
    
}
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;

@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavigationBarView;

@end

@implementation StopWatchIntervalsViewController




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
    
    self.stopwatchWorkout =[[DatabaseManager sharedInstance] getStopwatchWorkouts] ;
    self.arrayWorkout = [self.stopwatchWorkout mutableCopy];
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation])) {
       
    }else{
      
    }
    
    [_dataIntervalsTableView reloadData];
    
    self.dataIntervalsTableView.tableFooterView = [UIView new];
}

- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
    
}



-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
}


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateInterfaceOrientation:toInterfaceOrientation];
    [_tableView reloadData];
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
    [ _saveButton addTarget:self action:@selector(saveBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _customRightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
    self.navigationItem.rightBarButtonItem = _customRightBarButtonItem;
    _leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel".localized style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonAction:)];
    self.navigationItem.leftBarButtonItem =_leftBarButtonItem;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //  CustomUINavBar *test = [[CustomUINavBar alloc] init];
    self.title=@"Stopwatch".localized;
    [self customBarButtonItem];
    [self updateUI];
    [self loadFirstTimeFromNSUserDefaults];
    [self dataFromArrays];
}
-(void)dataFromArrays
{
    stopWatchTitlesForIntervals = [NSArray arrayWithObjects:@"Prepare".localized,
                                   @"Time lap".localized,
                                   nil];
    stopWatchDescriptionForIntervals = [NSArray arrayWithObjects:@"Countdown before you start".localized,
                                        @"Clock will make a sound at each lap".localized,
                                        nil];
    stopWatchTitleHeader = [NSArray arrayWithObjects:@"Intervals".localized,
                            @"My workouts".localized,
                            nil];
    headerStopWatchImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"icInterval.png"],[UIImage imageNamed:@"icMyWorkouts.png"], nil];
}
-(void)loadFirstTimeFromNSUserDefaults
{
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    //prepare
    
    _fullSecondsPrepareTime = [data integerForKey:@"fullSecondsPrepareTime"];
    _selectedPrepareTimeMinValue = [data integerForKey:@"selectedPrepareTimeMinValue"];
    _selectedPrepareTimeSecValue =[data integerForKey:@"selectedPrepareTimeSecValue"];
    
    //soundEach
    
    _fullSecondsTimeLapSoundTime = [data integerForKey:@"fullSecondsTimeLapSoundTime"];
    _selectedSoundEachTimeMinValue = [data integerForKey:@"selectedSoundEachTimeMinValue"];
    _selectedSoundEachTimeSecValue = [data integerForKey:@"selectedSoundEachTimeSecValue"];
    
    intervalsStopwatchArray = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"intervalsStopwatchArray"]];
    colorsStopwatchArray = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"colorsStopwatchArray"]];
    
    [data synchronize];
 
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellIdentifier = @"CustomHeaderTableViewCell";
    static NSString *cellIdentifier1 = @"NewCustomHeaderTableViewCell";
    
    if (section==0) {
        
        NewCustomHeaderTableViewCell *cell = (NewCustomHeaderTableViewCell * )[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1 owner:self options:nil];
            cell = (NewCustomHeaderTableViewCell *) [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.uiLabel.text =[stopWatchTitleHeader objectAtIndex:section];
        cell.uiImageView.image =[headerStopWatchImages objectAtIndex:section];
        
        return cell.contentView;
    }
    else
    {
        CustomHeaderTableViewCell *cell = (CustomHeaderTableViewCell * )[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = (CustomHeaderTableViewCell *) [nib objectAtIndex:0];
        }
        
        [cell.editButton addTarget:self action:@selector(editButtonMethodImplementation:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addNewTimerButton addTarget:self action:@selector(addNewTimer:) forControlEvents:UIControlEventTouchUpInside];
        (!self.dataIntervalsTableView.editing)?[cell.editButton setTitle:@"Edit".localized forState:UIControlStateNormal] :[cell.editButton setTitle:@"Done".localized forState:UIControlStateNormal];
        return  cell.contentView;
    }
    
}

- (void) editButtonMethodImplementation:(id)sender
{
    [self.dataIntervalsTableView setEditing:!self.dataIntervalsTableView.editing animated:true];
    
    (!self.dataIntervalsTableView.editing)?[sender setTitle:@"Edit".localized forState:UIControlStateNormal] :[sender setTitle:@"Done".localized forState:UIControlStateNormal];
    
    if (!self.dataIntervalsTableView.editing) {
        int i = 0 ;
        for (StopwatchWorkouts *row in self.stopwatchWorkout)
        {
            row.stopWatchID = [NSNumber numberWithInt:i++];
        }
        [[DatabaseManager sharedInstance] saveContext];
    }
    [self.dataIntervalsTableView reloadData];
}


- (void)addNewTimer:(id)sender
{
    AddNewTimerStopWatchViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewTimerStopWatchViewController"];
    tableViewController.managedObject = self.device;
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    else
    {
        return [self.arrayWorkout count];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 64;
    }
    else
        return 90;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    }
    else
        return 124;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self dataFromArrays];
    static NSString *cellIdentifier1 = @"CustomIntervalsTableViewCell";
    static NSString *cellIdentifier2 = @"CustomWorkoutTableViewCell";
    if (indexPath.section==0) {
        CustomIntervalsTableViewCell *cell = (CustomIntervalsTableViewCell * )[self.dataIntervalsTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1 owner:self options:nil];
            cell = (CustomIntervalsTableViewCell *) [nib objectAtIndex:0];
        }
        //        [self.dataIntervalsTableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
        cell.customWorkOutTextField.hidden = YES;
        if (indexPath.section==0) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            self.tableView.separatorColor = [UIColor grayColor];
            cell.customIntervalsTitleLabel.text =[stopWatchTitlesForIntervals objectAtIndex:indexPath.row];
            cell.customIntervalsDescriptionLabel.text =[stopWatchDescriptionForIntervals objectAtIndex:indexPath.row];
            cell.customIntervalsTimeValueLabel.text =[stopWatchValuesForIntervals objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        if (indexPath.section!=0) {
            cell.customIntervalsTitleLabel.hidden=YES;
            cell.customIntervalsDescriptionLabel.hidden=YES;
            cell.customIntervalsTimeValueLabel.hidden=YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row ==0 && indexPath.section==0) {
            cell.customIntervalsTimeValueLabel.text = [self formattedTimeTableView:_fullSecondsPrepareTime];
        }
        if (indexPath.row==1 && indexPath.section==0) {
            cell.customIntervalsTimeValueLabel.text = [self formattedTimeTableView:_fullSecondsTimeLapSoundTime];
        }
        return cell;
    }
    else
    {
        CustomWorkoutTableViewCell *cell = (CustomWorkoutTableViewCell * )[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier2 owner:self options:nil];
            cell = (CustomWorkoutTableViewCell *) [nib objectAtIndex:0];
        }
        
        self.device =[self.arrayWorkout objectAtIndex:indexPath.row];
        
        NSString *workoutStopwatchName =[NSString stringWithFormat:@"%@",[self.device valueForKey:@"workoutNameStopwatch"]];
        if ([workoutStopwatchName isEqualToString:@""]) {
            workoutStopwatchName =@"Stopwatch workout".localized;
        }
        
        
        NSString *prepareTimeStopwatch = [self timeFormatted:[[self.device valueForKey:@"prepareTimeStopwatch"]intValue]];
        NSString *timelapTimeStopwatch = [self timeFormatted:[[self.device valueForKey:@"timeLap"]intValue]];
        NSArray *arrayWithStopwatchObjects = [NSArray arrayWithObjects:prepareTimeStopwatch,timelapTimeStopwatch, nil];
        
        NSArray *arrayWithObjectsFromStopwatchCoreData = @[[NSNumber numberWithInteger:[[self.device valueForKey:@"prepareTimeStopwatch"]integerValue]],
                                                           [NSNumber numberWithInteger:[[self.device valueForKey:@"timeLap"]integerValue]]
                                                           ];
        
        
        NSArray *arrayWithStopwatchObjectsValues = @[[NSNumber numberWithInteger:_fullSecondsPrepareTime],
                                                     [NSNumber numberWithInteger:_fullSecondsTimeLapSoundTime]
                                                     ];
        NSLog(@"array objects----------------------->%@",arrayWithObjectsFromStopwatchCoreData);
        NSLog(@"array workout----------------------->%@",arrayWithStopwatchObjectsValues);
        BOOL arraysAreEqual = [arrayWithStopwatchObjectsValues isEqualToArray:arrayWithObjectsFromStopwatchCoreData];
        
        NSString  *defaultsStopwatchSelectedWorkoutSet = [[NSUserDefaults standardUserDefaults] objectForKey:kStopWatchSelectedWorkoutSet];
        NSLog(@"time stamp: %@",defaultsStopwatchSelectedWorkoutSet);
        
        if ([[self.device valueForKey:@"workoutTimeStampStopwatch"] isEqualToString:defaultsStopwatchSelectedWorkoutSet] && arraysAreEqual && !_dataIntervalsTableView.editing) {
            [cell.checkMarkImageView setHidden:false];
        }else{
            [cell.checkMarkImageView setHidden:true];
        }
        [cell setStopwatchTimerWorkoutValuesInTableViewCell:arrayWithStopwatchObjects andTitle:workoutStopwatchName];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        PrepareTimeViewController *vc0 =[self.storyboard instantiateViewControllerWithIdentifier:@"PrepareTimeViewController"];
        SoundEachViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SoundEachViewController"];
        switch (indexPath.row) {
            case 0:
                vc0.fullValuePrepareTimeSeconds = _fullSecondsPrepareTime;
                vc0.selectedRowMinForPrepare = _selectedPrepareTimeMinValue;
                vc0.selectedRowSecForPrepare = _selectedPrepareTimeSecValue;
                vc0.type = @"1";
                vc0.delegate=self;
                [self.navigationController pushViewController:vc0 animated:YES];
                break;
            case 1:
                vc.fullSecSoundEach = _fullSecondsTimeLapSoundTime;
                vc.soundEachMin = _selectedSoundEachTimeMinValue;
                vc.soundEachSec = _selectedSoundEachTimeSecValue;
                vc.timeLapSoundPicker.hidden =YES;
                vc.delegate=self;
                [self.navigationController pushViewController:vc animated:YES];
            default:
                break;
        }
    }
    if (indexPath.section == 1) {
        
        self.device = [self.arrayWorkout objectAtIndex:indexPath.row];
        _fullSecondsPrepareTime = [[self.device valueForKey:@"prepareTimeStopwatch"]integerValue];
        _selectedPrepareTimeMinValue = _fullSecondsPrepareTime/60;
        _selectedPrepareTimeSecValue = _fullSecondsPrepareTime%60;
        _fullSecondsTimeLapSoundTime = [[self.device valueForKey:@"timeLap"]integerValue];
        _selectedSoundEachTimeMinValue = _fullSecondsTimeLapSoundTime/60;
        _selectedSoundEachTimeSecValue =_fullSecondsTimeLapSoundTime%60;
        
        [_dataIntervalsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
        
        [[NSUserDefaults standardUserDefaults] setObject:[self.device valueForKey:@"workoutTimeStampStopwatch"] forKey:kStopWatchSelectedWorkoutSet];
        NSLog(@"time stamp: %@",[self.device valueForKey:@"workoutTimeStampStopwatch"]);
        
        [_dataIntervalsTableView reloadData];
        
        if (self.dataIntervalsTableView.editing) {
            AddNewTimerStopWatchViewController *viewController =[self.storyboard instantiateViewControllerWithIdentifier:@"AddNewTimerStopWatchViewController"];
            viewController.isEditingTimer =true;
            viewController.managedObject =self.device;
            [self setEditing:true animated:true];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}


- (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
}


- (NSString *)formattedTimeTableView:(NSInteger)totalSeconds {
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    if (totalSeconds<60) {
        return [NSString stringWithFormat:@":%02ld",seconds];
    }
    else
        return [NSString stringWithFormat:@"%02ld:%02ld",minutes,seconds];
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section!=0 ){
        return true;
    }
    else{
        return false;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section!=0) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            StopwatchWorkouts *devices = [self.arrayWorkout objectAtIndex:indexPath.row];
            [[DatabaseManager sharedInstance] deleteStopwatchWorkout:devices];
            
            //        // Remove device from table view
            [self.arrayWorkout  removeObjectAtIndex:indexPath.row];
            
            [self.dataIntervalsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
            
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        return true;
    }
    else{
        return false;
    }
    
}
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    StopwatchWorkouts *row = [self.arrayWorkout objectAtIndex:sourceIndexPath.row];
    [self.arrayWorkout removeObjectAtIndex:sourceIndexPath.row];
    [self.arrayWorkout insertObject:row atIndex:destinationIndexPath.row];
}

//prepareTime delegate method
//preparetimeViewC delegate method
-(void)dataFromPrepareTimeViewController:(NSInteger)data pickedPrepareTimeMinValue:(NSInteger)minPick pickedPrepareTimeSecValue:(NSInteger)secPick pickedColorCollectionViewCell:(NSInteger)pickedColor
{
    _fullSecondsPrepareTime = data;
    _selectedPrepareTimeMinValue = minPick;
    _selectedPrepareTimeSecValue = secPick;
    [_dataIntervalsTableView reloadData];
    
}


//soundEach delegate method
-(void)dataFromSoundEachMinViewController:(NSInteger)data pickedMinValue:(NSInteger)minPicked pickedSecValue:(NSInteger)secPicked
{
    
    _fullSecondsTimeLapSoundTime = data;
    _selectedSoundEachTimeMinValue = minPicked;
    _selectedSoundEachTimeSecValue = secPicked;
    //    NSLog(@"%ld",_fullSecondsTimeLapSoundTime);
    [_dataIntervalsTableView reloadData];
}

-(IBAction)cancelBarButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveDataNSUserDefaults
{
    NSUserDefaults *savedData = [NSUserDefaults standardUserDefaults];
    
    [savedData setInteger:_fullSecondsPrepareTime forKey:@"fullSecondsPrepareTime"];
    [savedData setInteger:_selectedPrepareTimeMinValue forKey:@"selectedPrepareTimeMinValue"];
    [savedData setInteger:_selectedPrepareTimeSecValue forKey:@"selectedPrepareTimeSecValue"];
    
    //sound Each Sec
    
    [savedData setInteger:_fullSecondsTimeLapSoundTime forKey:@"fullSecondsTimeLapSoundTime"];
    [savedData setInteger:_selectedSoundEachTimeMinValue forKey:@"selectedSoundEachTimeMinValue"];
    [savedData setInteger:_selectedSoundEachTimeSecValue forKey:@"selectedSoundEachTimeSecValue"];
    
    [intervalsStopwatchArray removeAllObjects];
    
    [intervalsStopwatchArray addObjectsFromArray:@[[NSNumber numberWithInteger:_fullSecondsPrepareTime],
                                                [NSNumber numberWithInteger:_fullSecondsTimeLapSoundTime]
                                                ]];
    
    [savedData setObject:intervalsStopwatchArray forKey:@"intervalsStopwatchArray"];
    [savedData synchronize];
}


- (IBAction)saveBarButtonAction:(id)sender
{
    [self saveDataNSUserDefaults];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:AppUpdateThemeNotificationName object:nil];
}


- (void)removeObserver
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AppUpdateThemeNotificationName object:nil];
}


- (void)updateUI
{
    [_customNavigationBarView setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
     [_customNavigationBarViewIpad setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[AppTheme sharedManager] labelColor],
       NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]}];
    [self.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[[AppTheme sharedManager]labelColor],
                                                     NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]} forState:UIControlStateNormal];
}


- (void)dealloc
{
    [self removeObserver];
}


@end
