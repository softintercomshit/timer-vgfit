//
//  AppInfo.m
//  MyApp5
//
//  Created by Radu on 6/16/16.
//  Copyright © 2016 kat. All rights reserved.
//

#import "AppInfo.h"

@interface AppInfo()

@property (copy, nonatomic) NSString *applicationID;
@property (copy, nonatomic) NSString *shortURL;

@end

@implementation AppInfo

#pragma mark - Initializations
+ (AppInfo *) sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark - Info
- (void) updateInfoWithCompletion:(AppInfoResultBlock) completion
{
    [self updateAppIDWithCompletion:^(BOOL success) {
        
        if (success)
        {
            [self updateShortURLWithCompletion:^(BOOL success) {
               
                if (completion)
                {
                    completion(success);
                }
            }];
        }
        else
        {
            if (completion)
            {
                completion(success);
            }
        }
    }];
}

- (void) updateAppIDWithCompletion:(AppInfoResultBlock) completion
{
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", [self bundleID]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        BOOL success = NO;
        
        if (!connectionError)
        {
            NSError *jsonError;
            NSJSONSerialization *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError && [jsonResponse isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = (NSDictionary *)jsonResponse;
                NSDictionary *infoDict = [dict[@"results"] firstObject];
                NSString *trackID = [infoDict[@"trackId"] stringValue];
                //![trackID isEmpty]
                if ([trackID length]!=0)
                {
                    self.applicationID = trackID;
                    success = YES;
                }
            }
        }
        else
        {
            success = NO;
        }
        
        if (completion)
        {
            completion(success);
        }
    }];
}
- (void) updateShortURLWithCompletion:(AppInfoResultBlock) completion
{
    NSString *urlString = [NSString stringWithFormat:@"http://is.gd/create.php?format=simple&url=%@", [self storeAppLink]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        BOOL success = NO;
        
        if (!connectionError)
        {
            NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            self.shortURL = resultString;
        }
        else
        {
            success = NO;
        }
        
        if (completion)
        {
            completion(success);
        }
    }];
}

- (NSString *) bundleID
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (NSString *) appID
{
    return self.applicationID;
}

- (NSString *) storeAppLink
{
    return [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",_applicationID];
}

- (NSString *) redirectStoreAppLink
{
    return [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",_applicationID];
}

- (NSString *) shortAppURL
{
    return self.shortURL;
}

@end
