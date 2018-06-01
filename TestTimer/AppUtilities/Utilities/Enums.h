//
//  Enums.h
//  TestTimer
//
//  Created by Andrei on 11/8/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Enums_h
#define Enums_h

typedef NS_ENUM(NSInteger, TimerFormats){
    MinSec = 0,
    MilisecondsOneDigit,
    MilisecondsTwoDigits
};

typedef NS_ENUM(NSInteger, TabataCircleType)
{
    Prepare,
    Work,
    Rest,
    RestBetweenCycles
};

typedef NS_ENUM(NSInteger, RoundsCircleType)
{
    RoundsPrepare = 0,
    RoundsWork,
    RoundsRest
};

typedef NS_ENUM(NSInteger, StopwatchCircleType)
{
    StopwatchPrepare = 0,
    StopwatchTimeLap
};

typedef NS_ENUM(NSInteger, IndexName)
{
    PrepareIndex = 0,
    WorkIndex,
    RestIndex,
    RoundsIndex,
    CyrclesIndex,
    RestBetweenCyrclesIndex
};


typedef NS_ENUM(NSInteger, RoundsIndexName)
{
    RoundsPrepareIndex = 0,
    RoundsWorkIndex,
    RoundsRestIndex,
    RoundsIndexCountIndex
};

typedef NS_ENUM(NSInteger, StopwatchIndexName)
{
    StopwatchPrepareIndex = 0,
    StopwatchTimeLapIndex
};

typedef NS_ENUM(NSInteger, PlayButtonTagName)
{
    PlayButtonPortrait = 0,
    PlayButtonLandscape = 1
};

typedef NS_ENUM(NSInteger, ResetButtonTagName)
{
    ResetButtonPotrait = 0,
    ResetButtonLandscape = 1
};

typedef NS_ENUM(NSInteger, SongNames)
{
    AirHorn,
    Beep,
    BoxingBell,
    Buzzer,
    Censor,
    ChineseGong,
    Ding,
    DoubleDing,
    MetalDing,
    Punch,
    RefereeWhistle,
    SirenHorn,
    SportsWhistle,
    Tone
};

typedef NS_ENUM(NSInteger, SettingsType)
{
    Sound,
    SoundScheme,
    VolumeBar,
    AppleHealth,
    VoiceAssist,
    Vibration,
    Flashlight,
    Screenflash,
    Ducking,
    Rotation,
    TimeFormat,
    VisualStyle
};



#endif /* Enums_h */
