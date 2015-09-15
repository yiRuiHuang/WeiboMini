//
//  ThemeButton.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/21.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton
// 正常状态的按钮的图片的名字
@property (nonatomic, copy) NSString *normalImgName;

// 高亮状态的按钮的图片的名字
@property (nonatomic, copy) NSString *highLightImgName;

// 正常状态
@property (nonatomic, copy) NSString *normalBgImgName;

// 高亮状态
@property (nonatomic, copy) NSString *highLightBgImgName;
@end
