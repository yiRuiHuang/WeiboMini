//
//  WeiboViewLayout.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/24.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WeiboModal;
@interface WeiboViewLayout : NSObject

@property (nonatomic, assign) CGRect contextFrame;    // 微博文字内容 frame
@property (nonatomic, assign) CGRect reWeiboFrame;    // 转发的微博的转发内容的 frame
@property (nonatomic, assign) CGRect imageViewFrame;  // 微博图片的frame
@property (nonatomic, assign) CGRect reWeibiBgFrame;  

@property (nonatomic, assign) CGRect weiboViewfame;   // 全部内容整体大小


@property (nonatomic, strong) WeiboModal *weiboModal;


//是否是微博详情
@property(nonatomic,assign)BOOL isDetail;

@end
