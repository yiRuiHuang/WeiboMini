//
//  LocationDetailModel.h
//  HWWeibo
//
//  Created by hyrMac on 15/9/1.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "BaseModel.h"

@interface LocationDetailModel : BaseModel


/**
 *  "title": "三个贵州人(中关村店)",
 "address": "北四环西路58号理想国际大厦202-205",
  "icon": "http://u1.sinaimg.cn/upload/2012/03/23/1/xysh.png",
 */

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *icon;

@end
