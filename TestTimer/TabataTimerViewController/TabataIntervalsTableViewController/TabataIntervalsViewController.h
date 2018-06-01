//
//  TabataIntervalsTableViewController.h
//  TestTimer
//
//  Created by a on 12/30/15.
//  Copyright © 2015 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"
#define shouldNotRotate @"shouldNotRotate"

@interface TabataIntervalsViewController : UIViewController
//- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)saveButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *dataFromTableView;


#pragma mark - Saved data from PrepareTimeViewController
@property (assign,nonatomic) NSInteger fullSecPrepare;
@property (assign,nonatomic) NSInteger selectedPrepareMinTimeValue;
@property (assign,nonatomic) NSInteger selectedPrepareSecTimeValue;
@property (assign,nonatomic) NSInteger selectedPrepareColorForCell;


#pragma mark - Saved values from WorkTimeViewController
@property (assign,nonatomic) NSInteger selectedSecondsFullValue;
@property (assign,nonatomic) NSInteger selectedPickedMinValue;
@property (assign,nonatomic) NSInteger selectedPickedSecValue;
@property (assign,nonatomic) NSInteger selectedWorkTimeColorForCell;


#pragma mark - Saved values from RestTimeViewController
@property (assign,nonatomic) NSInteger fullValueSecRV;
@property (assign,nonatomic) NSInteger selectedPickedMinValueR;
@property (assign,nonatomic) NSInteger selectedPickedSecValueR;
@property(assign,nonatomic) NSInteger selectedRestTimeColorForCell;


#pragma mark - Saved values from RoundsViewController
@property (assign,nonatomic) NSInteger fullRoundsValue;
@property (assign,nonatomic) NSInteger selectedPickedRoundsValue;
@property (assign,nonatomic) NSInteger selectedRoundsColorForCell;


#pragma mark - Saved values from CyclesViewController
@property (assign,nonatomic) NSInteger fullCyclesValue;
@property (assign,nonatomic) NSInteger  selectedPickedCyclesValue;
@property (assign,nonatomic) NSInteger selectedCyclesColorForCell;


#pragma mark - Saved values from RestbetweenCyclesViewController
@property (assign,nonatomic) NSInteger selectedPickedMinValueRestBetweenCycles;
@property (assign,nonatomic) NSInteger selectedPickedSecValueRestBetweenCycles;
@property (assign,nonatomic) NSInteger fullValueSecRestBetweenCycles;
@property (assign,nonatomic) NSInteger selectedRestBetweenCyclesTimeColorForCell;


#pragma mark - Custom save button with image
@property (strong,nonatomic)  IBOutlet UIButton *saveButton;


@property (strong, nonatomic) IBOutlet UIView *customUIView;

#pragma mark  - Custom UIBarButtonItems
@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewNavBar;


@property (nonatomic, retain) NSArray *tabataWorkout;


#pragma mark - Check mark index
@property (assign,nonatomic) NSInteger pickedIndex;


#pragma mark - Create a NSManagedObject for tabata workout

@property(strong) NSManagedObject *device;

#pragma mark - Create a mutable array

@property(strong,nonatomic) NSMutableArray *arrayWorkout;


#pragma mark - Create mutable array for selected index in core data

@property (nonatomic) NSMutableArray* selectedWorkOutIndex;

#pragma mark - Create NSManagedObjectContext
@property(strong)  NSIndexPath* lastIndexPath;
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
