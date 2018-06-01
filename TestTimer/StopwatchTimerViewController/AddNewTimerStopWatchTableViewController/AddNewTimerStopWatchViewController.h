//
//  AddNewTimerStopWatchTableViewController.h
//  TestTimer
//
//  Created by a on 3/21/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"
#define shouldNotRotate @"shouldNotRotate"
@interface AddNewTimerStopWatchViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *customView;

#pragma mark - Saved data from PrepareTimeViewController
@property (assign,nonatomic) NSInteger fullSecondsPrepareTime;
@property (assign,nonatomic) NSInteger minPrepareTime;
@property (assign,nonatomic) NSInteger secPrepareTime;
//@property NSInteger choosenPrepareTimeAmount;


#pragma mark - Saved data from SoundsEachViewController
@property (assign,nonatomic) NSInteger secondsSoundTime;
@property (assign,nonatomic) NSInteger choosenSoundEachTimeMinAmount;
@property (assign,nonatomic) NSInteger choosenSoundEachTimeSecAmount;
@property (strong,nonatomic) NSString *type;
@property (strong, nonatomic) IBOutlet UITableView *dataIntervalsTableView;

@property (strong, nonatomic) IBOutlet UIImageView *navBarImageView;

@property(strong,nonatomic)IBOutlet UIButton *saveButton;
@property (strong,nonatomic) UIBarButtonItem *customRightBarButtonItem;
@property (strong,nonatomic) UIBarButtonItem *leftBarButtonItem;

@property (strong, nonatomic) IBOutlet UIView *uiViewForTextField;
@property (strong, nonatomic) NSString *inputTitleStopwatchWorkout;

@property (strong, nonatomic) IBOutlet UITextField *addWorkoutTextfield;
@property (strong, nonatomic) IBOutlet UILabel *labelName;


@property(strong) NSManagedObject *managedObject;
@property (nonatomic, assign) BOOL isEditingTimer;

@property (strong,nonatomic) NSMutableDictionary *customStopwatchNewTimerDict;

@end
