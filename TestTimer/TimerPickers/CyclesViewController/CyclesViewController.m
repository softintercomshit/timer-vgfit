//
//  CyclesViewController.m
//  TestTimer
//
//  Created by a on 3/18/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "CyclesViewController.h"
#import "AppTheme.h"
#import "SettingsManagerThemeCollectionViewCell.h"
#import "CustomNavigationBarUIView.h"

@interface CyclesViewController ()
{
    NSArray *settingsCircleThemeImages;
    NSArray *settingsCircleThemeTitles;
}
@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavigationBarView;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;


@end

@implementation CyclesViewController

- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
    [_cyclesCollectionViewColors reloadData];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
    {
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateInterfaceOrientation:toInterfaceOrientation];
    
}


int recordForSelectedColorCheckMark=0;
-(void)customBarButtonItems
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
    [_doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = _customRightBarButtonItem;
   _leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel".localized style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem =_leftBarButtonItem;
    [self.navigationItem.leftBarButtonItem setTintColor:[[AppTheme sharedManager]labelColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:241.0f/255.0f green:163.0f/255.0f blue:34.0f/255.0f alpha:1.0f]];
}


-(void)dataFromArraysToCollectionView
{
    settingsCircleThemeImages = [NSArray arrayWithObjects:@"fullwhite.png",@"yellow.png",@"green.png",@"blue.png",@"turquoise.png",@"red.png", nil];
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
    if ([_type isEqualToString:@"1"])
    {
        _cyclesCollectionViewColors.hidden = YES;
    }
    else
        _cyclesCollectionViewColors.hidden = NO;
    [self dataFromArraysToCollectionView];
    [_cyclesCollectionViewColors registerNib:[UINib nibWithNibName:@"SettingsManagerThemeCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SettingsManagerThemeCollectionViewCell"];
    if ([_type isEqualToString:@"1"])
    {
        _cyclesCollectionViewColors.hidden = YES;
    }
    else
        _cyclesCollectionViewColors.hidden = NO;
    [self customBarButtonItems];
    self.title =@"Cycles".localized;
    _cyclesArray = [[NSMutableArray alloc] init];
    NSString *cyclesValues =[[NSString alloc] init];
    for (int i=0; i<99; i++) {
        cyclesValues = [NSString stringWithFormat:@"%d",i+1];
        [_cyclesArray addObject:cyclesValues];
    }
    [self updateUI];
}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavbarBackgroundImage];
     [self updateUI];
    [_cyclesCollectionViewColors reloadData];
    if (_pickedRecordInCollectionView==0)
    {
        _pickedRecordInCollectionView =4;
    }
      if (_cycles==3) {
        [_cyclesPicker selectRow:2 inComponent:kCyclesComponent animated:YES];
    }
    else if(_cycles!=3){
        [_cyclesPicker selectRow:_selectedRowForCycles inComponent:kCyclesComponent animated:YES];
    }
   
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_cyclesArray count];
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

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *columnView = [[UILabel alloc] init];
    columnView.text = [NSString stringWithFormat:@"%lu ", (long) row+1];
    columnView.textAlignment = NSTextAlignmentCenter;
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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectedRowForCycles = [_cyclesPicker selectedRowInComponent:kCyclesComponent];//daca ceva o sa pun +1
}

-(void)delegateCyclesViewController
{
    if ([_delegate respondsToSelector:@selector(dataFromCyclesViewController:pickedCyclesValue:pickedColorCollectionViewCell:)]) {
        [_delegate dataFromCyclesViewController:_cycles pickedCyclesValue:_selectedRowForCycles pickedColorCollectionViewCell:_pickedRecordInCollectionView];
    }
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonTapped:(id)sender {
    _selectedRowForCycles = [_cyclesPicker selectedRowInComponent:kCyclesComponent];
    _cycles =_selectedRowForCycles+1;
    [self delegateCyclesViewController];
    [self.navigationController popViewControllerAnimated:YES];
    [_cyclesPicker reloadAllComponents];
}

-(void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:AppUpdateThemeNotificationName object:nil];
}

-(void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AppUpdateThemeNotificationName object:nil];
}

- (void)updateUI {
    [_customNavigationBarView setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
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
    
    if(indexPath.item == _pickedRecordInCollectionView)//am schimbat din indexForSelectedColorCheckMark in _selectedIndexInCollectionView;
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    recordForSelectedColorCheckMark = (int) indexPath.item;
    _pickedRecordInCollectionView = recordForSelectedColorCheckMark;
    [_cyclesCollectionViewColors reloadData];

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
        }
    }
    else if (IS_IPAD) {
        switch (component){
            case 0:
                return 210.0f;
        }
    }
    else if (IS_IPHONE_6P) {
        switch (component){
            case 0:
                return 170.0f;
        }
    }
    else if(IS_IPHONE_6){
        switch (component){
            case 0:
                return 140.0f;
        }
    }
    else if(IS_IPHONE_5){
        switch (component){
            case 0:
                return 120.0f;
        }
    }
    else if(IS_IPHONE_4_OR_LESS){
        switch (component){
            case 0:
                return 100.0f;
        }
    }
    else if(Utilities.deviceHasAreaInsets){
        switch (component){
            case 0:
                return 150.0f;
        }
    }
    return 100;
}


@end
