//
//  MainAppConnectivity.h
//  Cloudify
//
//  Created by Radoo on 08/12/15.
//  Copyright © 2015 SIC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MeasureUnitChangedFromWatchNotification @"MeasureUnitChangedFromWatchNotification"

@interface MainAppConnectivity : NSObject

+ (id)sharedConnection;
- (void)activateWatchSession;
- (BOOL)sessionCanBeEstablished;
- (void)sendMessage:(NSDictionary *)message;

//- (void) sendCurrentSpeedMessage:(int) speed withSpeedLimit:(int) speedLimit andAltitude:(float) altitude;
//- (void) sendCurrentMeasureUnit;
//- (void) sendCurrentSpeedLimitMessage:(int) speedLimit;
//- (void) sendCurrentAltitudeMessage:(float) altitude;

@end


