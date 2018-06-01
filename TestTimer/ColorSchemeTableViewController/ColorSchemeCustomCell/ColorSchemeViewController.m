//
//  ColorSchemeViewController.m
//  TestTimer
//
//  Created by user on 8/4/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "ColorSchemeViewController.h"
#import "AppTheme.h"
#import "ColorSchemeCustomCell.h"
#import "CustomNavigationBarUIView.h"
#import "MainUITabbarController.h"

@interface ColorSchemeViewController ()
{
    NSMutableArray *colorSchemeValues;
    UIButton* backButton;
    UIBarButtonItem *customLeftBarButtonItem;
    NSInteger index;
}
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarViewIpad;

@property (weak, nonatomic) IBOutlet CustomNavigationBarUIView *customNavigationBarView;
@end

@implementation ColorSchemeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Visual style".localized;
    [self loadThemes];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: YES];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [_customNavigationBarView setupLandscapeConstraint];
    }else{
        [_customNavigationBarView setupPortraitConstraint];
    }
    self.dataFromTableView.tableFooterView = [UIView new];
    [self updateUI];
}


- (void)updateTabBarAppearance {
    
    MainUITabbarController *controller = (MainUITabbarController *)self.tabBarController;
    [controller updateAppearance];
}

- (void)loadView  {
    [super loadView];
    backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"Back".localized forState:UIControlStateNormal];
    backButton.titleLabel.font= [UIFont fontWithName:@"AvenirNext-Regular" size:18];
    [backButton setImage:[UIImage imageNamed:@"Image.png"] forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor colorWithRed:38.0f/255.0f green:182.0f/255.0f blue:155.0f/255.0f alpha:1.0f]];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [ backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    customLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = customLeftBarButtonItem;
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


-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) loadThemes {
    colorSchemeValues = [NSMutableArray new];
    [colorSchemeValues addObject:@{@"themeName" : [[AppTheme sharedManager] themeNameForStyle:APPSTYLE_WHITE], @"style" : [NSNumber numberWithInteger:APPSTYLE_WHITE]}];
    [colorSchemeValues addObject:@{@"themeName" : [[AppTheme sharedManager] themeNameForStyle:APPSTYLE_GRAY], @"style" : [NSNumber numberWithInteger:APPSTYLE_GRAY]}];
    [colorSchemeValues addObject:@{@"themeName" : [[AppTheme sharedManager] themeNameForStyle:APPSTYLE_DARKGRAY], @"style" : [NSNumber numberWithInteger:APPSTYLE_DARKGRAY]}];
    [colorSchemeValues addObject:@{@"themeName" : [[AppTheme sharedManager] themeNameForStyle:APPSTYLE_BLACK], @"style" : [NSNumber numberWithInteger:APPSTYLE_BLACK]}];
     [colorSchemeValues addObject:@{@"themeName" : [[AppTheme sharedManager] themeNameForStyle:APPSTYLE_ROSE], @"style" : [NSNumber numberWithInteger:APPSTYLE_ROSE]}];
     [colorSchemeValues addObject:@{@"themeName" : [[AppTheme sharedManager] themeNameForStyle:APPSTYLE_VIOLET], @"style" : [NSNumber numberWithInteger:APPSTYLE_VIOLET]}];
     [colorSchemeValues addObject:@{@"themeName" : [[AppTheme sharedManager] themeNameForStyle:APPSTYLE_RED], @"style" : [NSNumber numberWithInteger:APPSTYLE_RED]}];
     [colorSchemeValues addObject:@{@"themeName" : [[AppTheme sharedManager] themeNameForStyle:APPSTYLE_GREEN], @"style" : [NSNumber numberWithInteger:APPSTYLE_GREEN]}];
     [colorSchemeValues addObject:@{@"themeName" : [[AppTheme sharedManager] themeNameForStyle:APPSTYLE_BLUE], @"style" : [NSNumber numberWithInteger:APPSTYLE_BLUE]}];
    
}
#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [colorSchemeValues count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ColorSchemeCustomCell";
    ColorSchemeCustomCell *cell = (ColorSchemeCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (ColorSchemeCustomCell *)[nib objectAtIndex:0];
    }
    UIView *cellBg = [[UIView alloc] init];
    cellBg.backgroundColor =[UIColor clearColor];// this RGB value for blue color
    cellBg.layer.masksToBounds = YES;
    cell.selectedBackgroundView = cellBg;
    NSDictionary *themeDict = colorSchemeValues[indexPath.row];
    AppStyle style = [themeDict[@"style"] integerValue];
    NSString *themeName = themeDict[@"themeName"];
    UIColor *mainColor = [[AppTheme sharedManager] mainColorForStyle:style];
    cell.themeColorView.backgroundColor = mainColor;
    // _pickedColor=mainColor;
    cell.themeNameLabel.text = themeName;
    cell.themeNameLabel.font = [UIFont fontWithName:@"Avenir Next" size:15.0f];
    AppStyle currentStyle = [[AppTheme sharedManager] getCurrentStyle];
    if (currentStyle == style)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *themeDict = colorSchemeValues[indexPath.row];
    AppStyle style = [themeDict[@"style"] integerValue];
    AppStyle currentStyle = [[AppTheme sharedManager] getCurrentStyle];
    
    if (currentStyle != style)
    {
        [[AppTheme sharedManager] updateThemeWithStyle:style];
    }
    index = style;
//    NSLog(@"%ld",index);
//    NSLog(@"%ld",style);
//    NSLog(@"%ld",currentStyle);
    _selectedColorScheme = [[AppTheme sharedManager]themeNameForStyle:[[AppTheme sharedManager] getCurrentStyle]];
    [self updateUI];
    [self colorSchemeTableViewControllerDelegate];
    [self updateTabBarAppearance];
    [self.dataFromTableView reloadData];
}


- (void)colorSchemeTableViewControllerDelegate {
    if ([_delegate respondsToSelector:@selector(dataFromColorSchemeViewControllerDelegate:indexVisualStyleForView:)]) {
        [_delegate dataFromColorSchemeViewControllerDelegate:_selectedColorScheme indexVisualStyleForView:index];
    }
}


- (void)updateUI {
     [_customNavigationBarViewIpad setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    [_customNavigationBarView setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[[AppTheme sharedManager] labelColor],
       NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]}];
    [backButton setTintColor:[[AppTheme sharedManager] labelColor]];
    [backButton setTitleColor:[[AppTheme sharedManager] labelColor] forState:UIControlStateNormal];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 94;
}

@end
