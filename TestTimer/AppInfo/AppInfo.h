//
//  AppInfo.h
//  MyApp5
//
//  Created by Radu on 6/16/16.
//  Copyright © 2016 kat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AppInfoResultBlock)(BOOL success);

@interface AppInfo : NSObject

#pragma mark - Initializations
+ (AppInfo *) sharedManager;

#pragma mark - Info
- (void) updateInfoWithCompletion:(AppInfoResultBlock) completion;
- (NSString *) bundleID;
- (NSString *) appID;
- (NSString *) storeAppLink;
- (NSString *) redirectStoreAppLink;
- (NSString *) shortAppURL;

@end
