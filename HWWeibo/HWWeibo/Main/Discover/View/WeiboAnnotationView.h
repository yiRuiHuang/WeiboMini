//
//  WeiboAnnotationView.h
//  HWWeibo
//
//  Created by hyrMac on 15/9/2.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "WeiboAnnotation.h"
#import "WXLabel.h"

@interface WeiboAnnotationView : MKAnnotationView
{
    UIImageView *_iconImageView;
    WXLabel *_textLabel;
}

//@property (nonatomic, strong) WeiboAnnotation *weiboAnnotation;

@end
