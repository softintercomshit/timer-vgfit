//
//  WorkTimeViewController.m
//  TestTimer
//
//  Created by a on 12/30/15.
//  Copyright © 2015 SoftIntercom. All rights reserved.
//

#import "SettingsManagerThemeCollectionViewCell.h"
#import "WorkTimeViewController.h"
#import "AppTheme.h"
#import "CustomNavigationBarUIView.h"


@interface WorkTimeViewController ()
{
    NSArray *settingsCircleThemeImages;
    NSArray *settingsCircleThemeTitles;
    NSMutableArray *colorForWorkTimeCollectionViewSchemeValues;
}

@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavBarView;
@property (strong, nonatomic) IBOutlet UILabel *minLabel;
@property (strong, nonatomic) IBOutlet UILabel *secLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secTrailingConstraint;

@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;

@end

@implementation WorkTimeViewController
int indexForSelectedWorkTimeColorCheckMark=0;
@synthesize minutesArray;
@synthesize secondsArray;

-(void)dataFromArraysToCollectionView{
    
    settingsCircleThemeImages = [NSArray arrayWithObjects:@"fullwhite.png",@"yellow.png",@"green.png",@"blue.png",@"turquoise.png",@"red.png", nil];
    settingsCircleThemeTitles = [NSArray arrayWithObjects:@"Default".localized,
                                 @"Yellow".localized,
                                 @"Green".localized,
                                 @"Blue".localized,
                                 @"Turquoise".localized,
                                 @"Red".localized,
                                 nil];
}


- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        [_customNavBarView setupLandscapeConstraint];
        [self rotateLandscape];
    }else{
        [_customNavBarView setupPortraitConstraint];
        [self rotatePortrait];
    }
    [_workTimeCollectionView reloadData];
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


- (void) rotateLandscape{
    if (IS_IPHONE || Utilities.deviceHasAreaInsets) {
        [_secLabel setTextAlignment:NSTextAlignmentLeft];
    }
    if (IS_IPAD_PRO) {
        [_secLabel setTextAlignment:NSTextAlignmentLeft];
    }
    if (IS_IPAD) {
        _secTrailingConstraint.constant = 80;
    }
    
}


- (void)rotatePortrait {
    if (IS_IPHONE || Utilities.deviceHasAreaInsets) {
        [_secLabel setTextAlignment:NSTextAlignmentRight];
    }
    if (IS_IPAD_PRO) {
        [_secLabel setTextAlignment:NSTextAlignmentCenter];
    }
    if (IS_IPAD) {
        [_secLabel setTextAlignment:NSTextAlignmentLeft];
        _secTrailingConstraint.constant = 20;
    }
}

