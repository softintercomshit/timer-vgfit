//
//  Utilities.m
//  TestTimer
//
//  Created by a on 4/8/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "Utilities.h"
#import <sys/utsname.h>
@import UIKit;
@implementation Utilities

+ (NSString *) coreDataDatabasePath
{
    return [[[self getDocumentsPath] stringByAppendingPathComponent:CORE_DATA_DATABASE_FOLDER_NAME] stringByAppendingPathComponent:CORE_DATA_DATABASE_NAME];
}

+ (NSString *) getDocumentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *) getLibraryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *) getCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
+ (NSString *) deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceOriginalName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *deviceFormattedName = deviceOriginalName;
    
    if ([deviceOriginalName isEqualToString:@"iPhone1,1"])   deviceFormattedName = @"iPhone 2G";                   //iPhone 2G
    else if ([deviceOriginalName isEqualToString:@"iPhone1,2"])   deviceFormattedName = @"iPhone 3G";              //iPhone 3G
    else if ([deviceOriginalName isEqualToString:@"iPhone2,1"])   deviceFormattedName = @"iPhone 3GS";             //iPhone 3GS
    else if ([deviceOriginalName isEqualToString:@"iPhone3,1"])   deviceFormattedName = @"iPhone 4";               //iPhone 4 - AT&T
    else if ([deviceOriginalName isEqualToString:@"iPhone3,2"])   deviceFormattedName = @"iPhone 4";               //iPhone 4 - Other carrier
    else if ([deviceOriginalName isEqualToString:@"iPhone3,3"])   deviceFormattedName = @"iPhone 4";               //iPhone 4 - Other carrier
    else if ([deviceOriginalName isEqualToString:@"iPhone4,1"])   deviceFormattedName = @"iPhone 4S";              //iPhone 4S
    else if ([deviceOriginalName isEqualToString:@"iPhone5,1"])   deviceFormattedName = @"iPhone 5";               //iPhone 5 (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPhone5,2"])   deviceFormattedName = @"iPhone 5";               //iPhone 5 (GSM+CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPhone5,3"])   deviceFormattedName = @"iPhone 5c";              //iPhone 5c (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPhone5,4"])   deviceFormattedName = @"iPhone 5c";              //iPhone 5c (GSM+CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPhone6,1"])   deviceFormattedName = @"iPhone 5s";              //iPhone 5s (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPhone6,2"])   deviceFormattedName = @"iPhone 5s";              //iPhone 5s (GSM+CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPhone7,1"])   deviceFormattedName = @"iPhone 6 Plus";          //iPhone 6+
    else if ([deviceOriginalName isEqualToString:@"iPhone7,2"])   deviceFormattedName = @"iPhone 6";               //iPhone 6
    else if ([deviceOriginalName isEqualToString:@"iPod1,1"])     deviceFormattedName = @"iPod Touch 1st Gen";     //iPod Touch 1G
    else if ([deviceOriginalName isEqualToString:@"iPod2,1"])     deviceFormattedName = @"iPod Touch 2nd Gen";     //iPod Touch 2G
    else if ([deviceOriginalName isEqualToString:@"iPod3,1"])     deviceFormattedName = @"iPod Touch 3rd Gen";     //iPod Touch 3G
    else if ([deviceOriginalName isEqualToString:@"iPod4,1"])     deviceFormattedName = @"iPod Touch 4th Gen";     //iPod Touch 4G
    else if ([deviceOriginalName isEqualToString:@"iPod5,1"])     deviceFormattedName = @"iPod Touch 5th Gen";     //iPod Touch 5G
    else if ([deviceOriginalName isEqualToString:@"iPad1,1"])     deviceFormattedName = @"iPad 1";                 //iPad Wifi
    else if ([deviceOriginalName isEqualToString:@"iPad1,2"])     deviceFormattedName = @"iPad 1";                 //iPad 3G
    else if ([deviceOriginalName isEqualToString:@"iPad2,1"])     deviceFormattedName = @"iPad 2";                 //iPad 2 (WiFi)
    else if ([deviceOriginalName isEqualToString:@"iPad2,2"])     deviceFormattedName = @"iPad 2";                 //iPad 2 (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPad2,3"])     deviceFormattedName = @"iPad 2";                 //iPad 2 (CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPad2,4"])     deviceFormattedName = @"iPad 2";                 //iPad 2 (WiFi)
    else if ([deviceOriginalName isEqualToString:@"iPad2,5"])     deviceFormattedName = @"iPad Mini";              //iPad Mini (WiFi)
    else if ([deviceOriginalName isEqualToString:@"iPad2,6"])     deviceFormattedName = @"iPad Mini";              //iPad Mini (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPad2,7"])     deviceFormattedName = @"iPad Mini";              //iPad Mini (GSM+CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPad3,1"])     deviceFormattedName = @"iPad 3";                 //iPad 3 (WiFi)
    else if ([deviceOriginalName isEqualToString:@"iPad3,2"])     deviceFormattedName = @"iPad 3";                 //iPad 3 (GSM+CDMA)
    else if ([deviceOriginalName isEqualToString:@"iPad3,3"])     deviceFormattedName = @"iPad 3";                 //iPad 3 (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPad3,4"])     deviceFormattedName = @"iPad 4";                 //iPad 4 (WiFi)
    else if ([deviceOriginalName isEqualToString:@"iPad3,5"])     deviceFormattedName = @"iPad 4";                 //iPad 4 (GSM)
    else if ([deviceOriginalName isEqualToString:@"iPad3,6"])     deviceFormattedName = @"iPad 4";                 //iPad 4 (GSM+CDMA)
    else if ([deviceOriginalName isEqualToString:@"i386"])        deviceFormattedName = @"Simulator";              //Simulator
    else if ([deviceOriginalName isEqualToString:@"x86_64"])      deviceFormattedName = @"Simulator";              //Simulator
    
    return deviceFormattedName;
}


