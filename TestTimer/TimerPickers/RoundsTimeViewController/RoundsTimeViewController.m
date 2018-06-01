//
//  RoundsTimeViewController.m
//  TestTimer
//
//  Created by a on 1/20/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "RoundsTimeViewController.h"
#import "AppTheme.h"
#import "SettingsManagerThemeCollectionViewCell.h"
#import "CustomNavigationBarUIView.h"

@interface RoundsTimeViewController ()
{
    NSArray *settingsCircleThemeImages;
    NSArray *settingsCircleThemeTitles;
}
@property (strong, nonatomic) IBOutlet UILabel *secLabel;
@property (strong, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavigationBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secLabelTrailingConstraint;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;

@end
@implementation RoundsTimeViewController

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
        [_customNavigationBarView setupLandscapeConstraint];
        [self rotateLandscape];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
        [self rotatePortrait];
    }
    [_collectionView reloadData];
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

- (void) rotateLandscape{
    if (IS_IPHONE || Utilities.deviceHasAreaInsets) {
        [_secLabel setTextAlignment:NSTextAlignmentLeft];
    }
    if (IS_IPAD_PRO) {
        [_secLabel setTextAlignment:NSTextAlignmentLeft];
    }
    if (IS_IPAD) {
        _secLabelTrailingConstraint.constant = 80;
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
        _secLabelTrailingConstraint.constant = 20;
    }
}


int indexForPickedColorCheckMark=0;

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
   _customRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_doneButton];
    [_doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = _customRightBarButtonItem;
   _leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel".localized style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped:)];
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
        _collectionView.hidden = YES;
    }else{
         _collectionView.hidden = NO;
    }

    [self dataFromArraysToCollectionView];
     [_collectionView registerNib:[UINib nibWithNibName:@"SettingsManagerThemeCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SettingsManagerThemeCollectionViewCell"];
    self.title=@"Work".localized;
    [self customBarButtonItems];
    _minArray = [[NSMutableArray alloc] init];
    _secArray = [[NSMutableArray alloc] init];
    NSString *stringValues = [[NSString alloc] init];
    for ( int i=0; i<60; i++) {
        stringValues = [NSString stringWithFormat:@"%02d",i];
        if (i<60) {
            [_secArray addObject:stringValues];
        }
        [_minArray addObject:stringValues];
    }
    [self updateUI];
}


- (void)viewWillAppear:(BOOL)animated{
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
    [_collectionView reloadData];
    if (_selectedIndexInCollectionViewCell==0) {
        _selectedIndexInCollectionViewCell=2;
    }
 if(_fullValuesSeconds==5){
        [_roundsTimePicker selectRow:0 inComponent:kMinComponent animated:YES];
        [_roundsTimePicker selectRow:5 inComponent:kSecComponent animated:YES];
    }
    else{
        [_roundsTimePicker selectRow:_roundTimeMin inComponent:kMinComponent animated:NO];
        [_roundsTimePicker selectRow:_roundTimeSec inComponent:kSecComponent animated:NO];
    }
  
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case kMinComponent:
            return [_minArray count];
            break;
        case kSecComponent:
            return [_secArray count];
        default:
            break;
    }
    return component;

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
    if (component==kMinComponent) {
        columnView.text = [NSString stringWithFormat:@"%lu", (long) row];

    }
    if (component==kSecComponent) {
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


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (component)
    {
        case kMinComponent:
            return [_minArray objectAtIndex:row];
            break;
        case kSecComponent:
            return [_secArray objectAtIndex:row];
        break;}
    return nil;
}


- (void)cancelButtonTapped:(id)sender{
    if (_roundTimeMin==0 && _roundTimeSec==0) {
        [_roundsTimePicker selectRow:0 inComponent:kMinComponent animated:YES];
        [_roundsTimePicker selectRow:1 inComponent:kSecComponent animated:YES];
        _roundTimeSec = 1;
    }
    if (_roundTimeSec != 0) {
          [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)doneButtonTapped:(id)sender{
    _roundTimeMin=[_roundsTimePicker selectedRowInComponent:kMinComponent];
    _roundTimeSec=[_roundsTimePicker selectedRowInComponent:kSecComponent];
    if ((_roundTimeMin==0 && _roundTimeSec==0) ) {
        [_roundsTimePicker selectRow:0 inComponent:kMinComponent animated:YES];
        [_roundsTimePicker selectRow:1 inComponent:kSecComponent animated:YES];
        _roundTimeSec=1;
    }
// NSInteger fullValue = _roundTimeMin*60+_roundTimeSec%60;
    _fullValuesSeconds = _roundTimeMin*60+_roundTimeSec%60;
//  NSLog(@"full value:%ld",_fullValuesSeconds);
    [self delegateRoundTimeViewController];
    [self.navigationController popViewControllerAnimated:YES];
    [_roundsTimePicker reloadAllComponents];
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _roundTimeMin=[_roundsTimePicker selectedRowInComponent:kMinComponent];
    _roundTimeSec=[_roundsTimePicker selectedRowInComponent:kSecComponent];
    if ((_roundTimeMin==0 && _roundTimeSec==0) ) {
        [_roundsTimePicker selectRow:0 inComponent:kMinComponent animated:YES];
        [_roundsTimePicker selectRow:1 inComponent:kSecComponent animated:YES];
        _roundTimeSec=1;
    }
      [_roundsTimePicker reloadAllComponents];
}


-(void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:AppUpdateThemeNotificationName object:nil];
}

-(void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AppUpdateThemeNotificationName object:nil];
}


-(void)updateUI{
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

#pragma mark - Collection view in view Controller


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
    if(indexPath.item == _selectedIndexInCollectionViewCell)//am schimbat din indexForSelectedColorCheckMark in _selectedIndexInCollectionView;
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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    indexForPickedColorCheckMark = (int) indexPath.item;
    _selectedIndexInCollectionViewCell = indexForPickedColorCheckMark;
    [_collectionView reloadData];

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
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

-(void)delegateRoundTimeViewController{
    if ([_delegate respondsToSelector:@selector(dataFromRoundTimeMinViewController:pickedMinValue:pickedSecValue:pickedColorCell:)]) {
        [_delegate dataFromRoundTimeMinViewController:_fullValuesSeconds pickedMinValue:_roundTimeMin pickedSecValue:_roundTimeSec pickedColorCell:_selectedIndexInCollectionViewCell];
    }
}
@end
