//
//  ThemeLabel.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/21.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeAction) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeAction) name:kThemeDidChangeNotification object:nil];
}

- (void)setColorName:(NSString *)colorName {
    if (![colorName isEqualToString:_colorName]) {
        _colorName = [colorName copy];
        [self themeDidChangeAction];
    }
}

- (void)themeDidChangeAction {
    
    ThemeManager *manager = [ThemeManager shareInstance];
    self.textColor = [manager getThemeColor:_colorName];
    
}

@end