+ (NSString *) systemVersion
{
    return [NSString stringWithFormat:@"iOS %@",[UIDevice currentDevice].systemVersion];
}


+ (NSString *)applicationNameAndVersion
{
    return [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

+ (NSString *) getWorkTitleLocalized {
    return [NSString stringWithFormat:@"%@:",@"Work".localized];
}


+ (NSString *) getRestTitleLocalized {
    return [NSString stringWithFormat:@"%@:",@"Rest".localized];
}


+ (NSString *) getRbcTitleLocalized {
    return [NSString stringWithFormat:@"%@:",@"Rest BC".localized];
}

// Timer colors

+ (UIColor *) getYellowColor {
    return RGBColor(254, 255, 60, 1);
}


+ (UIColor *) getGreenColor {
    return RGBColor(85, 216, 109, 1);
}


+ (UIColor *) getRedColor {
    return RGBColor(255, 120, 106, 1);
}


+ (UIColor *) getBlueColor {
    return RGBColor(61, 173, 231, 1);
}

+ (UIColor *) getTurquoiseColor {
    return RGBColor(72, 209, 204, 1);
}


// Tabata timer title posibilities

+ (NSString*)tabataTitle:(TabataCircleType)circleType {
    NSString *title;
    switch (circleType) {
        case Work:
            title = @"Work".localized;
            break;
        case Prepare:
            title = @"Prepare".localized;
            break;
        case Rest:
            title = @"Rest".localized;
            break;
        case RestBetweenCycles:
            title = @"Rest BC".localized;
            break;
        default:
            title = @"Prepare".localized;
            break;
    }
    return title;
}


+ (NSString*)stopwatchTitle:(StopwatchCircleType)circleType {
    NSString *title;
    switch (circleType) {
        case StopwatchPrepare:
            title = @"Prepare".localized;
            break;
            case StopwatchTimeLap:
            title = @"Time lap".localized;
            break;
        default:
            title = @"Prepare".localized;
            break;
    }
    return title;
}


+ (NSString*)roundsTitle:(RoundsCircleType)circleType {
    NSString *title;
    switch (circleType) {
        case RoundsWork:
            title = @"Work".localized;
            break;
        case RoundsPrepare:
            title = @"Prepare".localized;
            break;
        case RoundsRest:
            title = @"Rest".localized;
            break;
        default:
            title = @"Prepare".localized;
            break;
    }
    return title;
}


+ (NSString*)setSongTitle:(SongNames)songNames {
    NSString *title;
    switch (songNames) {
        case AirHorn:
            title = @"Air Horn";
            break;
        case Beep:
            title = @"Beep";
            break;
        case BoxingBell:
            title = @"Boxing Bell";
            break;
        case Buzzer:
            title = @"Buzzer";
            break;
        case Censor:
            title = @"Censor";
            break;
        case ChineseGong:
            title = @"Chinese Gong";
            break;
        case Ding:
            title = @"Ding";
            break;
        case DoubleDing:
            title = @"Double Ding";
            break;
        case MetalDing:
            title = @"Metal Ding";
            break;
        case Punch:
            title = @"Punch";
            break;
        case RefereeWhistle:
            title = @"Referee Whistle";
            break;
        case SirenHorn:
            title = @"Siren Horn";
            break;
        case SportsWhistle:
            title = @"Sports Whistle";
            break;
        case Tone:
            title = @"Tone";
            break;
        default:
            title = @"Air Horn";
            break;
    }
    return title;
}

+ (UIColor *)circleColorDefault:(TabataCircleType)circleType {
    UIColor *color;
    switch (circleType) {
        case Prepare:
            return [Utilities getYellowColor];
            break;
        case Work:
            return [Utilities getGreenColor];
            break;
        case Rest:
            return [Utilities getRedColor];
            break;
        case RestBetweenCycles:
            return [Utilities getYellowColor];
            break;
        default:
            break;
    }
    return color;
}


+ (UIColor *)circleColor:(NSInteger)indexColor {
    
    switch (indexColor) {
         case 1:
            return [Utilities getYellowColor];
            break;
        case 2:
            return [Utilities getGreenColor];
            break;
        case 3:
            return [Utilities getBlueColor];
            break;
        case 4:
            return [Utilities getTurquoiseColor];
            break;
        case 5:
            return [Utilities getRedColor];
            break;
        default:
            return [Utilities getYellowColor];
            break;
    }
    return nil;
}


+ (NSString *) timeFormatString:(NSNumber *)timerInterval {
    NSInteger totalTimeMinutes = timerInterval.integerValue / 60;
    NSInteger totalTimeSeconds = timerInterval.integerValue  % 60;
    
    NSString *timeFormatString;
    
    switch ([[SettingsManagerImplementation sharedInstance]timerFormat]) {
        case MinSec:
            timeFormatString = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)totalTimeMinutes, (long)totalTimeSeconds];
            break;
        case MilisecondsOneDigit:
            timeFormatString = [NSString stringWithFormat:@"%.1ld:%.2ld.0", (long)totalTimeMinutes, (long)totalTimeSeconds];
            break;
        case MilisecondsTwoDigits:
            timeFormatString = [NSString stringWithFormat:@"%.2ld:%.2ld.00", (long)totalTimeMinutes, (long)totalTimeSeconds];
            break;
        default:
            timeFormatString = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)totalTimeMinutes, (long)totalTimeSeconds];
            break;
    }
    return timeFormatString;
}

