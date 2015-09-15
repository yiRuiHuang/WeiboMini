//
//  CommentModel.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/28.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "CommentModel.h"
#import "UserMoal.h"
#import "RegexKitLite.h"

@implementation CommentModel

- (void)setAttributes:(NSDictionary *)dataDic {
    
    [super setAttributes:dataDic];
    
    // 微博来源处理
    
//    if (self.source != nil) {
//        NSString *regex = @">.+<";
//        NSArray *items = [self.source componentsMatchedByRegex:regex];
//        if (items.count > 0) {
//            NSString *temp = items[0];
//            self.source = [temp substringWithRange:NSMakeRange(1, temp.length-2)];
//            self.source = [NSString stringWithFormat:@"来自:%@",self.source];
//        }
//    }
    
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
    
//    NSDictionary *reWeiboDic = [dataDic objectForKey:@"retweeted_status"];
//    if (reWeiboDic != nil) {
//        _reWeiboModal = [[WeiboModal alloc] initWithDataDic:reWeiboDic];
//    }
    
}


@end
