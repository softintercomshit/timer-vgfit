//
//  RoundsViewController.h
//  TestTimer
//
//  Created by a on 12/30/15.
//  Copyright © 2015 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#define shouldNotRotate @"shouldNotRotate"
@protocol RoundsViewControllerDelegate <NSObject>
@required
-(void) dataFromRoundsViewController:(NSInteger) data
                   pickedRoundsValue:(NSInteger) roundsPick
       pickedColorCollectionViewCell:(NSInteger) pickedColor;

//@optional
//-(void) dataFromRoundsViewControllerForRounds:(NSString *)dataRounds pickedRoundsValueForRounds:(NSInteger)roundsPicked;
@end
@interface RoundsViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

#define kRoundsComponent 0

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pickerHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopConstraint;

@property (strong, nonatomic) IBOutlet UIPickerView *roundsPicker;

@property(retain,nonatomic) NSMutableArray *roundsArray;


@property(assign,nonatomic) NSInteger rounds;
@property(assign,nonatomic) NSInteger selectedRowForRounds;



@property(weak,nonatomic) id<RoundsViewControllerDelegate>delegate;
@property (strong,nonatomic)  IBOutlet UIButton *doneButton;

@property (strong, nonatomic) IBOutlet UIView *customViewRoundsView;
@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;


#pragma mark - Custom UI navbar imageView

@property (strong, nonatomic) IBOutlet UIImageView *navBarImageView;

@property (strong, nonatomic) IBOutlet UICollectionView *roundsCollectionViewColors;

@property (assign,nonatomic) NSInteger selectedRecordInCollectionView;

@property (strong,nonatomic) NSString *type;


@end
