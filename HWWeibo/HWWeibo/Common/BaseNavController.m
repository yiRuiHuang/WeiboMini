//
//  BaseNavController.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/19.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "BaseNavController.h"
#import "ThemeManager.h"

@interface BaseNavController ()

@end

@implementation BaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self themeDidChangeAction];
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeAction) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (void)themeDidChangeAction {
    
    NSString *imgName = @"mask_titlebar64.png";
    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *img = [manager getThemeImage:imgName];
    [self.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    
    UIColor *titleColor = [manager getThemeColor:@"Mask_Title_color"];
    NSDictionary *attr = [NSDictionary dictionaryWithObject:titleColor forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = attr;
    
    self.navigationBar.tintColor = titleColor;
    
    UIImage *bgImage = [manager getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
