//
//  CyclesViewController.h
//  TestTimer
//
//  Created by a on 3/18/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#define shouldNotRotate @"shouldNotRotate"
@protocol CyclesViewControllerDelegate <NSObject>
@required
-(void) dataFromCyclesViewController:(NSInteger)
              data pickedCyclesValue:(NSInteger) cyclesPick
       pickedColorCollectionViewCell:(NSInteger) pickedColor;
@end
@interface CyclesViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

#define kCyclesComponent 0


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pickerHeightConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopConstraint;

@property (retain,nonatomic) NSMutableArray *cyclesArray;
@property (assign,nonatomic) NSInteger cycles;
@property (assign,nonatomic) NSInteger selectedRowForCycles;

@property (strong, nonatomic) IBOutlet UIPickerView *cyclesPicker;

@property (weak,nonatomic) id<CyclesViewControllerDelegate>delegate;

@property (strong,nonatomic)  IBOutlet UIButton *doneButton;

@property (strong, nonatomic) IBOutlet UIView *customViewCycles;
@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;

#pragma mark - Custom UIView 

@property (strong, nonatomic) IBOutlet UIView *cyclesUIView;

#pragma mark - Custom UIImageView

@property (strong, nonatomic) IBOutlet UIImageView *navBarImageView;

@property (strong, nonatomic) IBOutlet UICollectionView *cyclesCollectionViewColors;


@property (assign,nonatomic) NSInteger pickedRecordInCollectionView;

@property (strong,nonatomic) NSString *type;

@end
