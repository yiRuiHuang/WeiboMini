//
//  ThemeManager.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/21.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "ThemeManager.h"
#define kDefaultThemeName @"Cat"

@implementation ThemeManager
// 单例
+ (ThemeManager *)shareInstance {
    static ThemeManager *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[[self class] alloc] init];
    });

    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        // 默认主题
        _themeName = kDefaultThemeName;
        
        NSString *saveThemeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
        if (saveThemeName.length > 0) {
            _themeName = saveThemeName;
        }
        
        // 将全部主题名存在字典中（从plist文件中获取字典，便于扩展）
        NSString *path = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        self.themeConfig = [NSDictionary dictionaryWithContentsOfFile:path];
        
        
        NSString *themePath = [self themePath];
        NSString *colorPath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:colorPath];
        
    }
    return self;
}

// 主题改变，需要立即发送主题改变的通知
- (void)setThemeName:(NSString *)themeName {
    if (![_themeName isEqualToString:themeName]) {
        _themeName = [themeName copy];
        
        // 把当前主题保存到本地plist，下次打开不变
        [[NSUserDefaults standardUserDefaults] setObject:_themeName forKey:kThemeName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 主题改变了，也要改变字体的设置
        NSString *themePath = [self themePath];
        NSString *colorPath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:colorPath];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:nil];
    }
}

// 返回一个完整的主题的全路径
- (NSString *)themePath {
    
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    
    NSString *themePath = [self.themeConfig objectForKey:_themeName];
    
   return [bundlePath stringByAppendingPathComponent:themePath];

}

/**
 *  Description ： 返回一个图片（与选择的主题有关）
 *
 *  @param imageName 图片名称，只是名称而已不是路径
 *
 *  @return 图片
 */
- (UIImage *)getThemeImage:(NSString *)imageName {
    if (imageName.length == 0) {
        return nil;
    }
    
    NSString *themePath = [self themePath];
    
    NSString *imagePath = [themePath stringByAppendingPathComponent:imageName];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

- (UIColor *)getThemeColor:(NSString *)colorName {
    if (colorName == 0) {
        return nil;
    }
    
    NSDictionary *rgbDic = [_colorConfig objectForKey:colorName];
    CGFloat r = [[rgbDic objectForKey:@"R"] floatValue];
    CGFloat g = [[rgbDic objectForKey:@"G"] floatValue];
    CGFloat b = [[rgbDic objectForKey:@"B"] floatValue];
    CGFloat alpha = [[rgbDic objectForKey:@"alpha"] floatValue];
    if (rgbDic[@"alpha"] == nil) {
        alpha = 1;
    }
    
    UIColor *color = [UIColor colorWithRed:r/225.0 green:g/255.0 blue:b/255.0 alpha:alpha];
    return color;
    
}

@end
