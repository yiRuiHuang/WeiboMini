//
//  WeiboCell.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/22.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class WeiboModal;
@class WeiboViewLayout;
@class WeiboView;
@class ThemeLabel;

@interface WeiboCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;  // 作者头像
@property (weak, nonatomic) IBOutlet ThemeLabel *screenName;            // 作者昵称

@property (weak, nonatomic) IBOutlet ThemeLabel *repostCountLabel; // 转发数
@property (weak, nonatomic) IBOutlet ThemeLabel *commentCountLabel;

@property (weak, nonatomic) IBOutlet ThemeLabel *createTimeLabel;

@property (weak, nonatomic) IBOutlet ThemeLabel *sourceLabel; // 微博发出来源客户端


@property (nonatomic, strong) WeiboView *weiboView;

//@property (nonatomic, strong) WeiboModal *modal;
@property (nonatomic, strong) WeiboViewLayout *layoutFrame;



//  cell的高度
//@property (nonatomic, assign) CGFloat cellHeight;
@end
