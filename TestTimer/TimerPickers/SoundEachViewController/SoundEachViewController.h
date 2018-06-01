//
//  SoundEachViewController.h
//  TestTimer
//
//  Created by a on 1/22/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#define shouldNotRotate @"shouldNotRotate"
@protocol SoundEachViewControllerDelegate <NSObject>
@required
-(void) dataFromSoundEachMinViewController:(NSInteger) data
                           pickedMinValue :(NSInteger) minPicked
                            pickedSecValue:(NSInteger) secPicked;
@end

@interface SoundEachViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
#define kMinComponent 0
#define kSecComponent 1


@property (strong, nonatomic) IBOutlet UIPickerView *timeLapSoundPicker;


@property(retain,nonatomic) NSMutableArray *minutesArray;
@property(retain,nonatomic) NSMutableArray *secondsArray;

@property (assign,nonatomic) NSInteger fullSecSoundEach;
@property (assign,nonatomic) NSInteger soundEachMin;
@property (assign,nonatomic) NSInteger soundEachSec;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewNavBar;

@property(weak,nonatomic) id<SoundEachViewControllerDelegate>delegate;

@property(strong,nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) IBOutlet UIView *customViewTimeLap;
@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelWidthConstraint;
@end
