//
//  MainAppConnectivity.m
//  Cloudify
//
//  Created by Radoo on 08/12/15.
//  Copyright © 2015 SIC. All rights reserved.
//

#import "MainAppConnectivity.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "AppDelegate.h"

@interface MainAppConnectivity() <WCSessionDelegate>
{
    AppDelegate *appDelegate;
}

@end

@implementation MainAppConnectivity

#pragma mark - Initializations
+ (id) sharedConnection
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void) activateWatchSession
{
    if ([WCSession isSupported])
    {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

- (BOOL) sessionCanBeEstablished
{
    return ([WCSession isSupported] && [[WCSession defaultSession] isPaired] && [[WCSession defaultSession] isReachable]);
}

#pragma mark - Sending Messages
//- (void) sendCurrentSpeedMessage:(int) speed withSpeedLimit:(int) speedLimit andAltitude:(float) altitude;
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:@"0" forKey:@"opperation"];
//    [dict setValue:[NSNumber numberWithInt:speed] forKey:@"speed"];
//    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"measureUnit"] forKey:@"measureUnit"];
//    [dict setValue:[NSNumber numberWithInt:speedLimit] forKey:@"speedLimit"];
//    [dict setValue:[NSNumber numberWithFloat:altitude] forKey:@"altitude"];
//    
//    TripObject *tripObject = [[DatabaseManager sharedInstance] getCurrentTrip:[[NSUserDefaults standardUserDefaults] objectForKey:tripIdKey]];
//    [dict setValue:tripObject.time forKey:@"tripDuration"];
//    [dict setValue:tripObject.maxSpeed forKey:@"tripTopSpeed"];
//    [dict setValue:tripObject.averageSpeed forKey:@"tripAvgSpeed"];
//    [dict setValue:tripObject.distance forKey:@"tripDistance"];
//
//    [self sendMessage:@{@"testKey" : dict}];
//}
//
//- (void) sendCurrentMeasureUnit
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:@"1" forKey:@"opperation"];
//    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"measureUnit"] forKey:@"measureUnit"];
//    
//    [self sendMessage:@{@"testKey" : dict}];
//}
//
//- (void) sendCurrentSpeedLimitMessage:(int) speedLimit
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:@"2" forKey:@"opperation"];
//    [dict setValue:[NSNumber numberWithInt:speedLimit] forKey:@"speedLimit"];
//    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"measureUnit"] forKey:@"measureUnit"];
//
//    [self sendMessage:@{@"testKey" : dict}];
//}
//
//- (void) sendCurrentAltitudeMessage:(float) altitude
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:@"3" forKey:@"opperation"];
//    [dict setValue:[NSNumber numberWithFloat:altitude] forKey:@"altitude"];
//    [self sendMessage:@{@"testKey" : dict}];
//}

- (void) sendMessage:(NSDictionary *) message
{
    if (![self sessionCanBeEstablished])
    {
        return;
    }
    
    [[WCSession defaultSession] sendMessage:message replyHandler:^(NSDictionary<NSNumber *,id> * _Nonnull replyMessage)
     {
         NSLog(@"Reply message from watch application: %@",replyMessage);
     } errorHandler:^(NSError * _Nonnull error)
     {
         NSLog(@"Error on sending message to watch application: %@",error.localizedDescription);
     }];
}

#pragma mark - WCSessionDelegate Methods
- (void) session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)userInfo replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSLog(@"userInfo = %@", userInfo);
//        NSDictionary *response = userInfo[@"testKey"];
//        
//        switch ([response[@"opperation"] intValue])
//        {
//            case 0:
//            {
//                // MEASURE UNIT CHANGED FROM WATCH
//                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"measureUnit"] intValue] == KPH)
//                {
//                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:MPH] forKey:@"measureUnit"];
//                }
//                else
//                {
//                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:KPH] forKey:@"measureUnit"];
//                }
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                [[NSNotificationCenter defaultCenter] postNotificationName:MeasureUnitChangedFromWatchNotification object:nil];
//                
//                replyHandler([self sendMeasureUnitAndSpeed]);
//                break;
//            }
//            case 1:
//            {
//                // SEND DATA FROM PHONE TO WATCH
//                replyHandler([self sendMeasureUnitAndSpeed]);
//                break;
//            }
//            case 2:
//            {
//                // SEND CURRENT SPEED LIMIT TO WATCH
//                replyHandler([self sendCurrentSppedLimit]);
//                break;
//            }
//                
//            default: replyHandler(@{@"status" : @"main app received message"});
//        }
        
        replyHandler(@{@"status" : @"main app received message"});
    });
}

#pragma mark - Response Methods
//- (NSDictionary *) sendMeasureUnitAndSpeed
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:@"3" forKey:@"opperation"];
//    [dict setValue:[NSNumber numberWithInt:[SMLocationManager sharedManager].currentSpeed] forKey:@"speed"];
//    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"measureUnit"] forKey:@"measureUnit"];
//    return dict;
//}
//
//- (NSDictionary *) sendCurrentSppedLimit
//{
//    SpeedLimitObject *speedLimitObject = [[DatabaseManager sharedInstance] getCurrentSpeedLimit:[[NSUserDefaults standardUserDefaults] objectForKey:speedLimitIdKey]];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:@"4" forKey:@"opperation"];
//    [dict setValue:speedLimitObject.maxSpeed forKey:@"speedLimit"];
//    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"measureUnit"] forKey:@"measureUnit"];
//    return dict;
//}

@end
