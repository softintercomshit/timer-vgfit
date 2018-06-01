//
//  AppTheme.m
//  TestTimer
//
//  Created by a on 2/12/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "AppTheme.h"

#define APP_THEME_KEY @"appThemeKey"

@interface AppTheme()

@property (nonatomic, assign) AppStyle currentStyle;

@end

@implementation AppTheme

+ (instancetype) sharedManager
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) loadSavedTheme
{
    AppStyle savedStyle = [[NSUserDefaults standardUserDefaults] integerForKey:APP_THEME_KEY];
    [self loadStyle:savedStyle];
}

- (void) updateThemeWithStyle:(AppStyle) style
{
    [[NSUserDefaults standardUserDefaults] setInteger:style forKey:APP_THEME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self loadStyle:style];
    [[NSNotificationCenter defaultCenter] postNotificationName:AppUpdateThemeNotificationName object:nil];
}

- (void) loadStyle:(AppStyle) style
{
    self.currentStyle = style;
    switch (style)
    {
        case APPSTYLE_WHITE:
        {
            self.backgroundColor = DEFINE_THEME_WHITE_COLOR;
            self.circleBackgroundColor = RGBColor(88, 88, 88, 0.15);
            self.labelColor = DEFINE_THEME_BLACK_COLOR;
            self.buttonBackgroundColor = DEFINE_THEME_BLACK_COLOR;
            self.statusColor = NO;
            break;
        }
        case APPSTYLE_GRAY:
        {
            self.backgroundColor = DEFINE_THEME_GRAY_COLOR;
            self.circleBackgroundColor = RGBColor(255, 255, 255, 0.15);
            self.labelColor = DEFINE_THEME_WHITE_COLOR;
//            self.buttonBackgroundColor = DEFINE_THEME_WHITE_COLOR;
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) {
                self.buttonBackgroundColor =  DEFINE_THEME_BLACK_COLOR;
            }else{
                self.buttonBackgroundColor =  DEFINE_THEME_WHITE_COLOR;
            }
            self.statusColor = YES;
            break;
        }
        case APPSTYLE_DARKGRAY:
        {
            self.backgroundColor = DEFINE_THEME_DARK_GRAY_COLOR;
            self.circleBackgroundColor = RGBColor(255, 255, 255, 0.15);
            self.labelColor = DEFINE_THEME_WHITE_COLOR;
//            self.buttonBackgroundColor = DEFINE_THEME_WHITE_COLOR;
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) {
                self.buttonBackgroundColor =  DEFINE_THEME_BLACK_COLOR;
            }else{
                self.buttonBackgroundColor =  DEFINE_THEME_WHITE_COLOR;
            }
            self.statusColor = YES;
            break;
        }
        case APPSTYLE_BLACK:
        {
            self.backgroundColor = DEFINE_THEME_BLACK_COLOR;
            self.circleBackgroundColor = RGBColor(255, 255, 255, 0.15);
            self.labelColor =  DEFINE_THEME_WHITE_COLOR;
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) {
                self.buttonBackgroundColor =  DEFINE_THEME_BLACK_COLOR;
            }else{
                self.buttonBackgroundColor =  DEFINE_THEME_WHITE_COLOR;
            }
            self.statusColor = YES;
            break;
        }
        case  APPSTYLE_ROSE:
        {
            self.backgroundColor = DEFINE_THEME_ROSE_COLOR;
            self.circleBackgroundColor = RGBColor(255, 255, 255, 0.15);
            self.labelColor =  DEFINE_THEME_WHITE_COLOR;
//            self.buttonBackgroundColor = DEFINE_THEME_WHITE_COLOR;
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) {
                self.buttonBackgroundColor =  DEFINE_THEME_BLACK_COLOR;
            }else{
                self.buttonBackgroundColor =  DEFINE_THEME_WHITE_COLOR;
            }
            self.statusColor = YES;
            break;
        }
        case APPSTYLE_VIOLET:
        {
            self.backgroundColor = DEFINE_THEME_VIOLET_COLOR;
            self.circleBackgroundColor = RGBColor(255, 255, 255, 0.15);
            self.labelColor =  DEFINE_THEME_WHITE_COLOR;
//            self.buttonBackgroundColor = DEFINE_THEME_WHITE_COLOR;
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) {
                self.buttonBackgroundColor =  DEFINE_THEME_BLACK_COLOR;
            }else{
                self.buttonBackgroundColor =  DEFINE_THEME_WHITE_COLOR;
            }
            self.statusColor = YES;
            break;
        }
        case APPSTYLE_RED:
        {
            self.backgroundColor = DEFINE_THEME_RED_COLOR;
            self.circleBackgroundColor = RGBColor(255, 255, 255, 0.15);
            self.labelColor =  DEFINE_THEME_WHITE_COLOR;
//            self.buttonBackgroundColor = DEFINE_THEME_WHITE_COLOR;
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) {
                self.buttonBackgroundColor =  DEFINE_THEME_BLACK_COLOR;
            }else{
                self.buttonBackgroundColor =  DEFINE_THEME_WHITE_COLOR;
            }
            self.statusColor = YES;
            break;
        }
        case APPSTYLE_GREEN:
        {
            self.backgroundColor = DEFINE_THEME_GREEN_COLOR;
            self.circleBackgroundColor = RGBColor(255, 255, 255, 0.15);
            self.labelColor =  DEFINE_THEME_WHITE_COLOR;
//            self.buttonBackgroundColor = DEFINE_THEME_WHITE_COLOR;
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) {
                self.buttonBackgroundColor =  DEFINE_THEME_BLACK_COLOR;
            }else{
                self.buttonBackgroundColor =  DEFINE_THEME_WHITE_COLOR;
            }
            self.statusColor = YES;
            break;
        }
        case APPSTYLE_BLUE:
        {
            self.backgroundColor = DEFINE_THEME_BLUE_COLOR;
            self.circleBackgroundColor = RGBColor(255, 255, 255, 0.15);
            self.labelColor =  DEFINE_THEME_WHITE_COLOR;
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) {
                self.buttonBackgroundColor =  DEFINE_THEME_BLACK_COLOR;
            }else{
                self.buttonBackgroundColor =  DEFINE_THEME_WHITE_COLOR;
            }
