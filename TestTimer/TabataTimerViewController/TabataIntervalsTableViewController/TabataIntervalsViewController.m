
//
//  TabataSettingsTableViewController.m
//  TestTimer
//
//  Created by a on 12/30/15.
//  Copyright © 2015 SoftIntercom. All rights reserved.
//

#import "TabataIntervalsViewController.h"
#import "CustomHeaderTableViewCell.h"
#import "CustomIntervalsTableViewCell.h"
#import "AddNewTimerTabataViewController.h"
#import "PrepareTimeViewController.h"
#import "WorkTimeViewController.h"
#import "RestTimeViewController.h"
#import "RoundsViewController.h"
#import "CyclesViewController.h"
#import "RestBetweenCyclesViewController.h"
#import "AppTheme.h"
#import "NewCustomHeaderTableViewCell.h"
#import "CustomWorkoutTableViewCell.h"
#import "CustomNavigationBarUIView.h"

@interface TabataIntervalsViewController () <PrepareTimeViewControllerDelegate,
WorkTimeViewControllerDelegate,
RoundsViewControllerDelegate,
RestTimeViewControllerDelegate,
CyclesViewControllerDelegate,
RestBetweenCyclesViewControllerDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavBarView;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;

@property (strong,nonatomic) NSMutableArray <TabatasWorkouts*> *workoutArray;



@end

@implementation TabataIntervalsViewController

{
    NSArray *test;
    NSArray *tabataTitlesForIntervals;
    NSArray *tabataDescriptionForIntervals;
    NSMutableArray *tabataValuesForIntervals;
    NSArray *tabataTitleHeader;
    NSArray *headerImages;
    
    __weak IBOutlet NSLayoutConstraint *heightConstraintForNavigationBar;
    NSIndexPath *previousIndexPath,*currentIndexPath;
    
    
    NSMutableArray *intervalsTabataArray;
    NSMutableArray *colorsTabataArray;
}

@synthesize device;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self dataFromArrays];
    
    [self.dataFromTableView registerNib:[UINib nibWithNibName:@"CustomIntervalsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomIntervalsTableViewCell"];
    [self.dataFromTableView registerNib:[UINib nibWithNibName:@"CustomWorkoutTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomWorkoutTableViewCell"];
    //    NSLog(@"%@",_selectedWorkOutIndex);
    [self navBarButtonItems];
    [self loadDataFromNSUserDefaults];
    self.title = @"Tabata".localized;
    [[NSUserDefaults standardUserDefaults] boolForKey:@"test"];
    [self updateUI];
    [self loadNibs];
}

- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        [_customNavBarView setupLandscapeConstraint];
    }else{
        [_customNavBarView setupPortraitConstraint];
    }
      [self.dataFromTableView reloadData];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavbarBackgroundImage];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:20.0]
                                                                    };
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        [_customNavBarView setupLandscapeConstraint];
        
    }else{
        [_customNavBarView setupPortraitConstraint];
    }
    
    [self updateUI];
    self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
    test =[[DatabaseManager sharedInstance] getTabataWorkouts] ;
    
    self.arrayWorkout = [test mutableCopy];
    
    [self.dataFromTableView reloadData];
    [self dataFromArrays];
    
    self.dataFromTableView.tableFooterView = [UIView new];
    
}


-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
         [_customNavBarView setupLandscapeConstraint];
    }else{
         [_customNavBarView setupPortraitConstraint];
    }
}


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
        [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateInterfaceOrientation:toInterfaceOrientation];
}

#pragma mark - Device orientation


-(void)navBarButtonItems
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

