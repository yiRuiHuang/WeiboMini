//
//  WeiboTableView.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/22.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "WeiboViewLayout.h"
#import "WeiboModal.h"

//#import "WeiboDetailViewController.h"

@implementation WeiboTableView

- (instancetype)initWithFrame:(CGRect)frame  {
    if (self = [super initWithFrame:frame]) {
        [self _createTable];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self _createTable];
}

- (void)_createTable {
    
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    
    UINib *nibb = [UINib nibWithNibName:@"WeiboCell" bundle:[NSBundle mainBundle]];
    [self registerNib:nibb forCellReuseIdentifier:WeiboCellId];
    
}


#pragma  mark -  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"[self.dataArray count]%li",[self.dataArray count]);
    return [self.layoutFrameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:WeiboCellId forIndexPath:indexPath];
//    cell.modal = _dataArray[indexPath.row];
//    cell.cellHeight = cellHeight[indexPath.row];
    cell.layoutFrame = _layoutFrameArray[indexPath.row];
    return cell;
}

#pragma  mark  - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获取高度
    WeiboViewLayout *layoutFrame = _layoutFrameArray[indexPath.row];
    
    CGRect weiboViewfame = layoutFrame.weiboViewfame;
    CGFloat height = weiboViewfame.size.height;

    return height+90;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    WeiboDetailViewController *detailVC = [[WeiboDetailViewController alloc] init];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:_layoutFrameArray[indexPath.row] forKey:@"weiboViewLayout"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushDetailWeiboVC" object:self userInfo:dict];
    
    
}


@end
