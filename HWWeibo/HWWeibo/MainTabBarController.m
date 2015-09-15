//
//  MainTabBarController.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/19.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//
/**
 *  废弃，不用
 */
#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _createSubNav];
}

- (void)_createSubNav {
    
    NSArray *names = @[@"Home",@"Message",@"Profile",@"Discover",@"More"];
    NSMutableArray *navArray = [[NSMutableArray alloc] init];
    
    for (NSString *name in names) {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:name bundle:[NSBundle mainBundle]];
        UINavigationController *nav = [storyBoard instantiateInitialViewController];
        [navArray addObject:nav];
    }
    
    self.viewControllers = navArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
