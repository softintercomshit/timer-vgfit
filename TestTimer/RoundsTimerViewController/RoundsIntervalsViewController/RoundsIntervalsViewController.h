//
//  RoundsSettingsTableViewController.h
//  TestTimer
//
//  Created by a on 1/18/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"
#define shouldNotRotate @"shouldNotRotate"


@interface RoundsIntervalsViewController :UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *dataFromTableView;

@property (strong, nonatomic) IBOutlet UIView *customView;

#pragma mark - Saved ID for Core Data each entity
@property (assign,nonatomic) NSInteger roundsID;

#pragma mark - Saved data from PrepareTimeViewController

@property (assign,nonatomic) NSInteger dateFullSecPrepare;
@property (assign,nonatomic) NSInteger selectedPrepareTimeMinValue;
@property (assign,nonatomic) NSInteger selectedPrepareTimeSecValue;
@property (assign,nonatomic) NSInteger selectedColorCollectionViewCellIndex;


#pragma mark - Saved values from RoundTimeViewController
@property (assign,nonatomic) NSInteger selectedPickedMinValue;
@property (assign,nonatomic) NSInteger selectedPickedSecValue;
@property (assign,nonatomic) NSInteger fullValueSecRTVC;
@property (assign,nonatomic) NSInteger selectedColorCellIndexRoundsTime;

#pragma mark - Saved values from RestTimeViewController
@property (assign,nonatomic) NSInteger pickedRestMinValue;
@property (assign,nonatomic) NSInteger pickedRestSecValue;
@property (assign,nonatomic) NSInteger fullValueRestTimeValue;
@property (assign,nonatomic) NSInteger selectedColorCellIndexRestTime;


#pragma mark - Saved values from RoundsViewController

@property (assign,nonatomic) NSInteger roundsValue;
@property (assign,nonatomic) NSInteger selectedRoundValue;
@property (assign,nonatomic) NSInteger pickedColorForCell;

@property (strong,nonatomic)  IBOutlet UIButton *saveButton;
@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;

@property (strong, nonatomic) IBOutlet UIImageView *navBarImageView;

#pragma mark - Create an NSArray
@property (strong,nonatomic) NSArray *roundsWorkout;

#pragma mark - Create a NSManagedObject for rounds workout

@property(strong) NSManagedObject *device;

#pragma mark - Create a mutable array

@property(strong,nonatomic) NSMutableArray *arrayWorkout;

#pragma mark - Create NSInteger property for selectedColorCell



@end
