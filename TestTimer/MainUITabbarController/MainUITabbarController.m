#import "MainUITabbarController.h"


static NSString *const kSelectedImage = @"selected";
static NSString *const kImage = @"image";
static NSString *const kTitle = @"title";

@interface MainUITabbarController () <UITabBarControllerDelegate>

@end

@implementation MainUITabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray<NSDictionary *> *tabBarItems = @[@{kImage: @"icTabata", kSelectedImage: @"TabataPressed", kTitle: @"Tabata".localized},
                                             @{kImage: @"icRounds", kSelectedImage: @"RoundsPressed", kTitle: @"Rounds".localized},
                                             @{kImage: @"icStopWatch", kSelectedImage: @"StopwatchPressed", kTitle: @"Stopwatch".localized},
                                             @{kImage: @"icMore", kSelectedImage: @"MorePressed", kTitle: @"More".localized}];
    
    [tabBarItems enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITabBarItem *tabBarItem = self.tabBar.items[idx];
        
        [tabBarItem setTitle:obj[kTitle]];
        [tabBarItem setImage:[[UIImage imageNamed:obj[kImage]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [tabBarItem setSelectedImage:[[UIImage imageNamed:obj[kSelectedImage]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }];
}


-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self updateAppearance];
}

- (void)updateAppearance {
    
    [[AppTheme sharedManager] loadSavedTheme];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation])) {
        self.tabBar.tintColor = [[AppTheme sharedManager]buttonBackgroundColor];
    }else{
        self.tabBar.tintColor = [[AppTheme sharedManager]backgroundColor];
    }
    
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *tabBarItem, NSUInteger idx, BOOL * _Nonnull stop) {
        [self updateTabBarItemAppearance:tabBarItem];
    }];
}

- (void)updateTabBarItemAppearance:(UITabBarItem *)tabBarItem {
    
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [[AppTheme sharedManager] buttonBackgroundColor],
                                         NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:10.0f]}
                              forState:UIControlStateNormal];
}

@end
