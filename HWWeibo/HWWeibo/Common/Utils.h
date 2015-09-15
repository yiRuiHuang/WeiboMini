//
//  Utils.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/24.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSDate *)dateFromString:(NSString *)dateStr withFormatterStr:(NSString *)formatterStr;

+ (NSString *)stringFromDate:(NSDate *)date withFormatterStr:(NSString *)formatterStr;

+ (NSString *)weiboString:(NSString *)dateStr;

@end
