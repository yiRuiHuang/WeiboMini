//
//  FaceScrollView.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/22.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"
@interface FaceScrollView : UIView<UIScrollViewDelegate>{
    
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    FaceView *_faceView;

}

- (void)setFaceViewDelegate:(id<FaceViewDelegate>)delegate;

@end
