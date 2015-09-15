//
//  MoreViewController.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/19.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreTableViewCell.h"
#import "MoreModal.h"
#import "ThemeManager.h"
#import "ThemeTableViewController.h"
#import "AppDelegate.h"

@interface MoreViewController ()
{
    UITableView *moreTableView;
    NSMutableArray *messageArray;
}

@end

@implementation MoreViewController

- (void)viewWillAppear:(BOOL)animated {
    [moreTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"MORE";
    
    [self _createTableView];
    [self _loadData];
    
}

- (void)_loadData {
    messageArray = [NSMutableArray array];
    NSArray *array = [NSArray arrayWithObjects:@"主题选择",@"账户管理",@"意见反馈", nil];
    NSArray *array1 = [NSArray arrayWithObjects:@"more_icon_theme.png",@"more_icon_account.png",@"more_icon_feedback.png", nil];
    for (NSInteger i = 0; i < array.count; i++) {
        MoreModal *modal = [[MoreModal alloc] init];
        modal.labelContent = array[i];

        modal.iconName = array1[i];
        [messageArray addObject:modal];
    }
}

- (void)_createTableView {
    
    moreTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    moreTableView.backgroundColor = [UIColor clearColor];
    [moreTableView registerNib:[UINib nibWithNibName:@"MoreTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"moreCell"];
    
    moreTableView.delegate = self;
    moreTableView.dataSource = self;
    [self.view addSubview:moreTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.modal = messageArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.themeLabel.text = [ThemeManager shareInstance].themeName;
            cell.themeLabel.textAlignment = NSTextAlignmentRight;
        } else {
            cell.themeLabel.text = nil;
        }
        
    } else if (indexPath.section == 1){
        cell.modal = messageArray[2];
        cell.themeLabel.text = nil;
    } else {
//        cell.modal = messageArray[3];
        cell.themeLabel.text = @"退出当前账号";
        cell.themeLabel.textAlignment = NSTextAlignmentLeft;
//        cell.themeLabel.center = CGPointMake(kScreenWidth/2, 22);
        cell.contentLabel.text = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.iconImageView = nil;
    }

    
    return cell;
}

#pragma - mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && indexPath.section == 0) {
        ThemeTableViewController *tvc = [[ThemeTableViewController alloc] init];
       
        [self.navigationController pushViewController:tvc animated:YES];
    }
    if (indexPath.section == 2) {
        SinaWeibo * sina = [self sinaweibo];
        [sina logOut];
    }
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

@end
