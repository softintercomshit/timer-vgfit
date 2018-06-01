//
//  CustomNavigationBarUIView.m
//  TestTimer
//
//  Created by Andrei on 12/7/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import "CustomNavigationBarUIView.h"

@implementation CustomNavigationBarUIView

- (void)setupColor {
    self.backgroundColor = [[AppTheme sharedManager] backgroundColor];
}

- (void)setupPortraitConstraint {
    
    if(Utilities.deviceHasAreaInsets) {
        _heightConstraint.constant = 88;
    }
}


- (void)setupLandscapeConstraint {
    if(Utilities.deviceHasAreaInsets) {
        _heightConstraint.constant = 32;
    }
    
}

@end
