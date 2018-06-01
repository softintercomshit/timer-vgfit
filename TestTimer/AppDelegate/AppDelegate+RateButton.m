#import "AppDelegate+RateButton.h"

@implementation AppDelegate (RateButton)

- (void)checkRateUsButton {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRateUsButtonPushedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self createTopButton];
    
    BOOL appIsRatedCloud = [[NSUbiquitousKeyValueStore defaultStore] boolForKey:kiOSAppIsRatedKey];
    BOOL appIsRatedLocaly = [[NSUserDefaults standardUserDefaults] boolForKey:kiOSAppIsRatedKey];
    BOOL appIsRatedAppirater = [[NSUserDefaults standardUserDefaults] boolForKey:kAppiraterRatedCurrentVersion];
    
    NSLog(@"\nLocal rated: %d \niCloud rated: %d \nAppirater: %d", appIsRatedLocaly, appIsRatedCloud, appIsRatedAppirater);
    
    if (appIsRatedCloud || appIsRatedLocaly || appIsRatedAppirater) {
        
        [self.rateUsButton removeFromSuperview];
        [self hardRateApp];
        [Appirater appLaunched:NO];
        
    }else{
        [self checkRateUsButton:^(BOOL coincides) {
            
            if (coincides)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Appirater appLaunched:YES];
                        [self.window addSubview:self.rateUsButton];
                    });
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.rateUsButton removeFromSuperview];
                    [Appirater appLaunched:NO];
                });
            }
        }];
    }
}

- (void)createTopButton {
    if (!self.rateUsButton) {
        self.rateUsButton = [[RateUsButton alloc] init];
    }
}

- (void)checkRateUsButton:(void(^)(BOOL coincides))completion {
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *appBundleString = [[NSBundle mainBundle] bundleIdentifier];
    NSString *appVersionString = [info objectForKey:@"CFBundleShortVersionString"];
    NSString *bundleAndVersionString = [appBundleString stringByAppendingString:appVersionString];
    
    //        debug
//    bundleAndVersionString = @"test";
    
    NSString *urlString = [NSString stringWithFormat:@"http://secret.zemralab.com/api/%@/version",bundleAndVersionString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest
                                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                     
                                                                     if (!error)
                                                                     {
                                                                         NSString *responseFromServer = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         if ([responseFromServer isEqualToString:bundleAndVersionString])
                                                                         {
                                                                             completion(YES);
                                                                         }
                                                                         else
                                                                         {
                                                                             completion(NO);
                                                                         }
                                                                     }
                                                                     else
                                                                     {
                                                                         completion(NO);
                                                                     }
                                                                 }];
    [task resume];
}

- (void)handleBackground:(UIApplication *)application {
    
    __block UIBackgroundTaskIdentifier background_task;
    background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
        
        //Clean up code. Tell the system that we are done.
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    }];
    
    self.stopBackgroundTask = true;
    //To make the code block asynchronous
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        while(self.stopBackgroundTask)
        {
            NSTimeInterval interval = [[UIApplication sharedApplication] backgroundTimeRemaining];
            if (interval <= 175) {
                self.stopBackgroundTask = false;
//                NSLog(@"-----> App was rated");
                
                [self hardRateApp];
                
                [application endBackgroundTask: background_task];
                background_task = UIBackgroundTaskInvalid;
                
            }
        }
        
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    });
}

- (void)resetRateUsButton {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kiOSAppIsRatedKey];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kAppiraterRatedCurrentVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUbiquitousKeyValueStore defaultStore] setBool:NO forKey:kiOSAppIsRatedKey];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

- (void)hardRateApp {
    
    BOOL appIsRatedCloud     = [[NSUbiquitousKeyValueStore defaultStore] boolForKey:kiOSAppIsRatedKey];
    BOOL appIsRatedLocaly    = [[NSUserDefaults standardUserDefaults] boolForKey:kiOSAppIsRatedKey];
    BOOL appIsRatedAppirater = [[NSUserDefaults standardUserDefaults] boolForKey:kAppiraterRatedCurrentVersion];
    
    if (!appIsRatedCloud) {
        [[NSUbiquitousKeyValueStore defaultStore] setBool:YES forKey:kiOSAppIsRatedKey];
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    }
    if (!appIsRatedLocaly) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kiOSAppIsRatedKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (!appIsRatedAppirater) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAppiraterRatedCurrentVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
