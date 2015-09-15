//
//  ThemeImageView.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/21.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

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

- (void)loadImageViewImage {
    ThemeManager *manager = [ThemeManager shareInstance];
   UIImage *image  = [manager getThemeImage:_imgName];
    image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapWidth];
    self.image = image;
}

- (void)themeDidChangeAction:(NSNotification *)notification {
    [self loadImageViewImage];
}

- (void)setImgName:(NSString *)imgName {
    if (![imgName isEqualToString:_imgName]) {
        _imgName = [imgName copy];
        [self loadImageViewImage];
    }
}

@end
