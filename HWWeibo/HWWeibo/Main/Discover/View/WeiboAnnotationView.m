//
//  WeiboAnnotationView.m
//  HWWeibo
//
//  Created by hyrMac on 15/9/2.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "UIImageView+WebCache.h"
#import "WeiboModal.h"
#import "UserMoal.h"

@implementation WeiboAnnotationView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, 160, 50);
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        [self _createSubs];
    }
    return self;
}

//- (void)setWeiboAnnotation:(WeiboAnnotation *)weiboAnnotation {
//    
//    if (_weiboAnnotation != weiboAnnotation) {
//        _weiboAnnotation = weiboAnnotation;
//        [self setNeedsLayout];
//    }
//}



- (void)_createSubs {
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_iconImageView];
    
    
    _textLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _textLabel.font = [UIFont boldSystemFontOfSize:12];
    _textLabel.numberOfLines = 3;
    _textLabel.textColor = [UIColor blackColor];
    [self addSubview:_textLabel];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    WeiboAnnotation *wAnnonation = self.annotation;
//    WeiboAnnotation *wAnnonation = _weiboAnnotation;
    WeiboModal *modal = wAnnonation.model;
    
    
    
    
    _iconImageView.frame = CGRectMake(0, 0, 50, 50);
    
    NSString *imgStr = modal.userMoal.profile_image_url;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imgStr]];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.frame = CGRectMake(60, 0, 100, 50);
    _textLabel.text = modal.text;
    
    
    
    
}


@end
