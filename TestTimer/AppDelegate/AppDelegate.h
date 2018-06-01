//
//  AppDelegate.h
//  TestTimer
//
//  Created by a on 12/30/15.
//  Copyright © 2015 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RateUsButton.h"
#import "Appirater.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,AppiraterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign,nonatomic) BOOL allowRotation;

@property (strong, nonatomic) RateUsButton *rateUsButton;

@property (assign, nonatomic) BOOL stopBackgroundTask;

@end

