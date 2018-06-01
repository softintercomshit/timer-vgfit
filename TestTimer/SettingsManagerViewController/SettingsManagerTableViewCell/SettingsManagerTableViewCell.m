//
//  SettingsManagerTableViewCell.m
//  TestTimer
//
//  Created by a on 3/23/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "SettingsManagerTableViewCell.h"

#define kSettingsTypeTitleArray @"Sound".localized, @"Sound scheme".localized, @"", @"Apple Health", @"Voice assist".localized, @"Vibration".localized, @"Flashlight".localized, @"Screen flash".localized, @"Ducking".localized, @"Rotation".localized, @"Time format".localized, @"Visual style".localized, nil

#define kSettingsTypeDescriptionArray @"", @"", @"", @"", @"", @"", @"Flashlight works only in foreground mode".localized, @"", @"Reduce music volume during alert".localized, @"Allow the screen to rotate during workout".localized,@"",@"", nil

@implementation SettingsManagerTableViewCell


-(void)awakeFromNib {
    [super awakeFromNib];
    self.visualStyleView.layer.cornerRadius = self.visualStyleView.frame.size.width / 2;
    [self sliderImages];
}

-(void)sliderImages {
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    [_volumeView setVolumeThumbImage:[UIImage imageNamed:@"btn_handle"] forState:UIControlStateNormal];
    [_volumeView setMaximumVolumeSliderImage:[UIImage imageNamed:@"slider_bot.png"] forState:UIControlStateNormal];
    [_volumeView setMinimumVolumeSliderImage:[UIImage imageNamed:@"slider_top.png"]  forState:UIControlStateNormal];
    //find the volumeSlider
    _volumeSlider= nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeSlider = (UISlider*)view;
            _volumeView.showsRouteButton=NO;
            break;
        }
    }
}

-(NSString *)cellSettingsTitle:(SettingsType)settingsType {
    return [[[NSArray alloc] initWithObjects: kSettingsTypeTitleArray] objectAtIndex:settingsType];
}

-(NSString *)cellDescriptionText:(SettingsType)settingsType {
     return [[[NSArray alloc] initWithObjects: kSettingsTypeDescriptionArray] objectAtIndex:settingsType];
}

-(void)setupCellSettings:(SettingsType)settingsType {
    switch (settingsType) {
        case Sound:
            self.titleLabel.hidden = true;
            self.detailLabel.hidden = true;
            self.settingsSwitch.hidden = false;
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        case SoundScheme:
            self.titleLabel.hidden = true;
            self.detailLabel.hidden = false;
            self.settingsSwitch.hidden = true;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case VolumeBar:
            self.titleLabel.hidden = true;
            self.detailLabel.hidden = true;
            self.settingsSwitch.hidden = true;
            self.volumeView.hidden = false;
            self.minVolumeImageView.hidden = false;
            self.maxVolumeImageView.hidden = false;
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        case AppleHealth:
            self.titleLabel.hidden = true;
            self.detailLabel.hidden = true;
            self.settingsSwitch.hidden = false;
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        case VoiceAssist:
            self.titleLabel.hidden = true;
            self.detailLabel.hidden = true;
            self.settingsSwitch.hidden = false;
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        case Vibration:
            self.titleLabel.hidden = true;
            self.detailLabel.hidden = true;
            self.settingsSwitch.hidden = false;
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        case Flashlight:
            self.titleLabel.hidden = true;
            self.descriptionLabel.hidden = false;
            self.detailLabel.hidden = true;
            self.settingsSwitch.hidden = false;
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        case Screenflash:
            self.titleLabel.hidden = true;
            self.detailLabel.hidden = true;
            self.settingsSwitch.hidden = false;
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        case Ducking:
            self.titleLabel.hidden = true;
            self.descriptionLabel.hidden = false;
            self.detailLabel.hidden = true;
            self.settingsSwitch.hidden = false;
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        case Rotation:
            self.titleLabel.hidden = true;
            self.descriptionLabel.hidden = false;
            self.detailLabel.hidden = true;
            self.settingsSwitch.hidden = false;
            self.accessoryType = UITableViewCellAccessoryNone;
            break;
        case TimeFormat:
            self.titleLabel.hidden = true;
            self.detailLabel.hidden = false;
            self.settingsSwitch.hidden = true;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case VisualStyle:
            self.titleLabel.hidden = true;
            self.detailLabel.hidden = false;
            self.settingsSwitch.hidden = true;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
}

-(void)setupSwitchStateSettings:(SettingsType)settingsType {
    switch (settingsType) {
        case Sound:
            [self.settingsSwitch setOn:[[SettingsManager sharedManager]sound]];
            break;
        case AppleHealth:
            [self.settingsSwitch setOn:[[SettingsManager sharedManager]healthKit]];
            break;
        case VoiceAssist:
            [self.settingsSwitch setOn:[[SettingsManager sharedManager]textSpeech]];
            break;
        case Vibration:
            [self.settingsSwitch setOn:[[SettingsManager sharedManager]vibro]];
            break;
        case Flashlight:
            [self.settingsSwitch setOn:[[SettingsManager sharedManager]flash]];
            break;
        case Screenflash:
            [self.settingsSwitch setOn:[[SettingsManager sharedManager]screenFlash]];
            break;
        case Ducking:
            [self.settingsSwitch setOn:[[SettingsManager sharedManager]ducking]];
            break;
        case Rotation:
            [self.settingsSwitch setOn:[[SettingsManager sharedManager]rotation]];
            break;
        default:
            break;
    }
}
 
-(void)setupTitlesAtIndex:(SettingsType)settingsType setSoundTitle:(NSString*)soundTitle setTimerFormat:(NSString*)timerFormat andVisualStyle:(NSString*)visualStyle {
    switch (settingsType) {
        case SoundScheme:
            self.detailLabel.text = soundTitle;
            break;
        case TimeFormat:
            self.detailLabel.text = timerFormat;
            break;
        case VisualStyle:
            self.detailLabel.text = visualStyle;
            break;
        default:
            break;
    }
}

-(void)setupVisualStyleAtIndex:(SettingsType)settingsType visualStyleColor:(UIColor*)color {
    if (settingsType == VisualStyle) {
        self.visualStyleView.hidden = false;
        self.visualStyleView.backgroundColor = color;
    }
}









@end
