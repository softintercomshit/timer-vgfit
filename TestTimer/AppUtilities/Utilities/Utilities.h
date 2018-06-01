//
//  Utilities.h
//  TestTimer
//
//  Created by a on 4/8/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

//#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
//DEVICE_HAS_3_5_INCH pentru iphone_4
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD_PRO (SCREEN_MAX_LENGTH == 1366.0)

#define IS_IPAD (SCREEN_MAX_LENGTH == 1024.0 || SCREEN_MAX_LENGTH == 1112.0)

#define RGBColor(r,g,b,a) [UIColor colorWithRed:(r/(float)255) green:(g/(float)255) blue:(b/(float)255) alpha:a]


#define supportEmailAddress @"support@vgfit.com"

//#define IS_IPAD_PRO_1024 (IS_IPAD && MAX(SCREEN_WIDTH,SCREEN_HEIGHT) == 1024.0)
@interface Utilities : NSObject





+ (NSString *) coreDataDatabasePath;
+ (NSString *) getDocumentsPath;
+ (NSString *) getLibraryPath;
+ (NSString *) getCachePath;
+ (NSString *) deviceModel;
+ (NSString *) systemVersion;
+ (NSString *) applicationNameAndVersion;


// Work text localized

+ (NSString *) getWorkTitleLocalized;
+ (NSString *) getRestTitleLocalized;
+ (NSString *) getRbcTitleLocalized;

+ (NSString*)tabataTitle:(TabataCircleType)circleType;
+ (NSString*)roundsTitle:(RoundsCircleType)circleType;
+ (NSString*)stopwatchTitle:(StopwatchCircleType)circleType;



+ (NSString*)setSongTitle:(SongNames)songNames;

+ (UIColor *)circleColor:(NSInteger)indexColor;

+ (NSString *)timeFormatString:(NSNumber *)timerInterval;

+ (UIColor *)getYellowColor;
+ (UIColor *)getGreenColor;
+ (UIColor *)getRedColor;
+ (UIColor *)getBlueColor;
+ (UIColor *)getTurquoiseColor;

+ (UIImage*)imageAtDefaultIndex:(IndexName)defaultIndex;
+ (UIImage*)loadTabataIntervalsColorForIndex:(NSInteger)selectedIndex;

+ (UIImage*)imageAtRoundsDefaultIndex:(RoundsIndexName)roundsDefaultIndex;
+ (UIImage*)loadRoundsIntervalsColorForIndex:(NSInteger)pickedIndex;

+ (UIColor*)loadVisualStyleThemeIndexColor:(NSInteger)pickedColorIndex;


//+ (BOOL)deviceHasAreaInsets;
@property(nonatomic, class) BOOL deviceHasAreaInsets;

+ (UIViewController*)topMostController;

@end
