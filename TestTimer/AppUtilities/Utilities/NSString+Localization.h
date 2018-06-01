//
//  NSString+Utils.h
//  Six Pack Abs
//
//  Created by Ivan on 9/22/16.
//  Copyright © 2016 Cibota Olga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Localization)

@property(strong, nonatomic, readonly, nonnull) NSString *localized;
-(NSString *_Nonnull)localizedFromTable:(NSString *_Nonnull)table;

@end
