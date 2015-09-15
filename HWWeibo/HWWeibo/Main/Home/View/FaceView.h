//
//  FaceView.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/22.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceViewDelegate <NSObject>

- (void)faceDidSelect:(NSString *)text;

@end


@interface FaceView : UIView{
    NSMutableArray *_items;  //二维数组
    //放大镜视图
    UIImageView *_magnifierView;
    
    //选中的表情名
    NSString *_selectedFaceName;
}
@property(nonatomic,readonly)NSInteger pageNumber;
@property (nonatomic,weak) id<FaceViewDelegate> delegate;

@end
