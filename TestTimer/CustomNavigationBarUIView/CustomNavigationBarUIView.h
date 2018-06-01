//
//  CustomNavigationBarUIView.h
//  TestTimer
//
//  Created by Andrei on 12/7/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationBarUIView : UIView


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;


- (void)setupPortraitConstraint;
- (void)setupLandscapeConstraint;
- (void)setupColor;

@end
