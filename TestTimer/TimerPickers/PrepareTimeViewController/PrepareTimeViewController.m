//
//  PrepareTimeViewController.m
//  TestTimer
//
//  Created by a on 3/18/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "PrepareTimeViewController.h"
#import "AppTheme.h"
#import "SettingsManagerThemeCollectionViewCell.h"
#import "CustomNavigationBarUIView.h"

@interface PrepareTimeViewController ()
{
    NSMutableArray *colorForCollectionViewSchemeValues;
}

@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavBarView;
@property (strong, nonatomic) IBOutlet UILabel *minLabel;
@property (strong, nonatomic) IBOutlet UILabel *secLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSecLabel;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;

@end

@implementation PrepareTimeViewController
{
    NSMutableArray *prepareTimeMinArray;
    NSMutableArray *prepareTimeSecArray;
    NSArray *settingsCircleThemeImages;
    NSArray *settingsCircleThemeTitles;
}


- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        [_customNavBarView setupLandscapeConstraint];
        [self rotateLandscape];
    }else{
        [_customNavBarView setupPortraitConstraint];
        [self rotatePortrait];
    }
        [_collectionView reloadData];
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
        _trailingSecLabel.constant = 80;
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
             _trailingSecLabel.constant = 20;
    }
}

int indexForSelectedColorCheckMark=0;

- (void)customBarButtonItems{
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
    _customRightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:_doneButton];
    [_doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = _customRightBarButtonItem;
    _leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel".localized style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem =_leftBarButtonItem;
    
    [self.navigationItem.leftBarButtonItem setTintColor:[[AppTheme sharedManager]labelColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:241.0f/255.0f green:163.0f/255.0f blue:34.0f/255.0f alpha:1.0f]];
}


- (void)dataFromArraysToCollectionView{
    
    settingsCircleThemeImages = [NSArray arrayWithObjects:@"fullwhite.png",
                                                          @"yellow.png",
                                                          @"green.png",
                                                          @"blue.png",
                                                          @"turquoise.png",
                                                          @"red.png",
                                                             nil];
    
    settingsCircleThemeTitles = [NSArray arrayWithObjects:@"Default".localized,
                                                          @"Yellow".localized,
                                                          @"Green".localized,
                                                          @"Blue".localized,
                                                          @"Turquoise".localized,
                                                          @"Red".localized,
                                                             nil];
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
        _collectionView.hidden = YES;
    }
    else{
        _collectionView.hidden = NO;
    }
    [self dataFromArraysToCollectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"SettingsManagerThemeCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SettingsManagerThemeCollectionViewCell"];
    [self customBarButtonItems];
    self.title =@"Prepare".localized;
    prepareTimeMinArray=[[NSMutableArray alloc] init];
    prepareTimeSecArray=[[NSMutableArray alloc] init];
    NSString *prepareValues = [[NSString alloc] init];
    for (int i=0; i<60; i++) {
        prepareValues = [NSString stringWithFormat:@"%02d",i];
        if (i<10) {
            prepareValues = [NSString stringWithFormat:@"0%02d",i];
        }
        if(i<60){
            [prepareTimeSecArray addObject:prepareValues];
        }
        [prepareTimeMinArray addObject:prepareValues];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
    
    if (_selectedIndexInCollectionView==0)
    {
        _selectedIndexInCollectionView = 1;
    }
    if(_selectedRowMinForPrepare==0 && _selectedRowSecForPrepare==0){
        [_prepareTimePicker selectRow:0 inComponent:kPrepareTimeMinComponent animated:YES];
        [_prepareTimePicker selectRow:0 inComponent:kPrepareTimeSecComponent animated:YES];
    }
    else{
        [_prepareTimePicker selectRow:_selectedRowMinForPrepare inComponent:kPrepareTimeMinComponent animated:YES];
        [_prepareTimePicker selectRow:_selectedRowSecForPrepare inComponent:kPrepareTimeSecComponent animated:YES];
    }
     [_collectionView reloadData];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == kPrepareTimeMinComponent)
        return [prepareTimeMinArray count];
    else if(component == kPrepareTimeSecComponent)
        return [prepareTimeSecArray count];
    else return 100;
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
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


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *columnView = [[UILabel alloc] init];
    if (component==kPrepareTimeMinComponent) {
        if (row==1) {
            columnView.text = [NSString stringWithFormat:@"%lu", (long) row];
        }
        else
            columnView.text = [NSString stringWithFormat:@"%lu", (long) row];
        
    }
    if (component==kPrepareTimeSecComponent) {
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
        case kPrepareTimeMinComponent:
            return [prepareTimeMinArray objectAtIndex:row];
            break;
        case kPrepareTimeSecComponent:
            return [prepareTimeSecArray objectAtIndex:row];
            break;
    }
    return nil;
}


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectedRowMinForPrepare = [_prepareTimePicker selectedRowInComponent:kPrepareTimeMinComponent];
    _selectedRowSecForPrepare = [_prepareTimePicker selectedRowInComponent:kPrepareTimeSecComponent];
    
    [_collectionView reloadData];
    
    [_prepareTimePicker reloadAllComponents];
    
}


- (IBAction)doneButtonTapped:(id)sender{

    _selectedRowMinForPrepare = [_prepareTimePicker selectedRowInComponent:kPrepareTimeMinComponent];
    _selectedRowSecForPrepare = [_prepareTimePicker selectedRowInComponent:kPrepareTimeSecComponent];
    _fullValuePrepareTimeSeconds = (_selectedRowMinForPrepare*60)+(_selectedRowSecForPrepare%60);
#pragma mark - Pentru a nu putea selecta o culoare in valoare timpului e egala cu zero
    if (_selectedRowMinForPrepare==0 && _selectedRowSecForPrepare==0) {
        
        _selectedIndexInCollectionView = 0;
    }
    [self delegateRoundsViewController];
    [self.navigationController popViewControllerAnimated:YES];
    [_prepareTimePicker reloadAllComponents];
}


-(IBAction)cancelButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    SettingsManagerThemeCollectionViewCell *myCell = [collectionView
                                                      dequeueReusableCellWithReuseIdentifier:@"SettingsManagerThemeCollectionViewCell"
                                                      forIndexPath:indexPath];
    myCell.checkMarkImageView.hidden = YES;
    if(indexPath.item == _selectedIndexInCollectionView)//am schimbat din indexForSelectedColorCheckMark in _selectedIndexInCollectionView;
    {
        myCell.checkMarkImageView.hidden = NO;
    }
    else
    {
        myCell.checkMarkImageView.hidden = YES;
    }
    
    [self dataFromArraysToCollectionView];
    myCell.themeImageView.image = [UIImage imageNamed:[settingsCircleThemeImages objectAtIndex:indexPath.row]];
    myCell.titleLabel.text =[settingsCircleThemeTitles objectAtIndex:indexPath.row];
    
    return myCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    indexForSelectedColorCheckMark = (int) indexPath.item;
    _selectedIndexInCollectionView = indexForSelectedColorCheckMark;
    [_collectionView reloadData];
}


- (void) delegateRoundsViewController{
    if ([_delegate respondsToSelector:@selector(dataFromPrepareTimeViewController:pickedPrepareTimeMinValue:pickedPrepareTimeSecValue:pickedColorCollectionViewCell:)]){
        [_delegate dataFromPrepareTimeViewController:_fullValuePrepareTimeSeconds pickedPrepareTimeMinValue:_selectedRowMinForPrepare pickedPrepareTimeSecValue:_selectedRowSecForPrepare pickedColorCollectionViewCell:_selectedIndexInCollectionView];
        
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
