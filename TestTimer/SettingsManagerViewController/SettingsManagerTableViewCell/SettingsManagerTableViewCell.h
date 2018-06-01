//
//  SettingsManagerTableViewCell.h
//  TestTimer
//
//  Created by a on 3/23/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface SettingsManagerTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet MPVolumeView *volumeView;
@property (strong, nonatomic) IBOutlet UIImageView *minVolumeImageView;
@property (strong, nonatomic) IBOutlet UIImageView *maxVolumeImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UISlider *soundVolumeSlider;
@property (strong, nonatomic) IBOutlet UISwitch *settingsSwitch;

@property (strong, nonatomic) IBOutlet UILabel *titleLabelCentered;

@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;
@property (strong, nonatomic) IBOutlet UIView *visualStyleView;

@property (nonatomic) SettingsType settingsType;

-(NSString*)cellSettingsTitle:(SettingsType)settingsType;

-(NSString*)cellDescriptionText:(SettingsType)settingsType;

-(void)setupCellSettings:(SettingsType)settingsType;

-(void)setupSwitchStateSettings:(SettingsType)settingsType;

-(void)setupTitlesAtIndex:(SettingsType)settingsType setSoundTitle:(NSString*)soundTitle setTimerFormat:(NSString*)timerFormat andVisualStyle:(NSString*)visualStyle;

-(void)setupVisualStyleAtIndex:(SettingsType)settingsType visualStyleColor:(UIColor*)color;


@end
