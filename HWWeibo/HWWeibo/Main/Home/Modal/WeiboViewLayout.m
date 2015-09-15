//
//  WeiboViewLayout.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/24.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "WeiboViewLayout.h"
#import "WeiboModal.h"
#import "WXLabel.h"

@implementation WeiboViewLayout

- (void)setWeiboModal:(WeiboModal *)weiboModal {
    if (_weiboModal != weiboModal) {
        _weiboModal = weiboModal;
        [self _layoutFrame];
    }
}



- (void)_layoutFrame{
    
    //根据 weiboModel计算
    
    //1.微博视图的frame
    if (self.isDetail) {
        self.weiboViewfame = CGRectMake(8, 65, kScreenWidth-16, 0);
    } else {
        self.weiboViewfame = CGRectMake(55, 40, kScreenWidth-65, 0);
    }
    
    //2.微博内容的frame
    //1>计算微博内容的宽度
    CGFloat textWidth = CGRectGetWidth(self.weiboViewfame)-20;
    
    //2>计算微博内容的高度
    NSString *text = self.weiboModal.text;
    CGFloat textHeight = [WXLabel getTextHeight:15 width:textWidth text:text linespace:5.0];
    
    
    self.contextFrame = CGRectMake(10, 0, textWidth, textHeight);
    
    //3.原微博的内容frame
    if (self.weiboModal.reWeiboModal != nil) {
        NSString *reText = self.weiboModal.reWeiboModal.text;
        
        //1>宽度
        CGFloat reTextWidth = textWidth-20;
        //2>高度

        CGFloat textHeight = [WXLabel getTextHeight:14 width:reTextWidth text:reText linespace:5.0];
        
        //3>Y坐标
        CGFloat Y = CGRectGetMaxY(self.contextFrame)+10;
        self.reWeiboFrame = CGRectMake(20, Y, reTextWidth, textHeight);
        
        //4.原微博的图片
        NSString *thumbnailImage = self.weiboModal.reWeiboModal.thumbnailImage;
        if (thumbnailImage != nil) {
            
            CGFloat Y = CGRectGetMaxY(self.reWeiboFrame)+10;
            CGFloat X = CGRectGetMinX(self.reWeiboFrame);
            
//#warning 设置微博图片的尺寸
//            if (self.isDetail) {
//                self.imageViewFrame = CGRectMake(X, Y, CGRectGetWidth(self.weiboViewfame)-20, 160);
//            } else {
//                self.imageViewFrame = CGRectMake(X, Y, 80, 80);
//            }
            self.imageViewFrame = CGRectMake(X, Y, 80, 80);
        }
        
        //4.原微博的背景
        CGFloat bgX = CGRectGetMinX(self.contextFrame);
        CGFloat bgY = CGRectGetMaxY(self.contextFrame);
        CGFloat bgWidth = CGRectGetWidth(self.contextFrame);
        CGFloat bgHeight = CGRectGetMaxY(self.reWeiboFrame);
        if (thumbnailImage != nil) {
            bgHeight = CGRectGetMaxY(self.imageViewFrame);
        }
        bgHeight -= CGRectGetMaxY(self.contextFrame);
        bgHeight += 10;
        
        self.reWeibiBgFrame = CGRectMake(bgX, bgY, bgWidth, bgHeight);
        
    } else {
        //微博图片
        NSString *thumbnailImage = self.weiboModal.thumbnailImage;
        if (thumbnailImage != nil) {
            CGFloat imgX = CGRectGetMinX(self.contextFrame);
            CGFloat imgY = CGRectGetMaxY(self.contextFrame)+10;
            
//#warning 微博正文图片尺寸调整
//            if (self.isDetail) {
//                self.imageViewFrame = CGRectMake(imgX , imgY, CGRectGetWidth(self.weiboViewfame)-40, 160);
//            } else {
//                self.imageViewFrame = CGRectMake(imgX , imgY, 80, 80);
//            }
            self.imageViewFrame = CGRectMake(imgX , imgY, 80, 80);
        }
        
    }
    
    //计算微博视图的高度：微博视图最底部子视图的Y坐标
    CGRect f = self.weiboViewfame;
    if (self.weiboModal.reWeiboModal != nil) {
        f.size.height = CGRectGetMaxY(_reWeibiBgFrame)+10;
    }
    else if(self.weiboModal.thumbnailImage != nil) {
        f.size.height = CGRectGetMaxY(_imageViewFrame)+10;
    }
    else {
        f.size.height = CGRectGetMaxY(_contextFrame)+10;
    }
    self.weiboViewfame = f;
}

@end
