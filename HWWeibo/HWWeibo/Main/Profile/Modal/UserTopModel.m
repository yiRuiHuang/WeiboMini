//
//  UserTopModel.m
//  HWWeibo
//
//  Created by hyrMac on 15/9/1.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "UserTopModel.h"

@implementation UserTopModel

- (NSDictionary*)attributeMapDictionary{
    
    //   @"属性名": @"数据字典的key"
    NSDictionary *mapAtt = @{
                             @"screenName":@"screen_name",
                             @"province":@"province",
                             @"city":@"city",
                             @"userDescription":@"description",
                             @"profileImageUrl":@"profile_image_url",
                             @"gender":@"gender",
                             @"followersCount":@"followers_count",
                             @"friendsCount":@"friends_count",
                             @"statusesCount":@"statuses_count",
                             
                             };
    
    return mapAtt;
}

@end
