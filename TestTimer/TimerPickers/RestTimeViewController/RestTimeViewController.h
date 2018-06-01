//
//  RestTimeViewController.h
//  TestTimer
//
//  Created by a on 12/30/15.
//  Copyright © 2015 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#define shouldNotRotate @"shouldNotRotate"
@protocol RestTimeViewControllerDelegate <NSObject>
@required
-(void) dataFromRestTimeMinViewController:(NSInteger) fullData
                        pickedMinuteValue:(NSInteger) minPick
                        pickedSecondValue:(NSInteger) secPick
                              pickedColor:(NSInteger) secColor;
@end
@interface RestTimeViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>
# define kMinutesComponent 0
# define kSecondsComponent 1

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightConstraint;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pickerHeightConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelRightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopConstraint;


- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)doneButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *customViewRestTime;

@property(retain,nonatomic) NSMutableArray *minutesArray;
@property(retain,nonatomic) NSMutableArray *secondsArray;


@property (assign,nonatomic) NSInteger fullValueSeconds;
@property (assign,nonatomic) NSInteger selectedRowinMin;
@property (assign,nonatomic) NSInteger selectedRowinSec;
@property (assign,nonatomic) NSInteger selectedColorIndex;



@property(weak,nonatomic) id<RestTimeViewControllerDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *restTimePicker;
@property (strong,nonatomic)  IBOutlet UIButton *doneButton;
@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;

@property (strong, nonatomic) IBOutlet UICollectionView *restTimeCollectionView;

@property (strong,nonatomic) NSString* selectedRestTimeColor;
@property (assign,nonatomic) NSInteger selectedRestTimeIndexInCollectionView;

#pragma mark - Nav bar image view
@property (strong, nonatomic) IBOutlet UIImageView *navBarImageView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelWidthConstraint;


@property (strong,nonatomic) NSString *type;

@end
