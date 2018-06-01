//
//  TimeFormatViewController.m
//  TestTimer
//
//  Created by user on 8/3/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "TimeFormatViewController.h"
#import "AppTheme.h"
#import <AVFoundation/AVFoundation.h>
#import "CustomNavigationBarUIView.h"


@interface TimeFormatViewController()
{
    NSArray *timeFormatValues;
    NSString *timeFormatValue[3];
    UIButton* backButton;
    UIBarButtonItem *customLeftBarButtonItem;
}
@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavigationBarView;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;

@end


@implementation TimeFormatViewController
int indexForSelectedTimeFormats=0;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"Time format";
    timeFormatValue[0]=[NSString stringWithFormat:@"00:00"];
    timeFormatValue[1]=[NSString stringWithFormat:@"0:00.0"];
    timeFormatValue[2]=[NSString stringWithFormat:@"00:00.00"];
    timeFormatValues=[NSArray arrayWithObjects:timeFormatValue count:3];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.dataTableView.tableFooterView = [UIView new];
    [self updateUI];
    [self.navigationController setNavbarBackgroundImage];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
}


- (void)updateInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)){
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
}


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self updateInterfaceOrientation:toInterfaceOrientation];
    //    [_dataFromTableView reloadData];
}


- (void)loadView
{
    [super loadView];
    backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@" Back" forState:UIControlStateNormal];
    backButton.titleLabel.font= [UIFont fontWithName:@"AvenirNext-Regular" size:18];
    [backButton setImage:[UIImage imageNamed:@"Image.png"] forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor colorWithRed:38.0f/255.0f green:182.0f/255.0f blue:155.0f/255.0f alpha:1.0f]];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [ backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    customLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = customLeftBarButtonItem;
}


-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [timeFormatValues count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeFormatViewController" forIndexPath:indexPath];
    NSString *stringReplaceExtension = timeFormatValues[indexPath.row];
    cell.textLabel.text=stringReplaceExtension;
    if (indexPath.row == _selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row!=indexForSelectedTimeFormats) {
        [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES];
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        indexForSelectedTimeFormats= (int)indexPath.row;
    }
    _selectedTimeFormat=timeFormatValues[indexForSelectedTimeFormats];
    _selectedIndex=indexForSelectedTimeFormats;
//    NSLog(@"%@",_selectedTimeFormat);
//    NSLog(@"%ld",_selectedIndex);
    [self timeFormatTableViewControllerDelegate];
    [self.navigationController popViewControllerAnimated:YES];
    [tableView reloadData];
}


- (void)timeFormatTableViewControllerDelegate{
    if ([_delegate respondsToSelector:@selector(dataFromTimeFormatViewController:indexFromTimeFormatViewController:)] ) {
        [_delegate dataFromTimeFormatViewController:_selectedTimeFormat indexFromTimeFormatViewController:_selectedIndex];
    }
}


- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:AppUpdateThemeNotificationName object:nil];
}


- (void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AppUpdateThemeNotificationName object:nil];
}


-(void)updateUI{
    [_customNavigationBarView setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
     [_customNavigationBarViewIpad setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[AppTheme sharedManager] labelColor],
       NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]}];
    [backButton setTintColor:[[AppTheme sharedManager] labelColor]];
    [backButton setTitleColor:[[AppTheme sharedManager] labelColor] forState:UIControlStateNormal];
}


-(void)dealloc{
    [self removeObserver];
}


@end
