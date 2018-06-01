//
//  ColorSchemeCustomCel.m
//  TestTimer
//
//  Created by a on 2/12/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "ColorSchemeCustomCell.h"

@implementation ColorSchemeCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.themeColorView.layer.cornerRadius=self.themeColorView.frame.size.width / 2;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
