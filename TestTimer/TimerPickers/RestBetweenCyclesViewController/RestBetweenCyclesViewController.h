//
//  RestBetweenCyclesViewController.h
//  TestTimer
//
//  Created by a on 3/18/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#define shouldNotRotate @"shouldNotRotate"
@protocol RestBetweenCyclesViewControllerDelegate <NSObject>
@required
-(void) dataFromRestBetweenCyclesViewController:(NSInteger) data
                                 pickedMinValue:(NSInteger) minPick
                                 pickedSecValue:(NSInteger) secPick
                               pickedColorValue:(NSInteger) colorPick;
@end
@interface RestBetweenCyclesViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
# define kMinutesComponent 0
# define kSecondsComponent 1

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pickerHeightConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelRightConstraint;

@property (strong,nonatomic)  IBOutlet UIButton *doneButton;

@property (strong, nonatomic) IBOutlet UIPickerView *restBetweenCyclesPicker;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopConstraint;

@property(retain,nonatomic) NSMutableArray *minutesArray;
@property(retain,nonatomic) NSMutableArray *secondsArray;

@property (assign,nonatomic)  NSInteger fullValuesRestBetweenCyclesSeconds;
@property (assign,nonatomic) NSInteger selectedRestBetweenCyclesRowInMinutes;
@property (assign,nonatomic) NSInteger selectedRestBetweenCyclesRowInSeconds;
@property (assign, nonatomic) NSInteger selectedColorIndexRestBetweenCycles;

@property(weak,nonatomic)  id<RestBetweenCyclesViewControllerDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIView *customRestBetweenCycles;
@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;

@property (strong, nonatomic) IBOutlet UICollectionView *restBetweenCyclesCollectionView;

@property (strong,nonatomic) NSString* selectedRestBetweenCyclesTimeColor;
@property (assign,nonatomic) NSInteger selectedRestBetweenCyclesIndexInCollectionView;

#pragma mark - Custom UIView Rest between cycles controller

@property (strong, nonatomic) IBOutlet UIView *customUIViewRestBetweenCycles;

#pragma mark - UIImageView navbar

@property (strong, nonatomic) IBOutlet UIImageView *navBarImageView;

@property (strong,nonatomic) NSString *type;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelWidthConstraint;
@end