//            self.buttonBackgroundColor = DEFINE_THEME_WHITE_COLOR;
            self.statusColor = YES;
            break;
        }
        default:
        {
            self.backgroundColor = DEFINE_THEME_BLACK_COLOR;
            self.circleBackgroundColor = RGBColor(255, 255, 255, 0.15);
            self.labelColor =  DEFINE_THEME_WHITE_COLOR;
//            self.buttonBackgroundColor = DEFINE_THEME_WHITE_COLOR;
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) {
                self.buttonBackgroundColor =  DEFINE_THEME_BLACK_COLOR;
            }else{
                self.buttonBackgroundColor =  DEFINE_THEME_WHITE_COLOR;
            }
            self.statusColor = YES;
            break;
        }
    }
}

- (UIColor *) mainColorForStyle:(AppStyle) style
{
    UIColor *mainColor;
    
    switch (style)
    {
        case APPSTYLE_WHITE:
        {
            mainColor = DEFINE_THEME_WHITE_COLOR;
            
            break;
        }
        case APPSTYLE_GRAY:
        {
            mainColor = DEFINE_THEME_GRAY_COLOR;
            break;
        }
        case APPSTYLE_DARKGRAY:
        {
            mainColor = DEFINE_THEME_DARK_GRAY_COLOR;
            break;
        }
        case APPSTYLE_BLACK:
        {
            mainColor = DEFINE_THEME_BLACK_COLOR;
            break;
        }
        case APPSTYLE_ROSE:
        {
            mainColor =  DEFINE_THEME_ROSE_COLOR;
            break;
        }
        case APPSTYLE_VIOLET:
        {
            mainColor = DEFINE_THEME_VIOLET_COLOR;
            break;
        }
        case APPSTYLE_RED:
        {
            mainColor  = DEFINE_THEME_RED_COLOR;
            break;
        }
        case APPSTYLE_GREEN:
        {
            mainColor  = DEFINE_THEME_GREEN_COLOR;
            break;
        }
        case APPSTYLE_BLUE:
        {
            mainColor = DEFINE_THEME_BLUE_COLOR;
            break;
        }
        default:
        {
            mainColor = DEFINE_THEME_BLACK_COLOR;
            break;
        }
    }
    
    return mainColor;
}

- (NSString *) themeNameForStyle:(AppStyle) style
{
    NSString *themeName;
    
    switch (style)
    {
        case APPSTYLE_WHITE:
        {
            themeName = @"Light gray".localized;
            break;
        }
        case APPSTYLE_GRAY:
        {
            themeName = @"Gray".localized;
            break;
        }
        case APPSTYLE_DARKGRAY:
        {
            themeName = @"Dark gray".localized;
            break;
        }
        case APPSTYLE_BLACK:
        {
            themeName = @"Black".localized;
            break;
        }
        case APPSTYLE_ROSE:
        {
            themeName = @"Rose".localized;
            break;
        }
        case APPSTYLE_VIOLET:
        {
            themeName = @"Violet".localized;
            break;
        }
        case APPSTYLE_RED:
        {
            themeName = @"Red".localized;
            break;
        }
        case APPSTYLE_GREEN:
        {
            themeName = @"Green".localized;
            break;
        }
        case APPSTYLE_BLUE:
        {
            themeName = @"Blue".localized;
            break;
        }
        default:
        {
            themeName = @"Black".localized;
            break;
        }
    }
    
    return themeName;
}

- (AppStyle) getCurrentStyle
{
    return self.currentStyle;
}

@end
