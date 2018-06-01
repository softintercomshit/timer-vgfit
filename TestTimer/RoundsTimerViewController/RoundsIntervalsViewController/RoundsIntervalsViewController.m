//
//  RoundsSettingsTableViewController.m
//  TestTimer
//
//  Created by a on 1/18/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "RoundsIntervalsViewController.h"
#import "CustomHeaderTableViewCell.h"
#import "CustomIntervalsTableViewCell.h"
#import "AddNewTimerRoundsViewController.h"
#import "PrepareTimeViewController.h"
#import "RoundsTimeViewController.h"
#import "RoundsViewController.h"
#import "AppTheme.h"
#import "NewCustomHeaderTableViewCell.h"
#import "RestTimeViewController.h"
#import "CustomWorkoutTableViewCell.h"
#import "CustomNavigationBarUIView.h"


@interface RoundsIntervalsViewController ()<PrepareTimeViewControllerDelegate,
                                            RoundsTimeViewControllerDelegate,
RestTimeViewControllerDelegate,
RoundsViewControllerDelegate>

@property (strong, nonatomic) RoundsWorkouts *selectedRoundsWorkout;
@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavBarView;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;

@end
@implementation RoundsIntervalsViewController
{
    NSArray *roundsTitlesForIntervals;
    NSArray *roundsDescriptionForIntervals;
    NSMutableArray *roundsValuesForIntervals;
    NSArray *roundsTitleHeader;
    NSArray *headerRoundImages;
    NSString *secFullValueRoundsTime;
    NSString *secFullValuePrepareTime;
    NSString *roundsFullValue;
    UIButton *editButton;
    NSIndexPath *previousIndexPath,*currentIndexPath;
    
    __weak IBOutlet NSLayoutConstraint *heightConstraintForNavigationBar;
    
    NSMutableArray *intervalsRoundsArray;
    NSMutableArray *colorsRoundsArray;
    
}
//@synthesize device;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBarButtonItem];
    [self loadDataFromNSUserDefaults];
    self.title = @"Rounds".localized;
    [self updateUI];
    [self staticDataFromArrays];
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



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        [_customNavBarView setupLandscapeConstraint];
    }else{
        [_customNavBarView setupPortraitConstraint];
    }
    [self updateUI];
    self.roundsWorkout =[[DatabaseManager sharedInstance] getRoundsWorkouts] ;
    self.arrayWorkout = [self.roundsWorkout mutableCopy];
    
    [self.dataFromTableView reloadData];
    
    self.dataFromTableView.tableFooterView = [UIView new];
}

- (void)customBarButtonItem
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


-(void) staticDataFromArrays
{
    roundsTitlesForIntervals = [NSArray arrayWithObjects:@"Prepare".localized,
                                @"Work".localized,
                                @"Rest".localized,
                                @"Rounds".localized,nil];
    
    roundsDescriptionForIntervals = [NSArray arrayWithObjects:@"Countdown before you start".localized,
                                     @"Work for this long".localized,
                                     @"Rest for this long".localized,
                                     @"One round is work + rest".localized,
                                     nil];
    
    roundsTitleHeader = [NSArray arrayWithObjects:@"Intervals".localized,
                         @"My workouts".localized,
                         nil];
    headerRoundImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"icInterval.png"],[UIImage imageNamed:@"icMyWorkouts.png"], nil];
}


