#import "AppDelegate.h"

@interface AppDelegate (RateButton)

- (void)checkRateUsButton;
- (void)createTopButton;
- (void)checkRateUsButton:(void(^)(BOOL coincides))completion;
- (void)handleBackground:(UIApplication *)application;
- (void)resetRateUsButton;
@end
