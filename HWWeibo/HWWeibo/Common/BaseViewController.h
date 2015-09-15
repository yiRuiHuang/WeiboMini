//
//  BaseViewController.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/19.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"

@interface BaseViewController : UIViewController
{
    MBProgressHUD *_hud;
    
    UIWindow *_tipWindow;
}


- (void)setRootNavItem;
- (void)setBgImage;


//显示hud提示-开源代码
- (void)showHUD:(NSString *)title;
- (void)hideHUD;
//完成的提示
- (void)completeHUD:(NSString *)title;

//状态栏提示
- (void)showStatusTip:(NSString *)title
                 show:(BOOL)show
            operation:(AFHTTPRequestOperation *)operation;

@end
