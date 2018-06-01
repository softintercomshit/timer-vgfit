//
//  CustomWorkoutTableViewCell.h
//  TestTimer
//
//  Created by user on 10/31/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundsWorkouts.h"

@interface CustomWorkoutTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *workoutTitle;
@property (strong, nonatomic) IBOutlet UILabel *firstLeftTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondLeftTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdLeftTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstLeftTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondLeftTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdLeftTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstRightTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondRightTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdRightTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstRightTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondRightTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdRightTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *checkMarkImageView;

-(void)setRoundsTimerWorkoutValuesInTableViewCell:(NSArray*)workoutArray
                                         andTitle:(NSString*)workoutName;

-(void)setStopwatchTimerWorkoutValuesInTableViewCell:(NSArray*)workoutArray
                                         andTitle:(NSString*)workoutName;

-(void)setTabataTimerWorkoutValuesInTableViewCell:(NSArray*)workoutArray
                                         andTitle:(NSString*)workoutName;
@end
