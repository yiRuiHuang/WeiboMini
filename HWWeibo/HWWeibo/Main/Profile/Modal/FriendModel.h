//
//  FriendModel.h
//  HWWeibo
//
//  Created by hyrMac on 15/9/1.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "BaseModel.h"

@interface FriendModel : BaseModel

/**
 *  screen_name	string	用户昵称
               name	string	友好显示名称
 province	int	用户所在省级ID
 city	int	用户所在城市ID
 location	string	用户所在地
 description	string	用户个人描述
 url	string	用户博客地址
                         profile_image_url	string	用户头像地址（中图），50×50像素
 profile_url	string	用户的微博统一URL地址
 domain	string	用户的个性化域名
 weihao	string	用户的微号
 gender	string	性别，m：男、f：女、n：未知
 followers_count	int	粉丝数
 */


@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *profileImageUrl;

@property (nonatomic, strong) NSNumber *followersCount;


@end
