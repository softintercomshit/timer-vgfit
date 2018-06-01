//
//  AddNewTimerTabataTableViewController.h
//  TestTimer
//
//  Created by a on 3/21/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"
#define shouldNotRotate @"shouldNotRotate"

@interface AddNewTimerTabataViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *customUIView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

#pragma mark - Saved data from PrepareTimeViewController
@property (assign,nonatomic) NSInteger fullSecondsPrepare;
@property (assign,nonatomic) NSInteger selectedPrepareTimeMinute;
@property (assign,nonatomic) NSInteger selectedPrepareTimeSeconds;
@property (assign,nonatomic) NSInteger selectedPrepareTimeColorForCell;

#pragma mark - Saved values from WorkTimeViewController

@property (assign,nonatomic) NSInteger selectedWorkFullSecondsValue;
@property (assign,nonatomic) NSInteger selectedWorkMinValue;
@property (assign,nonatomic) NSInteger selectedWorkSecValue;
@property (assign,nonatomic) NSInteger selectedWorkTimeColorForCell;

#pragma mark - Saved values from RestTimeViewController
@property (assign,nonatomic) NSInteger fullSecondsRestTime;
@property (assign,nonatomic) NSInteger selectedRestMinValue;
@property  (assign,nonatomic)NSInteger selectedRestSecValue;
@property (assign,nonatomic) NSInteger selectedRestTimeColorForCell;

#pragma mark - Saved values from RoundsViewController

@property (assign,nonatomic) NSInteger roundsFullValue;
@property (assign,nonatomic) NSInteger selectedRoundsValue;

#pragma mark - Saved values from CyclesViewController

@property (assign,nonatomic) NSInteger cyclesFullValue;
@property (assign,nonatomic) NSInteger selectedCyclesValue;


#pragma mark - Saved values from RestbetweenCyclesViewController

@property (assign,nonatomic) NSInteger selectedRestBetweenCyclesMinValue;
@property (assign,nonatomic) NSInteger selectedRestBetweenCyclesSecValue;
@property (assign,nonatomic) NSInteger fullSecondsRestBetweenCycles;
@property (assign,nonatomic) NSInteger selectedRestBetweenCyclesTimeColorForCell;


@property(strong,nonatomic)IBOutlet UIButton *saveButton;
@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;

#pragma mark  - Nav bar image view
@property (strong, nonatomic) IBOutlet UIImageView *navBarImageView;

#pragma mark - Table view outlet
@property (strong, nonatomic) IBOutlet UITableView *dataTableView;



@property (strong, nonatomic) NSMutableDictionary *customTimerDict ;

#pragma  mark - Text field NSString property
@property (strong,nonatomic) NSString* inputTitleWorkoutTabata;

@property (strong,nonatomic) IBOutlet UIButton *textFieldButton;



@property (strong,nonatomic) NSString *type;

#pragma mark- Text field declaration

@property (strong, nonatomic) IBOutlet UITextField *workoutNameTextField;

@property (strong, nonatomic) IBOutlet UIView *uiViewForTextField;

@property (strong, nonatomic) IBOutlet UIScrollView *uiScrollView;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (nonatomic, assign) BOOL isEditingTimer;
@property(strong) NSManagedObject *managedObject;

@end
