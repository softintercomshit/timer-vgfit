//
//  ShowSplashScreen.m
//  TestTimer
//
//  Created by user on 9/26/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "ShowSplashScreen.h"
#import "MainUITabbarController.h"

@interface ShowSplashScreen ()

@end

@implementation ShowSplashScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(goToTabbarController) withObject:nil afterDelay:1];
    // Do any additional setup after loading the view.
}
-(void)goToTabbarController{
    
    MainUITabbarController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainUITabbarController"];
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
