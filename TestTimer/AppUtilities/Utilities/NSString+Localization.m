//
//  NSString+Utils.m
//  Six Pack Abs
//
//  Created by Ivan on 9/22/16.
//  Copyright © 2016 Cibota Olga. All rights reserved.
//

#import "NSString+Localization.h"

static NSMutableDictionary<NSString*, NSDictionary<NSString*, NSDictionary<NSString*, NSString*>*>*> *dictWithLanguages;
static NSString *currentTable;
static NSMutableArray<NSString *> *allLanguages;

@implementation NSString (Localization)

+(void)load{
#if TARGET_IPHONE_SIMULATOR
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundlePath = [NSBundle mainBundle].resourcePath;
        NSArray<NSString *> *dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bundlePath error:nil];
        dictWithLanguages = [NSMutableDictionary dictionary];
        allLanguages = [NSMutableArray array];
        
        [dirs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj containsString:@"lproj"]) {
                NSString *languageName = [obj stringByReplacingOccurrencesOfString:@".lproj" withString:@""];
                [allLanguages addObject:languageName];
                NSString *languageFolder = [bundlePath stringByAppendingPathComponent:obj];
                NSArray<NSString *> *langDir = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:languageFolder error:nil];
                
                [langDir enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj containsString:@"strings"]) {
                        NSString *tableName = [obj stringByReplacingOccurrencesOfString:@".strings" withString:@""];
                        NSString *tablePath = [languageFolder stringByAppendingPathComponent:obj];
                        NSDictionary *languageDict = [NSDictionary dictionaryWithContentsOfFile:tablePath];
                        if (languageDict.count > 0) {
                            NSMutableDictionary *tableDict = [dictWithLanguages[tableName] mutableCopy];
                            if (!tableDict) {
                                tableDict = [NSMutableDictionary dictionary];
                            }
                            [tableDict setObject:languageDict forKey:languageName];
                            [dictWithLanguages setObject:tableDict forKey:tableName];
                        }
                    }
                }];
            }
        }];
    });
#else
    
#endif
}

-(NSString *)localizedFromTable:(NSString *)table{
    currentTable = table;
#if TARGET_IPHONE_SIMULATOR
    NSDictionary *tableDict = dictWithLanguages[table];
    [allLanguages enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!tableDict[obj][self]) {
            [self saveKeyForLanguage:obj];
        }else{
            [self removeKeyFromDict:obj];
        }
    }];
#else
    
#endif
    return NSLocalizedStringFromTable(self, table, nil);
}

-(NSString *)localized{
    currentTable = @"Localizable";
#if TARGET_IPHONE_SIMULATOR
    NSDictionary *tableDict = dictWithLanguages[currentTable];
    [allLanguages enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!tableDict[obj][self]) {
            [self saveKeyForLanguage:obj];
        }else{
            [self removeKeyFromDict:obj];
        }
    }];
#else
    
#endif
    return NSLocalizedString(self, nil);
}

-(void)saveKeyForLanguage:(NSString *)lang{
    NSMutableDictionary *stringsDict = [self stringsDict].mutableCopy;
    
    NSString *dictValue = stringsDict[self];
    if (!dictValue) {
        dictValue = lang;
    }else{
        if (![dictValue containsString:lang]) {
            dictValue = [dictValue stringByAppendingString:[NSString stringWithFormat:@", %@", lang]];
        }
    }
    
    stringsDict[self] = dictValue;
    [self writeDictToStringsFile:stringsDict dictValue:dictValue];
}

-(void)removeKeyFromDict:(NSString *)lang{
    NSMutableDictionary *stringsDict = [self stringsDict].mutableCopy;
    
    NSString *dictValue = stringsDict[self];
    if (!dictValue) {return;}
    
    NSMutableArray *allLanguages = [dictValue componentsSeparatedByString:@", "].mutableCopy;
    if (![allLanguages containsObject:lang]) {return;}
    
    for (NSString *language in allLanguages) {
        if ([language containsString:lang]) {
            [allLanguages removeObject:language];
            break;
        }
    }
    
    if (allLanguages.count > 0) {
        dictValue = [allLanguages componentsJoinedByString:@", "];
    }else{
        [stringsDict removeObjectForKey:self];
    }
    [self writeDictToStringsFile:stringsDict dictValue:dictValue];
}

-(NSString *)desktopPath{
    NSString *theDesktopPath = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES )[0];
    NSArray<NSString*> *array = [theDesktopPath componentsSeparatedByString:@"/"];
    NSString *realDesktopPath = [NSString stringWithFormat:@"/%@/%@/%@", array[1], array[2], array.lastObject];
    return realDesktopPath;
}

-(NSString *)appFolderPath{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleNameKey];
    appName = [appName stringByAppendingString:@" localizations"];
    NSString *appFolderPath = [[self desktopPath] stringByAppendingPathComponent:appName];
    [[NSFileManager defaultManager] createDirectoryAtPath:appFolderPath withIntermediateDirectories:false attributes:nil error:nil];
    return appFolderPath;
}

-(NSString *)stringsPath{
    return [[self appFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.strings", currentTable]];
}

-(NSDictionary *)stringsDict{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[self stringsPath]];
    if (!dict) {
        dict = [NSDictionary dictionary];
    }
    return dict;
}

-(void)writeDictToStringsFile:(NSDictionary *)stringsDict dictValue:(NSString *)dictValue{
    NSString *finalString = @"";
    for (NSString *key in stringsDict) {
        if ([key isEqualToString:self]) {
            finalString = [finalString stringByAppendingString:[NSString stringWithFormat:@"\"%@\" = \"%@\";\n\n", self, dictValue]];
        }else{
            finalString = [finalString stringByAppendingString:[NSString stringWithFormat:@"\"%@\" = \"%@\";\n\n", key, stringsDict[key]]];
        }
    }
    
    [finalString writeToFile:[self stringsPath] atomically:true encoding:NSUTF8StringEncoding error:nil];
}
@end
