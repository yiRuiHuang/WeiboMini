//
//  WeiboModal.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/22.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "BaseModel.h"
@class UserMoal;

@interface WeiboModal : BaseModel

@property (nonatomic,copy) NSString       *createDate;       //微博创建时间
@property (nonatomic,retain) NSNumber     *weiboId;           //微博ID      新浪借口不通用，弃用
@property (nonatomic,copy) NSString       *text;              //微博的内容
@property (nonatomic,copy) NSString       *source;              //微博来源
@property (nonatomic,retain) NSNumber     *favorited;         //是否已收藏
@property (nonatomic,copy) NSString       *thumbnailImage;     //缩略图片地址
@property (nonatomic,copy) NSString       *bmiddlelImage;     //中等尺寸图片地址
@property (nonatomic,copy) NSString       *originalImage;     //原始图片地址
@property (nonatomic,retain) NSDictionary *geo;               //地理信息字段
@property (nonatomic,retain) NSNumber     *repostsCount;      //转发数
@property (nonatomic,retain) NSNumber     *commentsCount;      //评论数
@property (nonatomic,retain) NSNumber     *attitudesCount;     //表态数
@property (nonatomic,copy) NSString *idstr; //微博IDStr

@property (nonatomic,strong) UserMoal *userMoal;


@property (nonatomic,strong) WeiboModal *reWeiboModal;


@end
