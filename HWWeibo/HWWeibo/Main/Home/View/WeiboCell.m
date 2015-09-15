//
//  WeiboCell.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/22.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "WeiboCell.h"
#import "WeiboModal.h"
#import "UIImageView+WebCache.h"
#import "UserMoal.h"
#import "Utils.h"
#import "WeiboViewLayout.h"
#import "WeiboView.h"
#import "ThemeLabel.h"

@implementation WeiboCell

- (void)awakeFromNib {
    // Initialization code
    
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.weiboView];
    
    self.backgroundColor = [UIColor clearColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLayoutFrame:(WeiboViewLayout *)layoutFrame {
    if (_layoutFrame != layoutFrame) {
        _layoutFrame = layoutFrame;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    WeiboModal *_modal = _layoutFrame.weiboModal;
    
    // 用户头像
    NSString *profileStr = _modal.userMoal.profile_image_url;
    [_profileImageView sd_setImageWithURL:[NSURL URLWithString:profileStr]];
    
    
    
    // 用户昵称
    _screenName.text = _modal.userMoal.screen_name;
    _screenName.font = [UIFont boldSystemFontOfSize:14];
    
    // 转发数reposts_count
    _repostCountLabel.text = [NSString stringWithFormat:@"转发:%@",_modal.repostsCount];
    _repostCountLabel.font = [UIFont systemFontOfSize:12];
    
    // 评论数
    _commentCountLabel.text = [NSString stringWithFormat:@"评论:%@",_modal.commentsCount];
    _commentCountLabel.font = [UIFont systemFontOfSize:12];
    
    // 微博创建时间   在自定义工具类Utils中设置了时间格式转换代码
    _createTimeLabel.text = [Utils weiboString:_modal.createDate];
    _createTimeLabel.font = [UIFont systemFontOfSize:12];
//    _createTimeLabel.frame = CGRectMake(8, self.frame.size.height-30, 115, 21);
//    _createTimeLabel.frame = CGRectMake(8, self.layoutFrame.weiboViewfame.size.height+55-30, 115, 21);
////    NSLog(@"%f",self.frame.size.height);
//    NSLog(@"%f",self.layoutFrame.weiboViewfame.size.height);
    
    
    // 微博发出来源客户端
    _sourceLabel.text = _modal.source;
    _sourceLabel.font = [UIFont systemFontOfSize:12];
    
    // 内容集合体
    _weiboView.frame = self.layoutFrame.weiboViewfame;
    _weiboView.layoutFrame = self.layoutFrame;
    
    
    // label字体颜色的改变
//    Timeline_Name_color  //转发  评论  名称 颜色
//    Timeline_Time_color  // 时间颜色  微博来源颜色
//    Link_color //链接颜色
//    Timeline_Content_color //微博内容颜色
    /**
     @property (weak, nonatomic) IBOutlet ThemeLabel *screenName;            // 作者昵称
     
     @property (weak, nonatomic) IBOutlet ThemeLabel *repostCountLabel; // 转发数
     @property (weak, nonatomic) IBOutlet ThemeLabel *commentCountLabel;
     
     @property (weak, nonatomic) IBOutlet ThemeLabel *createTimeLabel;
     
     @property (weak, nonatomic) IBOutlet ThemeLabel *sourceLabel; // 微博发出来源客户端
     */
    _screenName.colorName = @"Timeline_Name_color";
    _repostCountLabel.colorName = @"Timeline_Name_color";
    _commentCountLabel.colorName = @"Timeline_Name_color";
    _createTimeLabel.colorName = @"Timeline_Time_color";
    _sourceLabel.colorName = @"Timeline_Time_color";
    
    
}

@end
