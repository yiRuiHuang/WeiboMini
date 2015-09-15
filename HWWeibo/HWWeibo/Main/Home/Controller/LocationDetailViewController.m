//
//  LocationDetailViewController.m
//  HWWeibo
//
//  Created by hyrMac on 15/9/1.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "LocationDetailViewController.h"
#import "ThemeButton.h"
#import "ThemeManager.h"
#import "UIImageView+WebCache.h"
#import "DataService.h"
#import "LocationDetailModel.h"

@interface LocationDetailViewController ()
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation LocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我在这里";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _setNavBar];
    [self _createTableView];
    [self _loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_loadData {
    
    _dataArray = [NSMutableArray array];
    
//    NSString *locationStr = [_params objectForKey:@"coordinate"];
    NSArray *locationStrArray = [_locationStr componentsSeparatedByString:@","];
    
    
    NSMutableDictionary *currentParams = [NSMutableDictionary dictionary];
    
    [currentParams setObject:locationStrArray[1] forKey:@"lat"];
    [currentParams setObject:locationStrArray[0] forKey:@"long"];
    
    [DataService requestAFUrl:place_nearby_pois httpMethod:@"GET" params:currentParams data:nil block:^(id result) {
        
        NSArray *pois = [result objectForKey:@"pois"];
        
        for (NSDictionary *dic in pois) {
            
            LocationDetailModel *model = [[LocationDetailModel alloc] initWithDataDic:dic];
            
            [_dataArray addObject:model];

        }
        
        
//        NSLog(@"%@",result);
        
        [_tableView reloadData];
        
        
    }];
    
    
}


- (void)_setNavBar {
    
    ThemeButton *button = [[ThemeButton alloc] init];
    button.frame = CGRectMake(0, 0, 40, 40);
    //    button.normalImgName = @"group_btn_all_on_title.png";
    //    button.normalBgImgName = @"button_title.png";
    [button addTarget:self action:@selector(setCancelAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[[ThemeManager shareInstance] getThemeColor:@"Mask_Title_color"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
}

- (void)setCancelAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)_createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"locationCell"];
    
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld",_dataArray.count);
    return _dataArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"locationCell"];
    }
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"locationCell"];
    LocationDetailModel *model = _dataArray[indexPath.row];
    NSString *iconStr = model.icon;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:iconStr]];
    cell.textLabel.text = model.title;
    
    cell.detailTextLabel.text = model.address;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
@end







