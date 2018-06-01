#import "UINavigationController+Transparent.h"

@implementation UINavigationController (Transparent)

- (void)setNavbarAppearence {
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
}

- (void)setNavbarBackgroundImage {
//    [self setStatusBarBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
//    UIImage *image = [UIImage imageNamed:@"bg_tab"];
//            [self.navigationBar setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    
//    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
//    [imageView setClipsToBounds:true];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.alpha = 0.15;
//
//    CGRect frame = self.navigationBar.bounds;
//    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//    frame.size.height += statusBarHeight;
//    frame.origin.y -= statusBarHeight;
//    [imageView setFrame:frame];
    
//    [self.navigationBar addSubview:imageView];
   
//    [self.navigationBar setBackgroundColor:[[AppTheme sharedManager] backgroundColor]];
//    [self.navigationBar setBarTintColor:[[AppTheme sharedManager] backgroundColor]];
//    self.navigationBar.translucent = false;
//    [[UIApplication sharedApplication].keyWindow addSubview:imageView];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.alpha = 0.5;
        statusBar.backgroundColor = color;
    }
}


@end