- (void) dataFromArrays
{
    tabataTitlesForIntervals = [NSArray arrayWithObjects:@"Prepare".localized,
                                @"Work".localized,
                                @"Rest".localized,
                                @"Rounds".localized,
                                @"Cycles".localized,
                                @"Rest between cycles".localized,
                                nil];
    
    NSString *cyclesDescriptionTextPrefix = @"One cycle is".localized;
    NSString *cyclesDescriptionTextSuffix = @"rounds".localized;
    
    tabataDescriptionForIntervals = [NSArray arrayWithObjects:@"Countdown before you start".localized,
                                     @"Do exercises for this long".localized,
                                     @"Rest for this long".localized,
                                     @"One round is work + rest".localized,
                                      [NSString stringWithFormat:@"%@ %ld %@",cyclesDescriptionTextPrefix,_fullRoundsValue,cyclesDescriptionTextSuffix],
//                                     @"One cycle is 2 rounds".localized,
                                     @"Recovery interval".localized,
                                     nil];
    

    
    tabataTitleHeader = [NSArray arrayWithObjects:@"Intervals".localized,
                         @"My workouts".localized ,
                         nil];
    headerImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"icInterval.png"],[UIImage imageNamed:@"icMyWorkouts.png"],nil];
}


- (void) loadDataFromNSUserDefaults
{
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    //prepare
    _fullSecPrepare = [data integerForKey:@"fullSecPrepare"];
    _selectedPrepareMinTimeValue = [data integerForKey:@"selectedPrepareMinTimeValue"];
    _selectedPrepareSecTimeValue =[data integerForKey:@"selectedPrepareSecTimeValue"];
    _selectedPrepareColorForCell = [data integerForKey:@"selectedColorForCell"];
    
    //worktime
    
    _selectedSecondsFullValue = [data integerForKey:@"selectedSecondsFullValue"];
    _selectedPickedMinValue= [data integerForKey:@"workTimePickedMinValue"];
    _selectedPickedSecValue=[data integerForKey:@"workTimePickedSecValue"];
    
    
    //resttime
    
    _fullValueSecRV =[data integerForKey:@"fullValueSecRV"];
    //_selectedSecondsFull = [defaults integerForKey:@"selectedSecondsFull"];
    _selectedPickedMinValueR = [data integerForKey:@"selectedPickedMinValueR"];
    _selectedPickedSecValueR = [data integerForKey:@"selectedPickedSecValueR"];
    
    //rounds
    
    _fullRoundsValue = [data integerForKey:@"fullRoundsValue"];
    _selectedPickedRoundsValue = [data integerForKey:@"selectedPickedRoundsValue"];
    _selectedRoundsColorForCell = [data integerForKey:@"selectedRoundsColorForCell"];
    
    //cycles
    
    _fullCyclesValue = [data integerForKey:@"fullCyclesValue"];
    _selectedPickedCyclesValue = [data integerForKey:@"selectedPickedCyclesValue"];
    _selectedCyclesColorForCell = [data integerForKey:@"selectedCyclesColorForCell"];
    
    //restBetweenCycles
    
    _fullValueSecRestBetweenCycles = [data integerForKey:@"fullValueSecRBC"];
    _selectedPickedMinValueRestBetweenCycles = [data integerForKey:@"selectedPickedMinValueRBC"];
    _selectedPickedSecValueRestBetweenCycles = [data integerForKey:@"selectedPickedSecValueRBC"];
    
    
    //color prepare time
    // _selectedPrepareColorForCell = [data integerForKey:@"selectedColorForCell"];
    _selectedWorkTimeColorForCell = [data integerForKey:@"selectedWorkTimeColorForCell"];
    _selectedRestTimeColorForCell = [data integerForKey:@"selectedRestTimeColorForCell"];
    _selectedRestBetweenCyclesTimeColorForCell = [data integerForKey:@"selectedRestBetweenCyclesTimeColorForCell"];
    
    intervalsTabataArray = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"intervalsTabataArray"]];
    colorsTabataArray = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"colorsTabataArray"]];
    [data synchronize];
}

