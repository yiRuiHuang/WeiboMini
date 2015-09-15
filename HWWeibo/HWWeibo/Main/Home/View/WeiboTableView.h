//
//  WeiboTableView.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/22.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboTableView : UITableView <UITableViewDelegate,UITableViewDataSource>
{
//     CGFloat cellHeight[10];
}

//@property (nonatomic, strong) NSArray *dataArray;


@property (nonatomic, strong) NSArray *layoutFrameArray;

//  纪录单元格的高度

@end
