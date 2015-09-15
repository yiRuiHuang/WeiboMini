//
//  Common.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/19.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#ifndef HWWeibo_Common_h
#define HWWeibo_Common_h
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kAppKey             @"2471589177"
#define kAppSecret          @"ff14de65408ad563faf022e91f9fb380"
#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"


#define WeiboCellId @"WeiboCellId"


#define unread_count @"remind/unread_count.json"  //未读消息
#define home_timeline @"statuses/home_timeline.json"  //微博列表
#define comments  @"comments/show.json"   //评论列表

#define DidFinishRefreshNotification @"DidFinishRefreshNotification"  // 完成刷新的通知

#define PushDetailWeiboVC @"PushDetailWeiboVC" // 弹出微博详情页面

#define geo_to_address  @"/2/location/geo/geo_to_address.json"   // 根据经纬度获取地理信息

#define place_nearby_pois  @"/2/place/nearby/pois.json"  // 附近地点

#define nearby_timeline @"/2/place/nearby_timeline.json" // 附近微博动态

// 版本
#define kVersion [[UIDevice currentDevice].systemVersion floatValue]

/**
 *  发微博
 */
//#define ToKenValue  @"2.00t2JbxBZPXQhCf43df84d31MAhsaD"
//#define TokenKey  @"access_token"
#define users_show  @"/2/users/show.json"   // 用户主页简单数据
#define statuses_user_timeline @"/2/statuses/user_timeline.json"   // 用户个人微博

//https://api.weibo.com/2/friendships/friends.json
#define friendships_friends  @"/2/friendships/friends.json"   //  关注详情

#define friendships_followers @"/2/friendships/followers.json"  // 粉丝详情



#define  BaseUrl @"https://api.weibo.com"
#define SendWeiBo  @"/2/statuses/update.json"
#define HomeList @"/2/statuses/home_timeline.json"
#define SendImage @"/2/statuses/upload.json"


#endif