- (void)loadNibs
{
    UINib *nib1 = [UINib nibWithNibName:@"CustomHeaderTableViewCell" bundle:nil];
    [[self dataFromTableView] registerNib:nib1 forCellReuseIdentifier:@"CustomHeaderTableViewCell"];
    UINib *nib2 = [UINib nibWithNibName:@"NewCustomHeaderTableViewCell" bundle:nil];
    [[self dataFromTableView] registerNib:nib2 forCellReuseIdentifier:@"NewCustomHeaderTableViewCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellIdentifier = @"CustomHeaderTableViewCell";
    static NSString *cellIdentifier1 = @"NewCustomHeaderTableViewCell";
    
    if (section==0) {
        
        NewCustomHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        
        cell.uiLabel.text =[tabataTitleHeader objectAtIndex:section];
        cell.uiImageView.image =[headerImages objectAtIndex:section];
        return cell.contentView;
    }
    else
    {
        CustomHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [cell.editButton addTarget:self action:@selector(editButtonMethodImplementation:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addNewTimerButton addTarget:self action:@selector(addNewTimer) forControlEvents:UIControlEventTouchUpInside];
        
        (!self.dataFromTableView.editing)?[cell.editButton setTitle:@"Edit".localized forState:UIControlStateNormal] :[cell.editButton setTitle:@"Done".localized forState:UIControlStateNormal];
        return cell.contentView;
    }
}



#pragma mark - Edit button Method implementation
-(void) editButtonMethodImplementation:(id)sender
{
    [self.dataFromTableView setEditing:!self.dataFromTableView.editing animated:true];
    
    (!self.dataFromTableView.editing)?[sender setTitle:@"Edit".localized forState:UIControlStateNormal] :[sender setTitle:@"Done".localized forState:UIControlStateNormal];
    
    if (!self.dataFromTableView.editing) {
        int i = 0 ;
        for (TabatasWorkouts *row in self.arrayWorkout)
        {
            row.tabataID = [NSNumber numberWithInt:i++];
        }
        [[DatabaseManager sharedInstance] saveContext];
    }
    [self.dataFromTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        return 6;
    }
    else{
        return  [self.arrayWorkout count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 64;
    }
    else
        return 142;
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
    
    static NSString *cellIdentifier1 = @"CustomIntervalsTableViewCell";
    static NSString *cellIdentifier2 = @"CustomWorkoutTableViewCell";
    if (indexPath.section==0) {
        CustomIntervalsTableViewCell *cell = (CustomIntervalsTableViewCell * )[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1 owner:self options:nil];
            cell = (CustomIntervalsTableViewCell *) [nib objectAtIndex:0];
            
        }

        cell.customIntervalsTitleLabel.text =[tabataTitlesForIntervals objectAtIndex:indexPath.row];
        cell.customIntervalsDescriptionLabel.text =[tabataDescriptionForIntervals objectAtIndex:indexPath.row];
        cell.customIntervalsTimeValueLabel.text =[tabataValuesForIntervals objectAtIndex:indexPath.row];
        cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"checkOpen.png"]];
        
        if (indexPath.row==0 && indexPath.section ==0) {
            
            cell.customIntervalsTimeValueLabel.text = [self formattedTimeTableView:_fullSecPrepare];
            cell.colorImageViewCollectionCell.image = [Utilities loadTabataIntervalsColorForIndex:_selectedPrepareColorForCell == 0 ? _selectedPrepareColorForCell = 1 : _selectedPrepareColorForCell];
        }
        if (indexPath.row==1 && indexPath.section ==0) {
            cell.customIntervalsTimeValueLabel.text =[self formattedTimeTableView:_selectedSecondsFullValue];
             cell.colorImageViewCollectionCell.image = [Utilities loadTabataIntervalsColorForIndex:_selectedWorkTimeColorForCell == 0 ? _selectedWorkTimeColorForCell = 2 : _selectedWorkTimeColorForCell];
        }
        if (indexPath.row==2 && indexPath.section ==0) {
            
            cell.customIntervalsTimeValueLabel.text =[self formattedTimeTableView:_fullValueSecRV];
             cell.colorImageViewCollectionCell.image = [Utilities loadTabataIntervalsColorForIndex:_selectedRestTimeColorForCell == 0 ? _selectedRestTimeColorForCell = 5 : _selectedRestTimeColorForCell];
        }
        if (indexPath.row==3 && indexPath.section ==0) {
            
            cell.customIntervalsTimeValueLabel.text =[NSString stringWithFormat:@"%ld",_fullRoundsValue];
             cell.colorImageViewCollectionCell.image = [Utilities loadTabataIntervalsColorForIndex:_selectedRoundsColorForCell == 0 ? _selectedRoundsColorForCell = 3 : _selectedRoundsColorForCell];
        }
        if (indexPath.row==4 && indexPath.section ==0) {
            
            cell.customIntervalsTimeValueLabel.text =[NSString stringWithFormat:@"%ld",_fullCyclesValue];
             cell.colorImageViewCollectionCell.image = [Utilities loadTabataIntervalsColorForIndex:_selectedCyclesColorForCell == 0 ? _selectedCyclesColorForCell = 4 : _selectedCyclesColorForCell];
        }
        if (indexPath.row==5 && indexPath.section ==0) {
            
            cell.customIntervalsTimeValueLabel.text =[self formattedTimeTableView:_fullValueSecRestBetweenCycles];
             cell.colorImageViewCollectionCell.image = [Utilities loadTabataIntervalsColorForIndex:_selectedRestBetweenCyclesTimeColorForCell == 0 ? _selectedRestBetweenCyclesTimeColorForCell = 5 : _selectedRestBetweenCyclesTimeColorForCell];
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
        
        self.device = self.arrayWorkout[indexPath.row];
        
        NSString *workoutTabataName = [NSString stringWithFormat:@"%@",[self.device valueForKey:@"workoutName"]];
        if ([workoutTabataName isEqualToString:@""]) {
            workoutTabataName = [NSString stringWithFormat:@"%@", @"Tabata workout".localized];
        }
        NSString *prepareTimeTabataString = [self timeFormatted:[[self.device valueForKey:@"prepareTime"]intValue]];
        NSString *workTimeTabataString = [self timeFormatted:[[self.device valueForKey:@"workTime"]intValue]];
        NSString *restTimeTabataString = [self timeFormatted:[[self.device valueForKey:@"restTime"]intValue]];
        NSString *roundsValueTabataString =[NSString stringWithFormat:@"%@", [self.device valueForKey:@"roundsTabata"]];
        NSString *cyclesValueTabataString = [NSString stringWithFormat:@"%@", [self.device valueForKey:@"cyclesTabata"]];
        NSString *restBetweenCyclesTabataString = [self timeFormatted:[[self.device valueForKey:@"restBetweenCyclesTime"]intValue]];
        
        NSArray *arrayWithObjects = [NSArray arrayWithObjects:prepareTimeTabataString,workTimeTabataString,
                                     restTimeTabataString,roundsValueTabataString,
                                     cyclesValueTabataString,restBetweenCyclesTabataString, nil];
        
        NSArray *arrayWithObjectsTabataData = @[[NSNumber numberWithInteger:_fullSecPrepare],
                                                [NSNumber numberWithInteger:_selectedSecondsFullValue],
                                                [NSNumber numberWithInteger:_fullValueSecRV],
                                                [NSNumber numberWithInteger:_fullRoundsValue],
                                                
                                                [NSNumber numberWithInteger:_fullCyclesValue],
                                                [NSNumber numberWithInteger:_fullValueSecRestBetweenCycles]
                                                ];
        
        NSArray *arrayWithObjectsFromCoreData = @[[NSNumber numberWithInteger:[[self.device valueForKey:@"prepareTime"]integerValue]],
                                                  [NSNumber numberWithInteger:[[self.device valueForKey:@"workTime"]integerValue]],
                                                  [NSNumber numberWithInteger:[[self.device valueForKey:@"restTime"]integerValue]],
                                                  [NSNumber numberWithInteger:[[self.device valueForKey:@"roundsTabata"]integerValue]],
                                                  [NSNumber numberWithInteger:[[self.device valueForKey:@"cyclesTabata"]integerValue]],
                                                  [NSNumber numberWithInteger:[[self.device valueForKey:@"restBetweenCyclesTime"]integerValue]]
                                                  ];
        
        
        //        NSLog(@"array objects----------------------->%@",arrayWithObjectsTabataData);
        //        NSLog(@"array workout----------------------->%@",arrayWithObjectsFromCoreData);
        BOOL arraysAreEqual = [arrayWithObjectsTabataData isEqualToArray:arrayWithObjectsFromCoreData];
        NSString *defaultsTabataSelectedWorkoutSet = [[NSUserDefaults standardUserDefaults] objectForKey:kTabataSelectedWorkoutSet];
        NSLog(@"time stamp: %@",defaultsTabataSelectedWorkoutSet);
        
        
        
        if ([[self.device valueForKey:@"workoutTimeStamp"] isEqualToString:defaultsTabataSelectedWorkoutSet] && arraysAreEqual && !_dataFromTableView.editing) {
            [cell.checkMarkImageView setHidden:false];
        }else {
            [cell.checkMarkImageView setHidden:true];
        }
        
        [cell setTabataTimerWorkoutValuesInTableViewCell:arrayWithObjects andTitle:workoutTabataName];
        return cell;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0)
    {
        
        PrepareTimeViewController *vc0 = [self.storyboard instantiateViewControllerWithIdentifier:@"PrepareTimeViewController"];
        WorkTimeViewController *vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkTimeViewController"];
        RestTimeViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"RestTimeViewController"];
        RoundsViewController *vc3 = [self.storyboard instantiateViewControllerWithIdentifier:@"RoundsViewController"];
        CyclesViewController *vc4 = [self.storyboard instantiateViewControllerWithIdentifier:@"CyclesViewController"];
        RestBetweenCyclesViewController *vc5 = [self.storyboard instantiateViewControllerWithIdentifier:@"RestBetweenCyclesViewController"];
        
        
        NSInteger  pickViewController = indexPath.row;
        switch (pickViewController)
        {
            case 0:
                vc0.fullValuePrepareTimeSeconds =_fullSecPrepare;
                vc0.selectedRowMinForPrepare =_selectedPrepareMinTimeValue;
                vc0.selectedRowSecForPrepare = _selectedPrepareSecTimeValue;
                vc0.selectedIndexInCollectionView = _selectedPrepareColorForCell;
                vc0.collectionView.backgroundColor = [UIColor redColor];
                vc0.type =@"2";
                vc0.delegate =self;
                [self.navigationController pushViewController:vc0 animated:YES];
                break;
            case 1:
                vc1.fullValue = _selectedSecondsFullValue;
                vc1.selectedRowinMin=_selectedPickedMinValue;
                vc1.selectedRowinSec=_selectedPickedSecValue;
                vc1.selectedWorkTimeIndexInCollectionView =_selectedWorkTimeColorForCell;
                vc1.delegate=self;
                [self.navigationController pushViewController:vc1 animated:YES];
                break;
            case 2:
                vc2.fullValueSeconds = _fullValueSecRV;
                vc2.selectedRowinMin=_selectedPickedMinValueR;
                vc2.selectedRowinSec=_selectedPickedSecValueR;
                vc2.selectedRestTimeIndexInCollectionView = _selectedRestTimeColorForCell;
                vc2.delegate=self;
                [self.navigationController pushViewController:vc2 animated:YES];
                break;
            case 3:
                vc3.type =@"2";
                vc3.rounds = _fullRoundsValue;
                vc3.selectedRowForRounds=_selectedPickedRoundsValue;
                vc3.selectedRecordInCollectionView = _selectedRoundsColorForCell;
                vc3.delegate=self;
                [self.navigationController pushViewController:vc3 animated:YES];
                break;
            case 4:
                vc4.cycles = _fullCyclesValue;
                vc4.selectedRowForCycles = _selectedPickedCyclesValue;
                vc4.pickedRecordInCollectionView = _selectedCyclesColorForCell;
                vc4.delegate =self;
                [self.navigationController pushViewController:vc4 animated:YES];
                break;
            case 5:
                vc5.fullValuesRestBetweenCyclesSeconds =_fullValueSecRestBetweenCycles;
                vc5.selectedRestBetweenCyclesRowInMinutes =_selectedPickedMinValueRestBetweenCycles;
                vc5.selectedRestBetweenCyclesRowInSeconds = _selectedPickedSecValueRestBetweenCycles;
                vc5.selectedRestBetweenCyclesIndexInCollectionView = _selectedRestBetweenCyclesTimeColorForCell;
                vc5.delegate = self;
                [self.navigationController pushViewController:vc5 animated:YES];
                break;
            default:
                break;
        }
    }
    if (indexPath.section==1)
    {
        
        self.device=[self.arrayWorkout objectAtIndex:indexPath.row];
        _fullSecPrepare = [[self.device valueForKey:@"prepareTime"]integerValue];
        _selectedSecondsFullValue =[[self.device valueForKey:@"workTime"]integerValue];
        _fullValueSecRV = [[self.device valueForKey:@"restTime"]integerValue];
        _fullRoundsValue =[[self.device valueForKey:@"roundsTabata"]integerValue];
        _fullCyclesValue = [[self.device valueForKey:@"cyclesTabata"]integerValue];
        _fullValueSecRestBetweenCycles =[[self.device valueForKey:@"restBetweenCyclesTime"]integerValue];
        _selectedPrepareMinTimeValue = _fullSecPrepare/60;
        _selectedPrepareSecTimeValue = _fullSecPrepare%60;
        _selectedPickedMinValue = _selectedSecondsFullValue/60;
        _selectedPickedSecValue = _selectedSecondsFullValue%60;
        _selectedPickedMinValueR = _fullValueSecRV/60;
        _selectedPickedSecValueR = _fullValueSecRV%60;
        _selectedPickedRoundsValue = _fullRoundsValue-1;
        _selectedPickedCyclesValue  = _fullCyclesValue-1;
        _selectedPickedMinValueRestBetweenCycles = _fullValueSecRestBetweenCycles/60;
        _selectedPickedSecValueRestBetweenCycles = _fullValueSecRestBetweenCycles%60;
        
        [[NSUserDefaults standardUserDefaults] setObject:[self.device valueForKey:@"workoutTimeStamp"]
                                                  forKey:kTabataSelectedWorkoutSet];
        NSLog(@"time stamp: %@",[self.device valueForKey:@"workoutTimeStamp"]);
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_dataFromTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
        [_dataFromTableView reloadData];
        
        if(self.dataFromTableView.editing)
        {
            AddNewTimerTabataViewController *viewC =[self.storyboard instantiateViewControllerWithIdentifier:@"AddNewTimerTabataViewController"];
            viewC.isEditingTimer= true;
            viewC.managedObject = self.device;
            [self.navigationController pushViewController:viewC animated:true];
            [self setEditing: true animated:true];
            
        }
    }
    
}


