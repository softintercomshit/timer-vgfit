//
//  AddNewTimerRoundsTableViewController.h
//  TestTimer
//
//  Created by a on 3/21/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"
#define shouldNotRotate @"shouldNotRotate"
@interface AddNewTimerRoundsViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

#pragma mark - Saved data from PrepareTimeViewController
@property (assign,nonatomic) NSInteger fullSecondsPrepare;
@property (assign,nonatomic) NSInteger pickedMinutesPrepare;
@property (assign,nonatomic) NSInteger pickedSecondsPrepare;
@property (assign,nonatomic)  NSInteger pickedColorCellIndex;

#pragma mark - Saved values from RoundTimeViewController

@property (assign,nonatomic) NSInteger fullSecWorkTime;
@property (assign,nonatomic) NSInteger pickedWorkTimeMinAmount;
@property (assign,nonatomic) NSInteger pickedWorkTimeSecAmount;

#pragma mark - Saved values from RoundTimeViewController

@property (assign,nonatomic) NSInteger fullSecRestTime;
@property (assign,nonatomic) NSInteger pickedRestTimeMinAmount;
@property (assign,nonatomic) NSInteger pickedRestTimeSecAmount;



#pragma mark - Saved values from RoundsViewController

@property (assign,nonatomic) NSInteger roundsAmount;
@property (assign,nonatomic) NSInteger pickedRoundAmount;

@property (strong, nonatomic) IBOutlet UIView *navBarView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)IBOutlet UIButton *saveButton;
@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;

@property (strong, nonatomic) IBOutlet UITableView *dataFromTableView;
@property (strong, nonatomic) IBOutlet UIImageView *navBarImageView;


@property (strong,nonatomic) NSMutableDictionary *customRoundsNewTimerDict;

@property (strong,nonatomic) NSString *inputRoundsTitle;

@property (strong,nonatomic) NSString *type;

@property (strong, nonatomic) IBOutlet UITextField *workoutNameTextField;
@property (strong, nonatomic) IBOutlet UIView *uiViewForTextField;

//@property (strong, nonatomic) IBOutlet UIScrollView *uiScrollView;


@property(strong) NSManagedObject *managedObject;
@property (nonatomic, assign) BOOL isEditingTimer;

@property (strong, nonatomic) IBOutlet UILabel *labelName;

@end
