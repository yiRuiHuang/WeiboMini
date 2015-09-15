//
//  WeiboModal.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/22.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "WeiboModal.h"
#import "UserMoal.h"
#import "RegexKitLite.h"

@implementation WeiboModal

/**
 *
 @property(nonatomic,copy)NSString       *createDate;       //微博创建时间
 @property(nonatomic,retain)NSNumber     *weiboId;           //微博ID
 @property(nonatomic,copy)NSString       *text;              //微博的内容
 @property(nonatomic,copy)NSString       *source;              //微博来源
 @property(nonatomic,retain)NSNumber     *favorited;         //是否已收藏
 @property(nonatomic,copy)NSString       *thumbnailImage;     //缩略图片地址
 @property(nonatomic,copy)NSString       *bmiddlelImage;     //中等尺寸图片地址
 @property(nonatomic,copy)NSString       *originalImage;     //原始图片地址
 @property(nonatomic,retain)NSDictionary *geo;               //地理信息字段
 @property(nonatomic,retain)NSNumber     *repostsCount;      //转发数
 @property(nonatomic,retain)NSNumber     *commentsCount;      //评论数
 
 */
- (NSDictionary*)attributeMapDictionary{
    
    //   @"属性名": @"数据字典的key"
    NSDictionary *mapAtt = @{
                             @"createDate":@"created_at",
                             @"weiboId":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"favorited":@"favorited",
                             @"thumbnailImage":@"thumbnail_pic",
                             @"bmiddlelImage":@"bmiddle_pic",
                             @"originalImage":@"original_pic",
                             @"geo":@"geo",
                             @"repostsCount":@"reposts_count",
                             @"commentsCount":@"comments_count",
                             @"attitudesCount":@"attitudes_count",
                             @"idstr":@"idstr"
                             };
    
    return mapAtt;
}

- (void)setAttributes:(NSDictionary *)dataDic {
    
    [super setAttributes:dataDic];
    
    // 微博来源处理
    
    if (self.source != nil) {
        NSString *regex = @">.+<";
        NSArray *items = [self.source componentsMatchedByRegex:regex];
        if (items.count > 0) {
            NSString *temp = items[0];
            self.source = [temp substringWithRange:NSMakeRange(1, temp.length-2)];
            self.source = [NSString stringWithFormat:@"来自:%@",self.source];
        }
    }
    
    // 表情图片解析
    NSString *imgRegex = @"\\[\\w+\\]";
    NSArray *faceItems = [self.text componentsMatchedByRegex:imgRegex]; //[good],[兔子]
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *imageArray = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSString *faceName in faceItems) {
        // 谓词过滤
        NSString *t = [NSString stringWithFormat:@"self.chs='%@'",faceName];
        NSPredicate *pred = [NSPredicate predicateWithFormat:t];
        NSArray *items = [imageArray filteredArrayUsingPredicate:pred];
        if (items.count > 0) {
            NSDictionary *faceDic = items[0];
            NSString *name = [faceDic objectForKey:@"png"];
            // 字符串替换
            NSString *replaceStr = [NSString stringWithFormat:@"<image url = '%@'>",name];
            self.text = [self.text stringByReplacingOccurrencesOfString:faceName withString:replaceStr];
            
        }
    }
    
    
    
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        _userMoal = [[UserMoal alloc] initWithDataDic:userDic];
    }

    NSDictionary *reWeiboDic = [dataDic objectForKey:@"retweeted_status"];
    if (reWeiboDic != nil) {
        _reWeiboModal = [[WeiboModal alloc] initWithDataDic:reWeiboDic];
    }
    
}


@end