-(void)customBarButtonItem
{
    _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_doneButton setTitle:@"Done".localized forState:UIControlStateNormal];
    _doneButton.titleLabel.font= [UIFont fontWithName:@"Avenir Next" size:18];
    [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_doneButton setImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateNormal];
    [_doneButton setTintColor:[UIColor colorWithRed:241.0f/255.0f green:163.0f/255.0f blue:34.0f/255.0f alpha:1.0f]];
    [_doneButton setTitleColor:[UIColor colorWithRed:241.0f/255.0f green:163.0f/255.0f blue:34.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_doneButton sizeToFit];
    _doneButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _doneButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _doneButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
  _customRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_doneButton];
    [_doneButton addTarget:self action:@selector(doneButtonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = _customRightBarButtonItem;
    _leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel".localized style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonAction:)];
    self.navigationItem.leftBarButtonItem =_leftBarButtonItem;
    [self.navigationItem.leftBarButtonItem setTintColor:[[AppTheme sharedManager]labelColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:241.0f/255.0f green:163.0f/255.0f blue:34.0f/255.0f alpha:1.0f]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_IPAD) {
        _minLabel.font = [UIFont fontWithName:@"Avenir Next" size:38];
        _secLabel.font = [UIFont fontWithName:@"Avenir Next" size:38];
    }
    if (IS_IPAD_PRO) {
        _minLabel.font = [UIFont fontWithName:@"Avenir Next" size:52];
        _secLabel.font = [UIFont fontWithName:@"Avenir Next" size:52];
    }
    if ([_type isEqualToString:@"1"])
    {
        _workTimeCollectionView.hidden = YES;
    }
    else
        _workTimeCollectionView.hidden = NO;
//    [self loadCollectionViewThemes];
    [self dataFromArraysToCollectionView];
      [_workTimeCollectionView registerNib:[UINib nibWithNibName:@"SettingsManagerThemeCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SettingsManagerThemeCollectionViewCell"];
    //[self dataFromArraysToCollectionView];
    [self customBarButtonItem];
    self.title=@"Work".localized;
    minutesArray = [[NSMutableArray alloc] init];
    secondsArray = [[NSMutableArray alloc] init];
    NSString *workValues = [[NSString alloc] init];
    for ( int i=0; i<60; i++) {
        workValues = [NSString stringWithFormat:@"%02d",i];
        if (i<60) {
            [secondsArray addObject:workValues];
        }
        [minutesArray addObject:workValues];
    }
    [self updateUI];
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavbarBackgroundImage];
    [self updateUI];
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        NSLog(@"LANDSCAPE");
        [self rotateLandscape];
    }
    else
    {
        NSLog(@"PORTRAIT");
        [self rotatePortrait];
    }
       [_workTimeCollectionView reloadData];
    if (_selectedWorkTimeIndexInCollectionView==0) {
        _selectedWorkTimeIndexInCollectionView=2;
    }
    if(_selectedRowinMin==0 && _selectedRowinSec==5){
        [_workTimePicker selectRow:0 inComponent:kMinutesComponent animated:YES];
        [_workTimePicker selectRow:5 inComponent:kSecondsComponent animated:YES];
    }
    else{
        [_workTimePicker selectRow:_selectedRowinMin inComponent:kMinutesComponent animated:YES];
        [_workTimePicker selectRow:_selectedRowinSec inComponent:kSecondsComponent animated:YES];
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == kMinutesComponent)
        return [minutesArray count];
    else if(component == kSecondsComponent)
        return [secondsArray count];
    else return 100;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (IS_IPHONE_6P) {
        return 82;
    }
    if (IS_IPHONE_6) {
        return 75;
    }
    if (IS_IPHONE_5) {
        return 60;
    }
    if (IS_IPHONE_4_OR_LESS) {
        return 55;
    }
    if (IS_IPAD)
    {
        return 110;
    }
    if (IS_IPAD_PRO) {
        return 150;
    }
    if(Utilities.deviceHasAreaInsets) {
        return 82;
    }
    else
        return 75;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *columnView = [[UILabel alloc] init];
    if (component==kMinutesComponent) {
        if (row==1) {
            columnView.text = [NSString stringWithFormat:@"%lu", (long) row];
        }
        else
            columnView.text = [NSString stringWithFormat:@"%lu", (long) row];
        
    }
    if (component==kSecondsComponent) {
        if (row==1) {
            columnView.text = [NSString stringWithFormat:@"%lu ", (long) row];
        }
        else
            columnView.text = [NSString stringWithFormat:@"%lu ", (long) row];
    }
    if (IS_IPAD_PRO) {
        columnView.font =[UIFont fontWithName:@"Avenir Next" size:140];
    }
    if (IS_IPAD) {
        columnView.font =[UIFont fontWithName:@"Avenir Next" size:105];
    }
    if (IS_IPHONE_6P) {
        columnView.font =[UIFont fontWithName:@"Avenir Next" size:77];
    }
    if (IS_IPHONE_6) {
        columnView.font =[UIFont fontWithName:@"Avenir Next" size:70];
    }
    if (IS_IPHONE_5) {
        columnView.font =[UIFont fontWithName:@"Avenir Next" size:55];
    }
    if (IS_IPHONE_4_OR_LESS) {
        columnView.font =[UIFont fontWithName:@"Avenir Next" size:45];
    }
    if (Utilities.deviceHasAreaInsets) {
        columnView.font =[UIFont fontWithName:@"Avenir Next" size:77];
    }
    
    columnView.textAlignment = NSTextAlignmentCenter;
    return columnView;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component)
    {
        case kMinutesComponent:
            return [minutesArray objectAtIndex:row];
            break;
        case kSecondsComponent:
            return [secondsArray objectAtIndex:row];
        break;}
    return nil;
}


-(void)cancelBarButtonAction:(id)sender {
    
   if (_selectedRowinMin==0 && _selectedRowinSec==0) {

       
        [_workTimePicker selectRow:0 inComponent:kMinutesComponent animated:YES];
        [_workTimePicker selectRow:1 inComponent:kSecondsComponent animated:YES];
        _selectedRowinSec=1;
   }

        [self.navigationController popViewControllerAnimated:YES];

}