-(void) loadDataFromNSUserDefaults
{
    NSUserDefaults *loadData = [NSUserDefaults standardUserDefaults];
    
    //prepare
    _dateFullSecPrepare = [loadData integerForKey:@"dateFullSecPrepare"];
    _selectedPrepareTimeMinValue = [loadData integerForKey:@"selectedPrepareTimeMin"];
    _selectedPrepareTimeSecValue = [loadData integerForKey:@"selectedPrepareTimeSec"];
    _selectedColorCollectionViewCellIndex = [loadData integerForKey:@"selectedColorCollectionViewCellIndex"];
    
    //round time(Work)
    _selectedPickedMinValue = [loadData integerForKey:@"selectedPickedMinValue"];
    _selectedPickedSecValue = [loadData integerForKey:@"selectedPickedSecValue"];
    _fullValueSecRTVC = [loadData integerForKey:@"fullValueSecRTVC"];
    
    // rest time
    _pickedRestMinValue = [loadData integerForKey:@"pickedRestMinValue"];
    _pickedRestSecValue = [loadData integerForKey:@"pickedRestSecValue"];
    _fullValueRestTimeValue = [loadData integerForKey:@"fullValueRestTimeValue"];
    _selectedColorCellIndexRestTime = [loadData integerForKey:@"selectedColorCellIndexRestTime"];
    
    //rounds
    _roundsValue = [loadData integerForKey:@"roundsValue"];
    _selectedRoundValue = [loadData integerForKey:@"selectedRoundValue"];
    _selectedColorCellIndexRoundsTime = [loadData integerForKey:@"selectedColorCellIndexRoundsTime"];
    _pickedColorForCell = [loadData integerForKey:@"pickedColorForCell"];
    
    intervalsRoundsArray = [[NSMutableArray alloc] initWithArray:[loadData objectForKey:@"intervalsRoundsArray"]];
    colorsRoundsArray = [[NSMutableArray alloc] initWithArray:[loadData objectForKey:@"colorsRoundsArray"]];
    
}



#pragma mark - Table view data source


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
        cell.uiLabel.text =[roundsTitleHeader objectAtIndex:section];
        cell.uiImageView.image =[headerRoundImages objectAtIndex:section];
        
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
        (!self.dataFromTableView.editing)?[cell.editButton setTitle:@"Edit".localized forState:UIControlStateNormal] :[cell.editButton setTitle:@"Done".localized forState:UIControlStateNormal];
        return  cell.contentView;
    }
}


#pragma mark - Edit button Method implementation

-(void) editButtonMethodImplementation:(id)sender
{
    [self.dataFromTableView setEditing:!self.dataFromTableView.editing animated:true];
    
    (!self.dataFromTableView.editing)?[sender setTitle:@"Edit".localized forState:UIControlStateNormal] :[sender setTitle:@"Done".localized forState:UIControlStateNormal];
    
    if (!self.dataFromTableView.editing) {
        int i = 0 ;
        for (RoundsWorkouts *row in self.roundsWorkout)
        {
            row.roundsID = [NSNumber numberWithInt:i++];
        }
        [[DatabaseManager sharedInstance] saveContext];
    }
    [self.dataFromTableView reloadData];
}


