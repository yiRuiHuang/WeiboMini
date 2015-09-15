//
//  CommentTableViewCell.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/28.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "UIImageView+WebCache.h"
#import "UserMoal.h"
#import "UIViewExt.h"
#import "ThemeLabel.h"
#import "ThemeManager.h"


@implementation CommentTableViewCell 

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    _commentContentLabel.linespace = 5;
    _commentContentLabel.wxLabelDelegate = self;
}

- (void)setModel:(CommentModel *)model {
    if (_model != model) {
        _model = model;
        [self setNeedsLayout];
    }
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    
    //用户头像地址，50×50像素
    NSString *profileImageStr = _model.userMoal.profile_image_url;
    _profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_profileImageView sd_setImageWithURL:[NSURL URLWithString:profileImageStr]];
    
    //用户昵称
    _screenName.text = _model.userMoal.screen_name;
    _screenName.font = [UIFont boldSystemFontOfSize:14];
    _screenName.colorName = @"Timeline_Name_color";
    
    // 评论内容
    _commentContentLabel.text = _model.text;
    _commentContentLabel.numberOfLines = 0;
    _commentContentLabel.font = [UIFont systemFontOfSize:14];

    
}

//返回一个正则表达式，通过此正则表达式查找出需要添加超链接的文本
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    //需要添加连接的字符串的正则表达式：@用户、http://... 、 #话题#
    NSString *regex1 = @"@\\w+"; //@"@[_$]";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#^#+#";  //\w 匹配字母或数字或下划线或汉字
    
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    
    return regex;
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    
    UIColor *linkColor = [[ThemeManager shareInstance] getThemeColor:@"Link_color"];
    return linkColor;
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {
    return [UIColor darkGrayColor];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