- (void)doneButtonButtonAction:(id)sender {

    _selectedRowinMin=[_workTimePicker selectedRowInComponent:kMinutesComponent];
    _selectedRowinSec=[_workTimePicker selectedRowInComponent:kSecondsComponent];
    if (_selectedRowinMin==0 && _selectedRowinSec==0) {
        [_workTimePicker selectRow:0 inComponent:kMinutesComponent animated:YES];
      [_workTimePicker selectRow:1 inComponent:kSecondsComponent animated:YES];
        _selectedRowinSec=1;
    }
    _fullValue= _selectedRowinMin*60+_selectedRowinSec%60;
   
    [self delegateWorkTimeViewController];
    [self.navigationController popViewControllerAnimated:YES];
    [_workTimePicker reloadAllComponents];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _selectedRowinMin=[_workTimePicker selectedRowInComponent:kMinutesComponent];
    _selectedRowinSec=[_workTimePicker selectedRowInComponent:kSecondsComponent];
    if (_selectedRowinMin==0 && _selectedRowinSec==0) {
        [_workTimePicker selectRow:0 inComponent:kMinutesComponent animated:YES];
        [_workTimePicker selectRow:1 inComponent:kSecondsComponent animated:YES];
        _selectedRowinSec=1;
    }
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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [settingsCircleThemeImages count];//sau fac count la el. din array
}

#pragma mark -Colection view cu cele 10 celule care matinca nu o sa trebuiasca


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsManagerThemeCollectionViewCell *myCell = [_workTimeCollectionView
                                                      dequeueReusableCellWithReuseIdentifier:@"SettingsManagerThemeCollectionViewCell"
                                                      forIndexPath:indexPath];
    myCell.checkMarkImageView.hidden = YES;

    if(indexPath.item == _selectedWorkTimeIndexInCollectionView)
    {
        myCell.checkMarkImageView.hidden = NO;
    }
    else
    {
        myCell.checkMarkImageView.hidden = YES;
    }
    [self dataFromArraysToCollectionView];
    //azi numai decit pun in xib arrayrurile astea cu imagini
    myCell.themeImageView.image = [UIImage imageNamed:[settingsCircleThemeImages objectAtIndex:indexPath.row]];
    myCell.titleLabel.text =[settingsCircleThemeTitles objectAtIndex:indexPath.row];
    //self.workTimeCollectionView.scrollEnabled = NO;
    return myCell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    indexForSelectedWorkTimeColorCheckMark = (int) indexPath.item;
     _selectedWorkTimeColor =settingsCircleThemeTitles[indexForSelectedWorkTimeColorCheckMark];
       _selectedWorkTimeIndexInCollectionView = indexForSelectedWorkTimeColorCheckMark;
    [_workTimeCollectionView reloadData];
}


-(void) delegateWorkTimeViewController{
    if ([_delegate respondsToSelector:@selector(dataFromWorkTimeMinViewController:pickedMinuteValue:pickedSecondValue:pickedColorIndexValue:)]) {
        [_delegate dataFromWorkTimeMinViewController:_fullValue pickedMinuteValue:_selectedRowinMin pickedSecondValue:_selectedRowinSec pickedColorIndexValue:_selectedWorkTimeIndexInCollectionView];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height)
        {
            return   CGSizeMake([UIScreen mainScreen].bounds.size.width / 6, 80);
        }
        else
        {
            return   CGSizeMake([UIScreen mainScreen].bounds.size.height / 6, 80);
        }
    }
    else
    {
        if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height)
        {
            return   CGSizeMake([UIScreen mainScreen].bounds.size.height / 6, 80);
        }
        else
        {
            return   CGSizeMake([UIScreen mainScreen].bounds.size.width / 6, 80);
        }
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (IS_IPAD_PRO) {
        switch (component){
            case 0:
                return 360.0f;
            case 1:
                return 370.0f;
        }
    }
    else if (IS_IPAD) {
        switch (component){
            case 0:
                return 210.0f;
            case 1:
                return 220.0f;
        }
    }
    else if (IS_IPHONE_6P) {
        switch (component){
            case 0:
                return 170.0f;
            case 1:
                return 180.0f;
        }
    }
    else if(IS_IPHONE_6){
        switch (component){
            case 0:
                return 140.0f;
            case 1:
                return 150.0f;
        }
    }
    else if(IS_IPHONE_5){
        switch (component){
            case 0:
                return 120.0f;
            case 1:
                return 130.0f;
        }
    }
    else if(IS_IPHONE_4_OR_LESS){
        switch (component){
            case 0:
                return 100.0f;
            case 1:
                return 110.0f;
        }
    }
    else if(Utilities.deviceHasAreaInsets){
        switch (component){
            case 0:
                return 150.0f;
            case 1:
                return 160.0f;
        }
    }
    return 100;
}


@end
