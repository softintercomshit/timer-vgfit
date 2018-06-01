//
//  StopWatchIntervalsTableViewController.h
//  TestTimer
//
//  Created by a on 4/13/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"
#define shouldNotRotate @"shouldNotRotate"
#define shouldRotate @"shouldRotate"
@interface StopWatchIntervalsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UIImageView *imageViewNavBar;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong,nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITableView *dataIntervalsTableView;

#pragma mark - Saved data from PrepareTimeViewController
@property (assign,nonatomic) NSInteger fullSecondsPrepareTime;
@property (assign,nonatomic) NSInteger selectedPrepareTimeMinValue;
@property (assign,nonatomic) NSInteger selectedPrepareTimeSecValue;


#pragma mark - Saved data from SoundsEachViewController
@property (assign,nonatomic) NSInteger fullSecondsTimeLapSoundTime;
@property (assign,nonatomic) NSInteger selectedSoundEachTimeMinValue;
@property (assign,nonatomic) NSInteger selectedSoundEachTimeSecValue;
@property (strong, nonatomic) IBOutlet UIView *customView;

@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;
#pragma mark - Create an NSArray
@property (strong,nonatomic) NSArray *stopwatchWorkout;

#pragma mark - Create a NSManagedObject for rounds workout

@property(strong) NSManagedObject *device;

#pragma mark - Create a mutable array

@property(strong,nonatomic) NSMutableArray *arrayWorkout;
@end