//+ (BOOL)deviceHasAreaInsets {
//    if (@available(iOS 11, *)) {
//        return !UIEdgeInsetsEqualToEdgeInsets([UIApplication sharedApplication].delegate.window.safeAreaInsets, UIEdgeInsetsZero);
//    }
//    return false;
//}

+ (BOOL)deviceHasAreaInsets  {
    if (@available(iOS 11, *)) {
        return !UIEdgeInsetsEqualToEdgeInsets([UIApplication sharedApplication].delegate.window.safeAreaInsets, UIEdgeInsetsZero);
    }
    return false;
}

+ (UIImage*)imageAtDefaultIndex:(IndexName)defaultIndex{
    
    UIImage *image;
    switch (defaultIndex) {
        case PrepareIndex:
            image = [UIImage imageNamed:@"yellow.png"];
            break;
        case WorkIndex:
            image = [UIImage imageNamed:@"green.png"];
            break;
        case RestIndex:
            image = [UIImage imageNamed:@"red.png"];
            break;
        case RoundsIndex:
            image = [UIImage imageNamed:@"blue.png"];
            break;
        case CyrclesIndex:
            image = [UIImage imageNamed:@"turquoise.png"];
            break;
        case RestBetweenCyrclesIndex:
            image = [UIImage imageNamed:@"red.png"];
            break;
        default:
            image = [UIImage imageNamed:@"yellow.png"];
            break;
    }
    return image;
}

