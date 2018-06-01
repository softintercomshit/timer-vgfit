//
//  PrepareTimeViewController.h
//  TestTimer
//
//  Created by a on 3/18/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#define shouldNotRotate @"shouldNotRotate"
@protocol PrepareTimeViewControllerDelegate <NSObject>
@required
-(void) dataFromPrepareTimeViewController:(NSInteger) data
                pickedPrepareTimeMinValue:(NSInteger) minPick
                   pickedPrepareTimeSecValue:(NSInteger) secPick
            pickedColorCollectionViewCell:(NSInteger) pickedColor;
@end
@interface PrepareTimeViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

#define kPrepareTimeMinComponent 0
#define kPrepareTimeSecComponent 1
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelWidthConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pickerHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightContraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelLeftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelRightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelTopConstraint;

@property(strong,nonatomic) NSString *prepareTimeStr;
@property (strong,nonatomic) NSString *selectedColor;
@property (strong,nonatomic) NSString *type;


@property (assign,nonatomic) NSInteger selectedRowMinForPrepare;
@property (assign,nonatomic) NSInteger selectedRowSecForPrepare;
@property (assign,nonatomic) NSInteger fullValuePrepareTimeSeconds;
@property (assign,nonatomic) NSInteger selectedIndexInCollectionView;


@property (strong, nonatomic) IBOutlet UIPickerView *prepareTimePicker;
@property (strong,nonatomic)  IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIView *customViewForPrepareTime;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,retain)IBOutlet UIImageView *imgCheckMark;


@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;



@property(weak,nonatomic) id<PrepareTimeViewControllerDelegate>delegate;

#pragma mark - Nav bar image view
@property (strong, nonatomic) IBOutlet UIImageView *navBarImageView;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *minLabelWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secLabelWidthConstraint;

@end
