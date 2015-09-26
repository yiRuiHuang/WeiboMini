//
//  MoreTableViewCell.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/21.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "MoreTableViewCell.h"
#import "ThemeManager.h"

@implementation MoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self themeDidChangeAction];
//    self.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeAction) name:kThemeDidChangeNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModal:(MoreModal *)modal {
    _modal = modal;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _contentLabel.text = _modal.labelContent;
    _contentLabel.colorName = @"More_Item_Text_color";
    _contentLabel.font = [UIFont boldSystemFontOfSize:16.0];
    _contentLabel.backgroundColor = [UIColor clearColor];
    
    _themeLabel.colorName = @"More_Item_Text_color";
    _themeLabel.font = [UIFont boldSystemFontOfSize:16.0];
    _themeLabel.backgroundColor = [UIColor clearColor];

    
    _iconImageView.imgName = _modal.iconName;
    _iconImageView.backgroundColor = [UIColor clearColor];
}

- (void)themeDidChangeAction {
    [self setNeedsLayout];
//    更多页面  cell背景颜色
    self.backgroundColor = [[ThemeManager shareInstance] getThemeColor:@"More_Item_color"];
}

@end
