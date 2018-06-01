//
//  UpNextDataModel.h
//  TestTimer
//
//  Created by Andrei on 11/14/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpNextDataModel : NSObject


@property (strong, nonatomic) NSString *upNextString;
@property (strong, nonatomic) NSString *nextWorkType;

@property (strong, nonatomic) UIColor *textColor;

- (void)setTabataUpNextNames:(NSString*)nextWork andTabataCircleType:(TabataCircleType)circleType;

@end