-(void)addNewTimer:(id)sender
{
    AddNewTimerRoundsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewTimerRoundsViewController"];
    viewController.managedObject =self.device;
    [self.navigationController pushViewController:viewController animated:YES];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 4;
    }
    else{
        return [_arrayWorkout count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 64;
    }
    else
        return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    }
    else
        return 124;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier1 = @"CustomIntervalsTableViewCell";
    static NSString *cellIdentifier2 = @"CustomWorkoutTableViewCell";
    if (indexPath.section==0) {
        
        CustomIntervalsTableViewCell *cell = (CustomIntervalsTableViewCell * )[_dataFromTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1 owner:self options:nil];
            cell = (CustomIntervalsTableViewCell *) [nib objectAtIndex:0];
        }
        self.dataFromTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.dataFromTableView.separatorColor = [UIColor grayColor];
        cell.customIntervalsTitleLabel.text =[roundsTitlesForIntervals objectAtIndex:indexPath.row];
        cell.customIntervalsDescriptionLabel.text =[roundsDescriptionForIntervals objectAtIndex:indexPath.row];
        cell.customIntervalsTimeValueLabel.text =[roundsValuesForIntervals objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0 && indexPath.section == 0) {
            cell.customIntervalsTimeValueLabel.text = [self formattedTimeTableView:_dateFullSecPrepare];
            cell.colorImageViewCollectionCell.image = [Utilities loadRoundsIntervalsColorForIndex:_selectedColorCollectionViewCellIndex == 0 ? _selectedColorCollectionViewCellIndex = 1 : _selectedColorCollectionViewCellIndex];
        }
        if (indexPath.row == 1 && indexPath.section == 0) {
            cell.customIntervalsTimeValueLabel.text = [self formattedTimeTableView:_fullValueSecRTVC];
            cell.colorImageViewCollectionCell.image = [Utilities loadRoundsIntervalsColorForIndex:_selectedColorCellIndexRoundsTime == 0 ? _selectedColorCellIndexRoundsTime = 2 : _selectedColorCellIndexRoundsTime];
        }
        if (indexPath.row == 2 && indexPath.section == 0) {
            cell.customIntervalsTimeValueLabel.text = [self formattedTimeTableView:_fullValueRestTimeValue];
            cell.colorImageViewCollectionCell.image = [Utilities loadRoundsIntervalsColorForIndex:_selectedColorCellIndexRestTime == 0 ? _selectedColorCellIndexRestTime = 5 : _selectedColorCellIndexRestTime];
        }
        if (indexPath.row == 3 && indexPath.section == 0) {
            cell.customIntervalsTimeValueLabel.text = [NSString stringWithFormat:@"%ld",_roundsValue];
            cell.colorImageViewCollectionCell.image = [Utilities loadRoundsIntervalsColorForIndex:_pickedColorForCell == 0 ? _pickedColorForCell = 3 : _pickedColorForCell];
        }
        return cell;
    }
    else{
        
        CustomWorkoutTableViewCell *cell = (CustomWorkoutTableViewCell * )[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier2 owner:self options:nil];
            cell = (CustomWorkoutTableViewCell *) [nib objectAtIndex:0];
        }
        
        
        self.device =[self.arrayWorkout objectAtIndex:indexPath.row];
        NSString *prepareTimeRounds =[NSString stringWithFormat:@"%@",[self timeFormatted:[[self.device valueForKey:@"prepareTimeRounds"]intValue]]] ;
        NSString *workTimeRounds = [NSString stringWithFormat:@"%@",[self timeFormatted:[[self.device valueForKey:@"workTimeRounds"]intValue]]];
        NSString *restTimeRounds = [NSString stringWithFormat:@"%@",[self timeFormatted:[[self.device valueForKey:@"restTimeRounds"]intValue]]];
        NSString *roundsRounds = [NSString stringWithFormat:@"%@", [self.device valueForKey:@"roundsRounds"]];
        NSString *workoutRoundsName = [NSString stringWithFormat:@"%@",[self.device valueForKey:@"workoutNameRounds"]];
        
        if ([workoutRoundsName isEqualToString:@""]) {
            workoutRoundsName = @"Rounds workout".localized;
        }
        
        
        NSArray *arrayWithData =[NSArray arrayWithObjects:prepareTimeRounds,workTimeRounds,restTimeRounds,roundsRounds, nil];
        
        
        NSArray *arrayWithObjectsFromRoundsCoreData = @[[NSNumber numberWithInteger:[[self.device valueForKey:@"prepareTimeRounds"]integerValue]],
                                                        [NSNumber numberWithInteger:[[self.device valueForKey:@"workTimeRounds"]integerValue]],
                                                        [NSNumber numberWithInteger:[[self.device valueForKey:@"restTimeRounds"]integerValue]],
                                                        [NSNumber numberWithInteger:[[self.device valueForKey:@"roundsRounds"]integerValue]]
                                                        ];
        
        
        NSArray *arrayWithRoundsObjects = @[[NSNumber numberWithInteger:_dateFullSecPrepare],
                                            [NSNumber numberWithInteger:_fullValueSecRTVC],
                                            [NSNumber numberWithInteger:_fullValueRestTimeValue],
                                            [NSNumber numberWithInteger:_roundsValue]
                                            ];
        NSLog(@"array objects----------------------->%@",arrayWithObjectsFromRoundsCoreData);
        NSLog(@"array workout----------------------->%@",arrayWithRoundsObjects);
        BOOL arraysAreEqual = [arrayWithRoundsObjects isEqualToArray:arrayWithObjectsFromRoundsCoreData];
        NSString  *defaultsRoundsSelectedWorkoutSet = [[NSUserDefaults standardUserDefaults] objectForKey:kRoundsSelectedWorkoutSet];
        NSLog(@"time stamp: %@",defaultsRoundsSelectedWorkoutSet);
        
        if ([[self.device valueForKey:@"workoutTimeStampRounds"] isEqualToString:defaultsRoundsSelectedWorkoutSet] && arraysAreEqual && !_dataFromTableView.editing) {
            [cell.checkMarkImageView setHidden:false];
        }else{
            [cell.checkMarkImageView setHidden:true];
        }
        
        [cell setRoundsTimerWorkoutValuesInTableViewCell:arrayWithData andTitle:workoutRoundsName];
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        PrepareTimeViewController *vc0 =[self.storyboard instantiateViewControllerWithIdentifier:@"PrepareTimeViewController"];
        RoundsTimeViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"RoundsTimeViewController"];
        RestTimeViewController *vc1 =[self.storyboard instantiateViewControllerWithIdentifier:@"RestTimeViewController"];
        RoundsViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundsViewController"];
        NSInteger pickController= indexPath.row;
        switch (pickController) {
            case 0:
                vc0.fullValuePrepareTimeSeconds = _dateFullSecPrepare;
                vc0.selectedRowMinForPrepare = _selectedPrepareTimeMinValue;
                vc0.selectedRowSecForPrepare = _selectedPrepareTimeSecValue;
                vc0.selectedIndexInCollectionView = _selectedColorCollectionViewCellIndex;
                vc0.delegate=self;
                vc0.type = @"2";
                [self.navigationController pushViewController:vc0 animated:YES];
                break;
            case 1:
                vc.fullValuesSeconds = _fullValueSecRTVC;
                vc.roundTimeMin=_selectedPickedMinValue;
                vc.roundTimeSec=_selectedPickedSecValue;
                vc.selectedIndexInCollectionViewCell = _selectedColorCellIndexRoundsTime;
                vc.delegate=self;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            case 2:
                vc1.fullValueSeconds = _fullValueRestTimeValue;
                vc1.selectedRowinMin=_pickedRestMinValue;
                vc1.selectedRowinSec=_pickedRestSecValue;
                vc1.selectedRestTimeIndexInCollectionView = _selectedColorCellIndexRestTime;
                vc1.delegate=self;
                [self.navigationController pushViewController:vc1 animated:YES];
                break;
            case 3:
                vc2.rounds = _roundsValue;
                vc2.selectedRowForRounds=_selectedRoundValue;
                vc2.selectedRecordInCollectionView = _pickedColorForCell;
                vc2.delegate=self;
                [self.navigationController pushViewController:vc2 animated:YES];
                break;
            default:
                break;
        }
    }
    
    if (indexPath.section==1)
    {
        
        
        self.device=[self.arrayWorkout objectAtIndex:indexPath.row];
        _dateFullSecPrepare = [[self.device valueForKey:@"prepareTimeRounds"] integerValue];
        NSLog(@"%ld",_dateFullSecPrepare);
        _selectedPrepareTimeMinValue = _dateFullSecPrepare/60;
        _selectedPrepareTimeSecValue = _dateFullSecPrepare%60;
        
        
        _fullValueSecRTVC = [[self.device valueForKey:@"workTimeRounds"]integerValue];
        NSLog(@"%ld",_fullValueSecRTVC);
        _selectedPickedMinValue = _fullValueSecRTVC/60;
        _selectedPickedSecValue = _fullValueSecRTVC%60;
        
        _fullValueRestTimeValue =[[self.device valueForKey:@"restTimeRounds"]integerValue];
        _pickedRestMinValue =_fullValueRestTimeValue/60;
        _pickedRestSecValue =_fullValueRestTimeValue%60;
        
        
        
        _roundsValue = [[self.device valueForKey:@"roundsRounds"]integerValue];
        _selectedRoundValue = _roundsValue - 1;
        [_dataFromTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:[self.device valueForKey:@"workoutTimeStampRounds"] forKey:kRoundsSelectedWorkoutSet];
        NSLog(@"time stamp: %@",[self.device valueForKey:@"workoutTimeStampRounds"]);
        
        [_dataFromTableView reloadData];
        
        if (self.dataFromTableView.editing) {
            AddNewTimerRoundsViewController *viewC =[self.storyboard instantiateViewControllerWithIdentifier:@"AddNewTimerRoundsViewController"];
            viewC.isEditingTimer = true;
            viewC.managedObject = self.device;
            [self setEditing: true animated:true];
            [self.navigationController pushViewController:viewC animated:true];
        }
    }
}

- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}
- (NSString *)timeFormatted:(int)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
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



#pragma mark - Delete workout from database and from table view cell


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section!=0){
        
        return true;
    }
    else
        return false;
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=0) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            RoundsWorkouts *devices = [self.arrayWorkout objectAtIndex:indexPath.row];
            [[DatabaseManager sharedInstance] deleteRoundsWorkout:devices];
            
            [self.arrayWorkout  removeObjectAtIndex:indexPath.row];
            
            [self.dataFromTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
            
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
    
    RoundsWorkouts *row = [self.arrayWorkout objectAtIndex:sourceIndexPath.row];
    [self.arrayWorkout removeObjectAtIndex:sourceIndexPath.row];
    [self.arrayWorkout insertObject:row atIndex:destinationIndexPath.row];
}

- (void)dataFromPrepareTimeViewController:(NSInteger)data pickedPrepareTimeMinValue:(NSInteger)minPick pickedPrepareTimeSecValue:(NSInteger)secPick pickedColorCollectionViewCell:(NSInteger)pickedColor
{
    _dateFullSecPrepare = data;
    _selectedPrepareTimeMinValue = minPick;
    _selectedPrepareTimeSecValue = secPick;
    _selectedColorCollectionViewCellIndex  = pickedColor;
    [_dataFromTableView reloadData];
}