- (NSString *)timeFormatted:(int)totalSeconds
{
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


-(void)addNewTimer
{
    AddNewTimerTabataViewController *viewC =[self.storyboard instantiateViewControllerWithIdentifier:@"AddNewTimerTabataViewController"];
    // [[DatabaseManager sharedInstance] getTabataWorkouts];
    //    viewC.isEditingTimer= edits;
    viewC.managedObject = device;
    [self.navigationController pushViewController:viewC animated:YES];
}




#pragma mark - Editarea Core Data workout

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=0)
    {
        return YES;
    }
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=0)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            
            TabatasWorkouts *devices = [self.arrayWorkout objectAtIndex:indexPath.row];
            
            // Delete object from database
            [[DatabaseManager sharedInstance] deleteTabataWorkout:devices];
            
            
            // Remove device from table view
            [self.arrayWorkout  removeObjectAtIndex:indexPath.row];
            
            [self.dataFromTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
            
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    TabatasWorkouts *row = [self.arrayWorkout objectAtIndex:sourceIndexPath.row];
    [self.arrayWorkout removeObjectAtIndex:sourceIndexPath.row];
    [self.arrayWorkout insertObject:row atIndex:destinationIndexPath.row];
}
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section)
    {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section)
        {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}
//preparetimeViewC delegate method
-(void)dataFromPrepareTimeViewController:(NSInteger)data pickedPrepareTimeMinValue:(NSInteger)minPick pickedPrepareTimeSecValue:(NSInteger)secPick pickedColorCollectionViewCell:(NSInteger)pickedColor
{
    _fullSecPrepare = data;
    _selectedPrepareMinTimeValue = minPick;
    _selectedPrepareSecTimeValue = secPick;
    //    NSLog(@"%ld",(long)_fullSecPrepare);
    _selectedPrepareColorForCell= pickedColor;
    [_dataFromTableView reloadData];
    
}
//worktimeViewC delegate method
-(void)dataFromWorkTimeMinViewController:(NSInteger)dataFullValue pickedMinuteValue:(NSInteger)minPick pickedSecondValue:(NSInteger)secPick pickedColorIndexValue:(NSInteger)colorIndex
{
    
    _selectedSecondsFullValue=dataFullValue;
    _selectedPickedMinValue=minPick;
    _selectedPickedSecValue=secPick;
    _selectedWorkTimeColorForCell = colorIndex;
    //    NSLog(@"%ld",(long)_selectedSecondsFullValue);
    [_dataFromTableView reloadData];
}
//resttimeViewC delegate method
-(void)dataFromRestTimeMinViewController:(NSInteger)fullData pickedMinuteValue:(NSInteger)minPick pickedSecondValue:(NSInteger)secPick pickedColor:(NSInteger)secColor
{
    
    _fullValueSecRV=fullData;
    _selectedPickedMinValueR=minPick;
    _selectedPickedSecValueR=secPick;
    _selectedRestTimeColorForCell =secColor;
    [_dataFromTableView reloadData];
}
//roundsViewC delegate method
-(void)dataFromRoundsViewController:(NSInteger)data pickedRoundsValue:(NSInteger)roundsPick pickedColorCollectionViewCell:(NSInteger)pickedColor
{
    _fullRoundsValue = data;
    _selectedPickedRoundsValue = roundsPick;
    _selectedRoundsColorForCell = pickedColor;
    //    NSLog(@"%ld",roundsPick);
    //    NSLog(@"%ld",(long)_fullRoundsValue);
    [_dataFromTableView reloadData];
}

