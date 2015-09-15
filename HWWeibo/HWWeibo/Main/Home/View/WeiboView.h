//
//  WeiboView.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/24.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "WXLabel.h"
#import "ZoomImageView.h"

@class WeiboViewLayout;
@interface WeiboView : UIView <WXLabelDelegate>

@property (nonatomic, strong) WXLabel *textLabel;
@property (nonatomic, strong) WXLabel *sourseLabel;
@property (nonatomic, strong) ZoomImageView *imgView;
@property (nonatomic, strong) ThemeImageView *bgImageView;





@property (nonatomic, strong) WeiboViewLayout *layoutFrame;



@end