- (void)dataFromRoundTimeMinViewController:(NSInteger)fullSecData pickedMinValue:(NSInteger)minPicked pickedSecValue:(NSInteger)secPick pickedColorCell:(NSInteger)selectedColorIndex
{
    
    _fullValueSecRTVC = fullSecData;
    _selectedPickedMinValue = minPicked;
    _selectedPickedSecValue = secPick;
    _selectedColorCellIndexRoundsTime =selectedColorIndex;
    [_dataFromTableView reloadData];
}


- (void)dataFromRestTimeMinViewController:(NSInteger)fullData pickedMinuteValue:(NSInteger)minPick pickedSecondValue:(NSInteger)secPick pickedColor:(NSInteger)secColor
{
    _fullValueRestTimeValue =fullData;
    _pickedRestMinValue= minPick;
    _pickedRestSecValue = secPick;
    _selectedColorCellIndexRestTime =secColor;
    [_dataFromTableView reloadData];
}


- (void)dataFromRoundsViewController:(NSInteger)data pickedRoundsValue:(NSInteger)roundsPick pickedColorCollectionViewCell:(NSInteger)pickedColor
{
    _roundsValue = data;
    _selectedRoundValue = roundsPick;
    _pickedColorForCell = pickedColor;
    [_dataFromTableView reloadData];
    //    NSLog(@"%ld",_roundsValue);
}

- (void) cancelBarButtonAction:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];
}