//cyclesViewC delegate method
-(void)dataFromCyclesViewController:(NSInteger)data pickedCyclesValue:(NSInteger)cyclesPick pickedColorCollectionViewCell:(NSInteger)pickedColor
{
    _fullCyclesValue = data;
    _selectedPickedCyclesValue = cyclesPick;
    _selectedCyclesColorForCell = pickedColor;
    //    NSLog(@"%ld",_fullCyclesValue);
    [_dataFromTableView reloadData];
}

//restbetweenCycles delegate methos
-(void)dataFromRestBetweenCyclesViewController:(NSInteger)data pickedMinValue:(NSInteger)minPick pickedSecValue:(NSInteger)secPick pickedColorValue:(NSInteger)colorPick
{
    _fullValueSecRestBetweenCycles=data;
    _selectedPickedMinValueRestBetweenCycles=minPick;
    _selectedPickedSecValueRestBetweenCycles=secPick;
    _selectedRestBetweenCyclesTimeColorForCell = colorPick;
    [_dataFromTableView reloadData];
}

-(void)saveToNSUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    //prepare
    [defaults setInteger:_fullSecPrepare forKey:@"fullSecPrepare"];
    [defaults setInteger:_selectedPrepareMinTimeValue forKey:@"selectedPrepareMinTimeValue"];
    [defaults setInteger:_selectedPrepareSecTimeValue forKey:@"selectedPrepareSecTimeValue"];
    [defaults setInteger:_selectedPrepareColorForCell forKey:@"selectedColorForCell"];
    
    //worktime
    [defaults setInteger:_selectedSecondsFullValue forKey:@"selectedSecondsFullValue"];
    [defaults setInteger:_selectedPickedMinValue forKey:@"workTimePickedMinValue"];
    [defaults setInteger:_selectedPickedSecValue forKey:@"workTimePickedSecValue"];
    
    //resttime
    [defaults setInteger:_fullValueSecRV forKey:@"fullValueSecRV"];
    // [defaults setInteger:_selectedSecondsFull forKey:@"selectedSecondsFull"];
    [defaults setInteger:_selectedPickedMinValueR forKey:@"selectedPickedMinValueR"];
    [defaults setInteger:_selectedPickedSecValueR forKey:@"selectedPickedSecValueR"];
    
    //rounds
    [defaults setInteger:_fullRoundsValue forKey:@"fullRoundsValue"];
    [defaults setInteger:_selectedPickedRoundsValue forKey:@"selectedPickedRoundsValue"];
    [defaults setInteger:_selectedRoundsColorForCell forKey:@"selectedRoundsColorForCell"];
    //cycles
    [defaults setInteger:_fullCyclesValue forKey:@"fullCyclesValue"];
    [defaults setInteger:_selectedPickedCyclesValue forKey:@"selectedPickedCyclesValue"];
    [defaults setInteger:_selectedCyclesColorForCell forKey:@"selectedCyclesColorForCell"];
    
    //restbetweencycles
    [defaults setInteger:_fullValueSecRestBetweenCycles forKey:@"fullValueSecRBC"];
    [defaults setInteger:_selectedPickedMinValueRestBetweenCycles forKey:@"selectedPickedMinValueRBC"];
    [defaults setInteger:_selectedPickedSecValueRestBetweenCycles forKey:@"selectedPickedSecValueRBC"];
    
    //index color selected in collectionview
    
    [defaults setInteger:_selectedWorkTimeColorForCell forKey:@"selectedWorkTimeColorForCell"];
    [defaults setInteger:_selectedRestTimeColorForCell forKey:@"selectedRestTimeColorForCell"];
    [defaults setInteger:_selectedRestBetweenCyclesTimeColorForCell forKey:@"selectedRestBetweenCyclesTimeColorForCell"];
    
    
    [intervalsTabataArray removeAllObjects];
    [colorsTabataArray removeAllObjects];
    [intervalsTabataArray addObjectsFromArray:@[[NSNumber numberWithInteger:_fullSecPrepare],
                                                [NSNumber numberWithInteger:_selectedSecondsFullValue],
                                                [NSNumber numberWithInteger:_fullValueSecRV],
                                                [NSNumber numberWithInteger:_fullRoundsValue],
                                                [NSNumber numberWithInteger:_fullCyclesValue],
                                                [NSNumber numberWithInteger:_fullValueSecRestBetweenCycles]
                                                ]];
    [colorsTabataArray addObjectsFromArray:@[[NSNumber numberWithInteger:_selectedPrepareColorForCell == 0 ? _selectedPrepareColorForCell = 1 : _selectedPrepareColorForCell],
                                             [NSNumber numberWithInteger:_selectedWorkTimeColorForCell == 0 ? _selectedWorkTimeColorForCell = 2 : _selectedWorkTimeColorForCell],
                                             [NSNumber numberWithInteger:_selectedRestTimeColorForCell == 0 ? _selectedRestTimeColorForCell = 5 : _selectedRestTimeColorForCell],
                                             [NSNumber numberWithInteger:_selectedRoundsColorForCell == 0 ? _selectedRoundsColorForCell = 3 : _selectedRoundsColorForCell],
                                             [NSNumber numberWithInteger:_selectedCyclesColorForCell == 0 ? _selectedCyclesColorForCell = 4 : _selectedCyclesColorForCell],
                                             [NSNumber numberWithInteger:_selectedRestBetweenCyclesTimeColorForCell == 0 ? _selectedRestBetweenCyclesTimeColorForCell = 5 : _selectedRestBetweenCyclesTimeColorForCell ]]];
    
    [defaults setObject:intervalsTabataArray forKey:@"intervalsTabataArray"];
    [defaults setObject:colorsTabataArray forKey:@"colorsTabataArray"];
    NSLog(@" color index ====> %ld ",_selectedRoundsColorForCell);
    NSLog(@" color array === %@", colorsTabataArray);
    [[AppColorManager sharedInstanceManager]updateTabataColors];
    [self.navigationController popViewControllerAnimated:YES];
    
    [defaults synchronize];
}


- (IBAction)saveButtonTapped:(id)sender
{
    [self saveToNSUserDefaults];
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)cancelBarButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:AppUpdateThemeNotificationName object:nil];
}


-(void)removeObserver
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AppUpdateThemeNotificationName object:nil];
}


-(void)updateUI
{

    [_customNavBarView setupColor];
     [_customNavigationBarViewIpad setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[AppTheme sharedManager] labelColor],
       NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Medium" size:18.0]}];
    [self.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[[AppTheme sharedManager]labelColor],
                                                     NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:18.0]} forState:UIControlStateNormal];
    
    
}


- (void)dealloc
{
    [self removeObserver];
}



@end

