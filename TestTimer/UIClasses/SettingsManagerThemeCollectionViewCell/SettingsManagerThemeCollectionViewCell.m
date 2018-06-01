//
//  SettingsManagerThemeCollectionViewCell.m
//  TestTimer
//
//  Created by a on 4/11/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "SettingsManagerThemeCollectionViewCell.h"

@implementation SettingsManagerThemeCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _checkMarkImageView.image = [UIImage imageNamed:@"check_yes.png"];
}

@end
