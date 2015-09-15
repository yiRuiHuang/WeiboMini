//
//  ProfileViewController.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/19.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserTopView.h"
#import "DataService.h"
#import "UserTopModel.h"
#import "WeiboTableView.h"
#import "WeiboModal.h"
#import "WeiboViewLayout.h"

//http://open.weibo.com/wiki/2/users/show     根据用户ID获取用户信息
//http://open.weibo.com/wiki/2/statuses/user_timeline
@interface ProfileViewController ()
{
    UserTopView *_topView;
    UserTopModel *_model;
    
    WeiboTableView *_weiboTableView;
    NSMutableArray *_data;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    
    _data = [NSMutableArray array];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"PROFILE";
    
    
    [self _createUserTopView];
    [self _createTableView];
    [self _loadData];
    
    
}

- (void)_createUserTopView {
    
    _topView = [[UserTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
//    [self.view addSubview:_topView];
    
}

- (void)_createTableView {
    
    _weiboTableView = [[WeiboTableView alloc] initWithFrame:self.view.bounds];
//    _weiboTableView.delegate = self;
//    _weiboTableView.dataSource = self;
    
    
    _weiboTableView.tableHeaderView = _topView;
    
    [self.view addSubview:_weiboTableView];
    
//    UINib *nibb = [UINib nibWithNibName:@"WeiboCell" bundle:[NSBundle mainBundle]];
//    [_weiboTableView registerNib:nibb forCellReuseIdentifier:WeiboCellId];
    
}


- (void)_loadData {
//    个人基本数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"LeoWellv" forKey:@"screen_name"];
    
    __weak ProfileViewController *  weakSelf = self;
    
    [DataService requestAFUrl:users_show httpMethod:@"GET" params:params data:nil block:^(id result) {
        
        
        __strong ProfileViewController *  strongSelf = weakSelf;

//        NSLog(@"%@",result);
        NSDictionary *resultDic = result;
        
        strongSelf->_model = [[UserTopModel alloc] initWithDataDic:resultDic];
        
        strongSelf->_topView.model = _model;
    
    }];
    
    
//    个人主页微博数据
    
    NSMutableDictionary *sparams = [NSMutableDictionary dictionary];
    [sparams setObject:@"5" forKey:@"count"];
    [sparams setObject:@"LeoWellv" forKey:@"screen_name"];
    
    [DataService requestUrl:statuses_user_timeline httpMethod:@"GET" params:sparams block:^(id result) {
        NSArray *statuses = [result objectForKey:@"statuses"];
//        NSLog(@"%ld",statuses.count);
        NSMutableArray *layoutFrameArray = [[NSMutableArray alloc] initWithCapacity:statuses.count];
        for (NSDictionary *dict in statuses) {
            WeiboModal *weiboModal = [[WeiboModal alloc] initWithDataDic:dict];
            WeiboViewLayout *layoutFrame = [[WeiboViewLayout alloc] init];
            layoutFrame.weiboModal = weiboModal;
            
            [layoutFrameArray addObject:layoutFrame];
        }
        
        _data = layoutFrameArray;
        _weiboTableView.layoutFrameArray = _data;
        [_weiboTableView reloadData];
        
    }];
    

}



//#pragma mark - 
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return nil;
//    
//}



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