+ (UIImage*)loadTabataIntervalsColorForIndex:(NSInteger)selectedIndex {
    UIImage *image;
    switch (selectedIndex) {
        case 0:
            image = [self imageAtDefaultIndex:selectedIndex];
            break;
        case 1:
            image = [UIImage imageNamed:@"yellow.png"];
            break;
        case 2:
            image = [UIImage imageNamed:@"green.png"];
            break;
        case 3:
            image =[UIImage imageNamed:@"blue.png"];
            break;
        case 4:
            image =[UIImage imageNamed:@"turquoise.png"];
            break;
        case 5:
            image =[UIImage imageNamed:@"red.png"];
            break;
        default:
            image =[UIImage imageNamed:@"yellow.png"];
            break;
    }
    return image;
}


+ (UIImage*)imageAtRoundsDefaultIndex:(RoundsIndexName)roundsDefaultIndex {
    UIImage *image;
    switch (roundsDefaultIndex) {
        case RoundsPrepareIndex:
            image = [UIImage imageNamed:@"yellow.png"];
            break;
        case RoundsWorkIndex:
            image = [UIImage imageNamed:@"green.png"];
            break;
        case RoundsRestIndex:
            image = [UIImage imageNamed:@"red.png"];
            break;
        case RoundsIndexCountIndex:
            image = [UIImage imageNamed:@"blue.png"];
            break;
        default:
            image = [UIImage imageNamed:@"yellow.png"];
            break;
    }
    return image;
}


+ (UIImage *)loadRoundsIntervalsColorForIndex:(NSInteger)pickedIndex {
    UIImage *image;
    switch (pickedIndex) {
        case 0:
            image = [self imageAtRoundsDefaultIndex:pickedIndex];
            break;
        case 1:
            image = [UIImage imageNamed:@"yellow.png"];
            break;
        case 2:
            image = [UIImage imageNamed:@"green.png"];
            break;
        case 3:
            image =[UIImage imageNamed:@"blue.png"];
            break;
        case 4:
            image =[UIImage imageNamed:@"turquoise.png"];
            break;
        case 5:
            image =[UIImage imageNamed:@"red.png"];
            break;
        default:
            image =[UIImage imageNamed:@"yellow.png"];
            break;
    }
    return image;
}


+ (UIColor*)loadVisualStyleThemeIndexColor:(NSInteger)pickedColorIndex {
    UIColor *backgroundColor;
    switch (pickedColorIndex) {
        case 0:
            backgroundColor = DEFINE_THEME_WHITE_COLOR;
            break;
        case 1:
            backgroundColor = DEFINE_THEME_GRAY_COLOR;
            break;
        case 2:
            backgroundColor =  DEFINE_THEME_DARK_GRAY_COLOR;
            break;
        case 3:
            backgroundColor = DEFINE_THEME_BLACK_COLOR;
            break;
        case 4:
            backgroundColor = DEFINE_THEME_ROSE_COLOR;
            break;
        case 5:
            backgroundColor = DEFINE_THEME_VIOLET_COLOR;
            break;
        case 6:
            backgroundColor =DEFINE_THEME_RED_COLOR;
            break;
        case 7:
            backgroundColor = DEFINE_THEME_GREEN_COLOR;
            break;
        case 8:
            backgroundColor = DEFINE_THEME_BLUE_COLOR;
            break;
        default:
            backgroundColor = DEFINE_THEME_BLACK_COLOR;
            break;
    }
    return backgroundColor;
}


+ (UIViewController*)topMostController {
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    return topController;
}

@end
