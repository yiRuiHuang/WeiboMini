//
//  LeftViewController.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/22.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "BaseViewController.h"

@interface LeftViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *_sectionTitles;
    NSArray *_rowTitles;
}

@end

