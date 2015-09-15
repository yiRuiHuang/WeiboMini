//
//  MainViewController.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/19.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavController.h"
#import "ThemeButton.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"
#import "AppDelegate.h"


@interface MainViewController ()
{
//    UIImageView *tabBarView;
    ThemeImageView *tabBarView;
//    UIImageView *selectView;
    ThemeImageView *selectView;
    
    
    ThemeImageView *badgeView;
    ThemeLabel *badgeLabel;
}

@end

@implementation MainViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DidFinishRefreshNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _createSubNav];
    [self _createTabBarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:DidFinishRefreshNotification object:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
}

- (void)_createTabBarView {
    
    // 01 tabBar.subviews移除
    Class cls = NSClassFromString(@"UITabBarButton");
    for (UIView *subView in self.tabBar.subviews) {
        //        NSLog(@"%@",[self.tabBar.subviews[0] class]);  //UITabBarButton
        if ([subView isKindOfClass:cls]) {
            
            [subView removeFromSuperview];
        }
    }
    
//    tabBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
//    tabBarView.image = [UIImage imageNamed:@"Skins/cat/mask_navbar.png"];
    tabBarView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    tabBarView.imgName = @"mask_navbar.png";
    tabBarView.userInteractionEnabled = YES;
    [self.tabBar addSubview:tabBarView];
    self.tabBar.translucent = YES;
    
//    selectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/5, 49)];
//    selectView.image = [UIImage imageNamed:@"Skins/cat/home_bottom_tab_arrow.png"];
    selectView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/5, 49)];
    selectView.imgName = @"home_bottom_tab_arrow.png";
    [self.tabBar addSubview:selectView];
    
//    NSArray *imgNames = @[
//                          @"Skins/cat/home_tab_icon_1.png",
//                          @"Skins/cat/home_tab_icon_2.png",
//                          @"Skins/cat/home_tab_icon_3.png",
//                          @"Skins/cat/home_tab_icon_4.png",
//                          @"Skins/cat/home_tab_icon_5.png",
//                          ];
    NSArray *imgNames = @[
                          @"home_tab_icon_1.png",
                          @"home_tab_icon_2.png",
                          @"home_tab_icon_3.png",
                          @"home_tab_icon_4.png",
                          @"home_tab_icon_5.png",
                          ];
    
    for (NSInteger i = 0; i < 5; i++) {
        
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*kScreenWidth/5, 0, kScreenWidth/5, 49)];
//         [button setImage:[UIImage imageNamed:imgNames[i]] forState:UIControlStateNormal];
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(i*kScreenWidth/5, 0, kScreenWidth/5, 49)];
       [button setNormalImgName:imgNames[i]];
       
        button.tag = i;
        [button addTarget:self action:@selector(buttonSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
    }
    
}


- (void)_createSubNav {
    
    NSArray *names = @[@"Home",@"Message",@"Profile",@"Discover",@"More"];
    NSMutableArray *navArray = [[NSMutableArray alloc] init];
    
    for (NSString *name in names) {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:name bundle:[NSBundle mainBundle]];
        BaseNavController *nav = [storyBoard instantiateInitialViewController];
        [navArray addObject:nav];
//        [self addChildViewController:nav];
        
    }
    
//    UIViewController *fir = self.childViewControllers[0];
//    [self.view insertSubview:fir.view belowSubview:tabBarView];
    self.viewControllers = navArray;
}

//- (void)setSelectIndex:(NSInteger)selectIndex {
//    
//    if (_selectIndex != selectIndex) {
//        UIViewController *lastView = self.childViewControllers[_selectIndex];
//        UIViewController *currentView = self.childViewControllers[selectIndex];
//        
//        [lastView.view removeFromSuperview];
//        [self.view insertSubview:currentView.view belowSubview:tabBarView];
//        
//        _selectIndex = selectIndex;
//    }
//    
//    
//}

- (void)buttonSelectAction:(UIButton *)button {
    [UIView animateWithDuration:0.3 animations:^{
        selectView.center = button.center;
    }];
    
//    [self setSelectIndex:button.tag];
    self.selectedIndex = button.tag;
}


- (void)timerAction {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *weibo = appDelegate.sinaweibo;
    [weibo requestWithURL:unread_count params:nil httpMethod:@"GET" delegate:self];
}



- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    if (badgeView == nil) {
        badgeView = [[ThemeImageView alloc] initWithFrame:CGRectMake(kScreenWidth/5-32, 0, 32, 32)];
        badgeView.imgName = @"number_notify_9.png";
        [self.tabBar addSubview:badgeView];
        
        
        badgeLabel = [[ThemeLabel alloc] initWithFrame:badgeView.bounds];
        badgeLabel.backgroundColor = [UIColor clearColor];
        badgeLabel.colorName = @"Timeline_Notice_color";
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.font = [UIFont systemFontOfSize:13];
        [badgeView addSubview:badgeLabel];
        
    }
    
    NSNumber *status = [result objectForKey:@"status"];
    int count = [status intValue];
    
    if (count > 0) {
        badgeView.hidden = NO;
        
        if (count > 99) {
            count = 99;
        }
        badgeLabel.text = [NSString stringWithFormat:@"%d",count];
        
    } else {
        badgeView.hidden = YES;
    }
    
    
}

- (void)refreshAction {
    badgeView.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
