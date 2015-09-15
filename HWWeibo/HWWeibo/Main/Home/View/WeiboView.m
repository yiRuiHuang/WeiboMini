//
//  WeiboView.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/24.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "WeiboView.h"
#import "WeiboViewLayout.h"
#import "WeiboModal.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"
#import "UserMoal.h"

@implementation WeiboView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _createSubs];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (void)setLayoutFrame:(WeiboViewLayout *)layoutFrame {
    
    if (_layoutFrame != layoutFrame) {
        _layoutFrame = layoutFrame;
        [self setNeedsLayout];
    }
}

- (void)_createSubs {
    
    _textLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _textLabel.frame = _layoutFrame.contextFrame;
    _textLabel.wxLabelDelegate = self;
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.numberOfLines = 0;
    
    _sourseLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _sourseLabel.numberOfLines = 0;
    _sourseLabel.wxLabelDelegate = self;
    _sourseLabel.font = [UIFont systemFontOfSize:14];
   
    //主题颜色
    _textLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    _sourseLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    
    _imgView = [[ZoomImageView alloc] initWithFrame:CGRectZero];
    _imgView.contentMode =  UIViewContentModeScaleAspectFit;
    
    //4 原微博背景图片
    
    _bgImageView = [[ThemeImageView alloc] initWithFrame:CGRectZero];
    
    //拉伸点设置
    _bgImageView.leftCapWidth = 25;
    _bgImageView.topCapWidth = 25;
    _bgImageView.imgName = @"timeline_rt_border_9.png";

    [self addSubview:_textLabel];
    [self addSubview:_sourseLabel];
    [self addSubview:_imgView];
    [self insertSubview:_bgImageView atIndex:0];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    WeiboModal *modal = _layoutFrame.weiboModal;
    
    _textLabel.frame = _layoutFrame.contextFrame;
    _textLabel.text = modal.text;
    
    // 判断是否为转发微博
    if (modal.reWeiboModal != nil) {
        self.bgImageView.hidden = NO;
        self.sourseLabel.hidden = NO;
        
//        在转发的微博前面添加作者如 @cy
        UserMoal *userModal = modal.reWeiboModal.userMoal;
        NSString *reuser = [NSString stringWithFormat:@"@%@", userModal.screen_name];
        
        //原微博背景图片frame
        self.bgImageView.frame = self.layoutFrame.reWeibiBgFrame;
        
        //原微博内容及frame
        self.sourseLabel.text = [NSString stringWithFormat:@"%@:%@",reuser,modal.reWeiboModal.text];
        self.sourseLabel.frame = self.layoutFrame.reWeiboFrame;
        
        NSString *imgUrl = modal.reWeiboModal.thumbnailImage;
        if (imgUrl != nil) {
            self.imgView.hidden = NO;
            self.imgView.frame = self.layoutFrame.imageViewFrame;
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
            
        }else{
            
            self.imgView.hidden = YES;
        }
        
        NSString *fullImgUrlStr = modal.reWeiboModal.originalImage;
        if (fullImgUrlStr != nil) {
            self.imgView.fullImgUrlStr = fullImgUrlStr;
        }
        // 大图加载
        
    } else {
        _bgImageView.hidden = YES;
        _sourseLabel.hidden = YES;
        NSString *imgUrl = modal.thumbnailImage;
        if (imgUrl != nil) {
            self.imgView.hidden = NO;
            self.imgView.frame = _layoutFrame.imageViewFrame;
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        } else {
            self.imgView.hidden = YES;
        }
        // 大图加载
        NSString *fullImgUrlStr = modal.reWeiboModal.originalImage;
        if (fullImgUrlStr != nil) {
            self.imgView.fullImgUrlStr = fullImgUrlStr;
        }
        
    }
    
    
    
//    判断是否是gif图片
    // 首先有图片
    if (self.imgView.hidden == NO) {
        
        UIImageView *iconView = self.imgView.iconImageView;
        iconView.frame = CGRectMake(_imgView.width-24, _imgView.height-15, 24, 15);
        NSString *extension = nil;
        if (modal.thumbnailImage != nil) {
             extension = [modal.thumbnailImage pathExtension];
        } else if (modal.reWeiboModal.thumbnailImage != nil) {
             extension = [modal.reWeiboModal.thumbnailImage pathExtension];
        }
        
        if ([extension isEqualToString:@"gif"]) {
            iconView.hidden = NO;
            self.imgView.isGif = YES;
            
        } else {
            iconView.hidden = YES;
            self.imgView.isGif = NO;
            
        }

        
        
    }
    
}


#pragma mark - WXLabelDelegate

- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
//    return [UIColor colorWithRed:57.0/255 green:177.0/255 blue:244.0/255 alpha:1];
    
    return [[ThemeManager shareInstance] getThemeColor:@"Link_color"];
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {
    return [UIColor redColor];
}

- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context {
    NSLog(@"%@",context);
}

#pragma mark - NotificationAction

- (void)themeChange:(NSNotification *)notification {
    self.textLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    self.sourseLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    
    [self setNeedsDisplay];
}

@end
