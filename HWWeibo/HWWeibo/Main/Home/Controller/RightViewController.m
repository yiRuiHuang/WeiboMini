//
//  RightViewController.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/22.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeButton.h"
#import "ThemeManager.h"
#import "PostWeioboViewController.h"
#import "BaseNavController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

#define buttonWH 45

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor = [UIColor greenColor];
    
    [self _createButtons];
    [self themeDidChangeAction];
}

- (void)_createButtons {
    

//    ThemeButton *button1 = [[ThemeButton alloc] initWithFrame:CGRectMake(15, 50, buttonWH, buttonWH)];
//    button1.normalImgName = @"newbar_icon_1.png";
//    
//    [self.view addSubview:button1];
    
    
    for (NSInteger i = 1; i < 6; i++) {
        NSString *buttonImgName = [NSString stringWithFormat:@"newbar_icon_%ld.png",i];
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(15, 40+buttonWH*(i-1)+5, buttonWH, buttonWH)];
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.normalImgName = buttonImgName;
        
        [self.view addSubview:button];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeAction) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (void)themeDidChangeAction {
    
    ThemeManager *manager = [ThemeManager shareInstance];
    
    UIImage *bgImage = [manager getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - buttonActions

- (void)buttonAction:(UIButton *)button {
    
    // 写微博 发
    if (button.tag == 1) {
        // 发送微博
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            // 弹出发送微博控制器
            
            PostWeioboViewController *vc = [[PostWeioboViewController alloc] init];
            
            
            // 创建导航控制器
             BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:vc];
            [self.mm_drawerController presentViewController:nav animated:YES completion:nil];
        }];

        
    
    }
    
}


@end
