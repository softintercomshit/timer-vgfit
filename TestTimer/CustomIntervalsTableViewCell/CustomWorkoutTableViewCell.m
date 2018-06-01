//
//  CustomWorkoutTableViewCell.m
//  TestTimer
//
//  Created by user on 10/31/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "CustomWorkoutTableViewCell.h"

@implementation CustomWorkoutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
//    if (editing)
//    {
//           [self hideCheckMark];
//        self.trailingConstraintCheckMarkImageView.constant = -28;
//    }
//    else
//    {
//        [self showCheckMark];
//        self.trailingConstraintCheckMarkImageView.constant = 20;
//    }
}

- (void)showCheckMark {
    
    [UIView animateWithDuration:0.1f
                     animations:^{
                         
                         [self.checkMarkImageView setHidden:false];
                         
                     } completion:nil];
}

- (void)hideCheckMark {
    
    [UIView animateWithDuration:0.1f
                     animations:^{
                         
                         [self.checkMarkImageView setHidden:true];
                         
                     } completion:nil];
}


-(void)setRoundsTimerWorkoutValuesInTableViewCell:(NSArray*)workoutArray andTitle:(NSString*)workoutName{
    
        self.firstLeftTitleLabel.text = @"Prepare".localized;
        self.firstLeftTimeLabel.text = [NSString stringWithFormat:@"%@",workoutArray[0]];
        self.secondLeftTitleLabel.text = @"Work".localized;
        self.secondLeftTimeLabel.text = [NSString stringWithFormat:@"%@",workoutArray[1]];
        self.firstRightTitleLabel.text = @"Rest".localized;
        self.firstRightTimeLabel.text = [NSString stringWithFormat:@"%@",workoutArray[2]];
        self.secondRightTitleLabel.text = @"Rounds".localized;
        self.secondRightTimeLabel.text = [NSString stringWithFormat:@"%@",workoutArray[3]];
        self.thirdLeftTimeLabel.hidden = YES;
        self.thirdLeftTitleLabel.hidden = YES;
        self.thirdRightTimeLabel.hidden = YES;
        self.thirdRightTitleLabel.hidden = YES;
        self.workoutTitle.text =[NSString stringWithFormat:@"%@",workoutName];
}
-(void)setStopwatchTimerWorkoutValuesInTableViewCell:(NSArray *)workoutArray andTitle:(NSString *)workoutName{
    
    self.firstLeftTitleLabel.text = @"Prepare".localized;
    self.firstLeftTimeLabel.text = [NSString stringWithFormat:@"%@",workoutArray[0]];
    self.secondLeftTitleLabel.hidden = YES;
    self.secondLeftTimeLabel.hidden = YES;
    self.firstRightTitleLabel.text = @"Time lap".localized;
    self.firstRightTimeLabel.text = [NSString stringWithFormat:@"%@",workoutArray[1]];
    self.secondRightTitleLabel.hidden = YES;
    self.secondRightTimeLabel.hidden = YES;
    self.thirdLeftTimeLabel.hidden = YES;
    self.thirdLeftTitleLabel.hidden = YES;
    self.thirdRightTimeLabel.hidden = YES;
    self.thirdRightTitleLabel.hidden = YES;
    self.workoutTitle.text =[NSString stringWithFormat:@"%@",workoutName];
    
}
-(void)setTabataTimerWorkoutValuesInTableViewCell:(NSArray *)workoutArray andTitle:(NSString *)workoutName{
    
    self.firstLeftTitleLabel.text = @"Prepare".localized;
    self.firstLeftTimeLabel.text = [NSString stringWithFormat:@"%@",workoutArray[0]];
    self.secondLeftTitleLabel.text = @"Work".localized;
    self.secondLeftTimeLabel.text = [NSString stringWithFormat:@"%@",workoutArray[1]];
    self.thirdLeftTitleLabel.text = @"Rest".localized;
    self.thirdLeftTimeLabel.text =  [NSString stringWithFormat:@"%@",workoutArray[2]];
    self.firstRightTitleLabel.text = @"Rounds".localized;
    self.firstRightTimeLabel.text = [NSString stringWithFormat:@"%@",workoutArray[3]];
    self.secondRightTitleLabel.text = @"Cycles".localized;
    self.secondRightTimeLabel.text = [NSString stringWithFormat:@"%@",workoutArray[4]];
    self.thirdRightTitleLabel.text = @"Rest BC".localized;
    self.thirdRightTimeLabel.text = [NSString stringWithFormat:@"%@",workoutArray[5]];
    self.workoutTitle.text =[NSString stringWithFormat:@"%@",workoutName];
    
}
@end
