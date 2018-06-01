//
//  AppTheme.h
//  TestTimer
//
//  Created by a on 2/12/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBColor(r,g,b,a) [UIColor colorWithRed:(r/(float)255) green:(g/(float)255) blue:(b/(float)255) alpha:a]
#define AppUpdateThemeNotificationName @"AppUpdateThemeNotificationName"

typedef NS_ENUM(NSInteger, AppStyle)
{
    APPSTYLE_WHITE,
    APPSTYLE_GRAY,
    APPSTYLE_DARKGRAY,
    APPSTYLE_BLACK,
    APPSTYLE_ROSE,
    APPSTYLE_VIOLET,
    APPSTYLE_RED,
    APPSTYLE_GREEN,
    APPSTYLE_BLUE
};

#import <Foundation/Foundation.h>

@interface AppTheme : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic,strong) UIColor *circleBackgroundColor;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, strong) UIColor *navigationColor;
@property (nonatomic, strong) UIColor *buttonBackgroundColor;
@property (nonatomic, assign) BOOL statusColor;


+ (instancetype) sharedManager;
- (void) loadSavedTheme;
- (void) updateThemeWithStyle:(AppStyle) style;
- (UIColor *) mainColorForStyle:(AppStyle) style;
- (AppStyle) getCurrentStyle;
- (NSString *) themeNameForStyle:(AppStyle) style;

@end
