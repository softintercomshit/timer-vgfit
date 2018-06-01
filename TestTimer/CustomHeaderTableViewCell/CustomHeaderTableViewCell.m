//
//  CustomHeaderTableViewCell.m
//  TestTimer
//
//  Created by a on 3/22/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "CustomHeaderTableViewCell.h"

@implementation CustomHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

       _addNewTimerButton.layer.cornerRadius = 7;
        [_editButton.layer setCornerRadius:5.0];
    [_editButton adjustButtonTitle];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
