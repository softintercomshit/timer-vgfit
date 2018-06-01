//
//  WorkTimeViewController.h
//  TestTimer
//
//  Created by a on 12/30/15.
//  Copyright © 2015 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#define shouldNotRotate @"shouldNotRotate"
@protocol WorkTimeViewControllerDelegate <NSObject>
@required
-(void) dataFromWorkTimeMinViewController:(NSInteger)dataFullValue
                        pickedMinuteValue:(NSInteger)minPick
                        pickedSecondValue:(NSInteger) secPick
                    pickedColorIndexValue:(NSInteger)colorIndex;
@end
@interface WorkTimeViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

# define kMinutesComponent 0
# define kSecondsComponent 1


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelRightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pickerHeightConstraint;


@property(retain,nonatomic) NSMutableArray *minutesArray;
@property(retain,nonatomic) NSMutableArray *secondsArray;

@property (strong,nonatomic) NSString *selectedWorkTimeColor;

@property (assign,nonatomic) NSInteger fullValue;
@property (assign,nonatomic) NSInteger selectedRowinMin;
@property (assign,nonatomic) NSInteger selectedRowinSec;
@property (assign,nonatomic) NSInteger selectedWorkTimeIndexInCollectionView;
@property (strong,nonatomic) NSString *type;

@property (strong, nonatomic) IBOutlet UIPickerView *workTimePicker;
@property (strong,nonatomic)  IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIView *customViewWorkTime;
@property (strong, nonatomic) IBOutlet UICollectionView *workTimeCollectionView;

@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;

#pragma mark - Custom UI Nav Bar

@property (strong, nonatomic) IBOutlet UIImageView *navBarImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelWidthConstraint;









@property(weak,nonatomic) id<WorkTimeViewControllerDelegate>delegate;

@end