- (void) saveToNSUserDefaults{
    NSUserDefaults *savedRoundsTimerData = [NSUserDefaults standardUserDefaults];
    
    //prepare
    
    [savedRoundsTimerData setInteger:_dateFullSecPrepare forKey:@"dateFullSecPrepare"];
    [savedRoundsTimerData setInteger:_selectedPrepareTimeMinValue forKey:@"selectedPrepareTimeMin"];
    [savedRoundsTimerData setInteger:_selectedPrepareTimeSecValue forKey:@"selectedPrepareTimeSec"];
    [savedRoundsTimerData setInteger:_selectedColorCollectionViewCellIndex forKey:@"selectedColorCollectionViewCellIndex"];
    
    //roundtime(Work)
    
    [savedRoundsTimerData setInteger:_fullValueSecRTVC forKey:@"fullValueSecRTVC"];
    [savedRoundsTimerData setInteger:_selectedPickedMinValue forKey:@"selectedPickedMinValue"];
    [savedRoundsTimerData setInteger:_selectedPickedSecValue forKey:@"selectedPickedSecValue"];
    [savedRoundsTimerData setInteger:_selectedColorCellIndexRoundsTime forKey:@"selectedColorCellIndexRoundsTime"];
    
    //rest
    
    [savedRoundsTimerData setInteger:_fullValueRestTimeValue forKey:@"fullValueRestTimeValue"];
    [savedRoundsTimerData setInteger:_pickedRestMinValue forKey:@"pickedRestMinValue"];
    [savedRoundsTimerData setInteger:_pickedRestSecValue forKey:@"pickedRestSecValue"];
    [savedRoundsTimerData setInteger:_selectedColorCellIndexRestTime forKey:@"selectedColorCellIndexRestTime"];
    
    //rounds
    
    [savedRoundsTimerData setInteger:_roundsValue forKey:@"roundsValue"];
    [savedRoundsTimerData setInteger:_selectedRoundValue forKey:@"selectedRoundValue"];
    [savedRoundsTimerData setInteger:_pickedColorForCell forKey:@"pickedColorForCell"];
    
    [savedRoundsTimerData synchronize];
    
    
    [intervalsRoundsArray removeAllObjects];
    [colorsRoundsArray removeAllObjects];
    
    [intervalsRoundsArray addObjectsFromArray:@[[NSNumber numberWithInteger:_dateFullSecPrepare],
                                                [NSNumber numberWithInteger:_fullValueSecRTVC],
                                                [NSNumber numberWithInteger:_fullValueRestTimeValue],
                                                [NSNumber numberWithInteger:_roundsValue]
                                                ]];
    
    [colorsRoundsArray addObjectsFromArray:@[[NSNumber numberWithInteger:_selectedColorCollectionViewCellIndex == 0 ? _selectedColorCollectionViewCellIndex = 1 : _selectedColorCollectionViewCellIndex],
                                             [NSNumber numberWithInteger:_selectedColorCellIndexRoundsTime == 0 ? _selectedColorCellIndexRoundsTime = 2 : _selectedColorCellIndexRoundsTime],
                                             [NSNumber numberWithInteger:_selectedColorCellIndexRestTime == 0 ? _selectedColorCellIndexRestTime = 5 : _selectedColorCellIndexRestTime],
                                             [NSNumber numberWithInteger:_pickedColorForCell == 0 ? _pickedColorForCell = 3 : _pickedColorForCell]
                                             ]];
    
    [savedRoundsTimerData setObject:intervalsRoundsArray forKey:@"intervalsRoundsArray"];
    [savedRoundsTimerData setObject:colorsRoundsArray forKey:@"colorsRoundsArray"];
    
    [[AppColorManager sharedInstanceManager]updateRoundsColors];
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) saveBarButtonAction:(id)sender{

    [self saveToNSUserDefaults];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)addObserver{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:AppUpdateThemeNotificationName object:nil];
}


- (void)removeObserver{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AppUpdateThemeNotificationName object:nil];
}


- (void)updateUI{
    
    [_customNavBarView setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
     [_customNavigationBarViewIpad setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[AppTheme sharedManager] labelColor],
       NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]}];
    [self.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[[AppTheme sharedManager]labelColor],
                                                     NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]}
                                          forState:UIControlStateNormal];
}


- (void)dealloc {
    
    [self removeObserver];
}


@end
