//
//  FriendModel.m
//  HWWeibo
//
//  Created by hyrMac on 15/9/1.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "FriendModel.h"

@implementation FriendModel



- (NSDictionary*)attributeMapDictionary{
    
    //   @"属性名": @"数据字典的key"
    NSDictionary *mapAtt = @{
                             @"name":@"name",
                             @"profileImageUrl":@"profile_image_url",
                             @"followersCount":@"followers_count"
                             };
    
    return mapAtt;
}

@end
