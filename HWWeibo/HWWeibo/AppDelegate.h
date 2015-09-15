//
//  AppDelegate.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/19.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate ,SinaWeiboDelegate>

@property (strong, nonatomic) UIWindow *window;

// 测试新浪微博
@property (strong, nonatomic) SinaWeibo *sinaweibo;

@end

