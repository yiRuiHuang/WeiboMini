//
//  BaseViewController.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/19.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ThemeManager.h"
#import "ThemeButton.h"
#import "UIProgressView+AFNetworking.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLeftAction {
    
    MMDrawerController *draw = self.mm_drawerController;
    [draw openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

- (void)editRightAction {
    MMDrawerController *draw = self.mm_drawerController;
    [draw openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)setRootNavItem {
    
    ThemeButton *button = [[ThemeButton alloc] init];
    button.frame = CGRectMake(0, 0, 90, 40);
    button.normalImgName = @"group_btn_all_on_title.png";
    button.normalBgImgName = @"button_title.png";
    [button addTarget:self action:@selector(setLeftAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"设置" forState:UIControlStateNormal];
    [button setTitleColor:[[ThemeManager shareInstance] getThemeColor:@"Mask_Title_color"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    
    ThemeButton *button2 = [[ThemeButton alloc] init];
    button2.frame = CGRectMake(0, 0, 40, 40);
    button2.normalImgName = @"button_icon_plus.png";
    button2.normalBgImgName = @"button_m.png";
    [button2 addTarget:self action:@selector(editRightAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button2];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 封装加载，可在多个页面使用

- (void)showHUD:(NSString *)title {
    
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view
                                    animated:YES];
    }
    
    [_hud show:YES];
    _hud.labelText = title;
    //_hud.detailsLabelText  //子标题
    
    //灰色的背景盖住其他视图
    _hud.dimBackground = YES;
    
}

- (void)hideHUD {
    
    [_hud hide:YES afterDelay:1];
}


- (void)completeHUD:(NSString *)title {
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    //显示模式改为：自定义视图模式
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    
    //延迟隐藏
    [_hud hide:YES afterDelay:1.5];
    
}


#pragma mark - 状态栏提示

- (void)showStatusTip:(NSString *)title
                 show:(BOOL)show
            operation:(AFHTTPRequestOperation *)operation{
    
    
    if (_tipWindow == nil) {
        //创建window
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        
        //创建Label
        UILabel *tpLabel = [[UILabel alloc] initWithFrame:_tipWindow.bounds];
        tpLabel.backgroundColor = [UIColor clearColor];
        tpLabel.textAlignment = NSTextAlignmentCenter;
        tpLabel.font = [UIFont systemFontOfSize:13.0f];
        tpLabel.textColor = [UIColor whiteColor];
        tpLabel.tag = 100;
        [_tipWindow addSubview:tpLabel];
        
        
        //进度条
        UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progress.frame = CGRectMake(0, 20-3, kScreenWidth, 5);
        progress.tag = 101;
        progress.progress = 0.0;
        [_tipWindow addSubview:progress];
        
        
    }
    
    UILabel *tpLabel = (UILabel *)[_tipWindow viewWithTag:100];
    tpLabel.text = title;
    
    
    UIProgressView *progressView = (UIProgressView *)[_tipWindow viewWithTag:101];
    
    if (show) {
        _tipWindow.hidden = NO;
        if (operation != nil) {
            progressView.hidden = NO;
            //AF 对 UIProgressView的扩展
            [progressView setProgressWithUploadProgressOfOperation:operation animated:YES];
        }else{
            progressView.hidden = YES;
        }
        
        
    }else{
        
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:1];
    }
}


- (void)removeTipWindow{
    
    _tipWindow.hidden = YES;
    _tipWindow = nil;
}

#pragma -mark 设置背景图片
- (void)setBgImage{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadImage) name:kThemeDidChangeNotification object:nil];
    
    [self _loadImage];
}

- (void)_loadImage{
    
    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *img = [manager getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    
}

@end
