//
//  LocationDetailViewController.h
//  HWWeibo
//
//  Created by hyrMac on 15/9/1.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "BaseViewController.h"

@interface LocationDetailViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>


//@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, copy) NSString *locationStr;

@end
