//
//  WeiboDetailViewController.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/28.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboViewLayout;
@class ThemeLabel;
@class WeiboView;

@interface WeiboDetailViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIView *WeiboCellView;


/**
 *  @property (weak, nonatomic) IBOutlet UIImageView *profileImageView;  // 作者头像
 @property (weak, nonatomic) IBOutlet ThemeLabel *screenName;            // 作者昵称
 
 @property (weak, nonatomic) IBOutlet ThemeLabel *repostCountLabel; // 转发数
 @property (weak, nonatomic) IBOutlet ThemeLabel *commentCountLabel;
 
 @property (weak, nonatomic) IBOutlet ThemeLabel *createTimeLabel;
 
 @property (weak, nonatomic) IBOutlet ThemeLabel *sourceLabel; // 微博发出来源客户端
 */

@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) ThemeLabel *screenName;





@property (nonatomic, strong) WeiboView *weiboView;

@property (nonatomic, strong) WeiboViewLayout *layoutFrame;






@end
