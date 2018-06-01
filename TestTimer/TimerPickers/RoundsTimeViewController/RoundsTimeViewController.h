//
//  RoundsTimeViewController.h
//  TestTimer
//
//  Created by a on 1/20/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#define shouldNotRotate @"shouldNotRotate"
@protocol RoundsTimeViewControllerDelegate <NSObject>
@required
-(void) dataFromRoundTimeMinViewController:(NSInteger) fullSecData pickedMinValue:(NSInteger) minPicked pickedSecValue:(NSInteger) secPick pickedColorCell:(NSInteger) selectedColorIndex;

@end
@interface RoundsTimeViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
#define kMinComponent 0
#define kSecComponent 1


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pickerHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelRightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelTopConstraint;

@property (strong,nonatomic)  IBOutlet UIButton *doneButton;

@property (strong, nonatomic) IBOutlet UIView *uiviewForPickerView;

@property(retain,nonatomic) NSMutableArray *minArray;
@property(retain,nonatomic) NSMutableArray *secArray;

@property(assign,nonatomic) NSInteger fullValuesSeconds;

@property  NSInteger roundTimeMin;
@property  NSInteger roundTimeSec;

@property(weak,nonatomic) id<RoundsTimeViewControllerDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIPickerView *roundsTimePicker;
@property (strong, nonatomic) IBOutlet UIView *customViewForRoundsTime;
@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;

@property (strong, nonatomic) IBOutlet UIImageView *navBarImageView;

#pragma mark - IBoutlet Collection View
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

#pragma mark - Index for selectedIndexCollectionViewCells
@property (assign,nonatomic) NSInteger selectedIndexInCollectionViewCell;


@property (strong,nonatomic) NSString *type;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelWidthConstraint;
@end
