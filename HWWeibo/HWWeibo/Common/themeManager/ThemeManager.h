//
//  ThemeManager.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/21.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kThemeDidChangeNotification @"kThemeDidChangeNotification"
#define kThemeName @"kThemeName"

@interface ThemeManager : NSObject

@property (nonatomic, copy) NSString *themeName;
@property (nonatomic, strong) NSDictionary *themeConfig;
@property (nonatomic, strong) NSDictionary *colorConfig;

+ (instancetype)shareInstance;

- (UIImage *)getThemeImage:(NSString *)imageName;

- (UIColor *)getThemeColor:(NSString *)colorName;
@end
