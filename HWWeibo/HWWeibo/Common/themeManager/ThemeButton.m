//
//  ThemeButton.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/21.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeAction:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeAction:) name:kThemeDidChangeNotification object:nil];
}



- (void)themeDidChangeAction:(NSNotification *)notification {
    
    [self loadImage];
}

- (void)setNormalImgName:(NSString *)normalImgName {
    if (![_normalImgName isEqualToString:normalImgName]) {
        _normalImgName = [normalImgName copy];
        [self loadImage];
    }
}

- (void)setHighLightImgName:(NSString *)highLightImgName {
    if (![highLightImgName isEqualToString:_highLightImgName]) {
        _highLightImgName = [highLightImgName copy];
        [self loadImage];
    }
}

- (void)setNormalBgImgName:(NSString *)normalBgImgName {
    if (![normalBgImgName isEqualToString:_normalBgImgName]) {
        _normalBgImgName = [normalBgImgName copy];
        [self loadImage];
    }
}

- (void)setHighLightBgImgName:(NSString *)highLightBgImgName {
    if (![highLightBgImgName isEqualToString:_highLightBgImgName]) {
        _highLightBgImgName = [highLightBgImgName copy];
        [self loadImage];
    }
}

- (void)loadImage {
    
    ThemeManager *manager = [ThemeManager shareInstance];

    UIImage *image = [manager getThemeImage:_normalImgName];
    if (image != nil) {
        [self setImage:image forState:UIControlStateNormal];
    }
    UIImage *highLightImage = [manager getThemeImage:_highLightImgName];
    if (highLightImage != nil) {
        [self setImage:highLightImage forState:UIControlStateHighlighted];
    }
    
    UIImage *bgNormalImage = [manager getThemeImage:_normalBgImgName];
    UIImage *bgHighLightImage = [manager getThemeImage:_highLightBgImgName];
    if (bgNormalImage != nil) {
        [self setBackgroundImage:bgNormalImage forState:UIControlStateNormal];
    }
    if (bgHighLightImage != nil) {
        [self setBackgroundImage:bgHighLightImage forState:UIControlStateHighlighted];
    }
    
}



@end
