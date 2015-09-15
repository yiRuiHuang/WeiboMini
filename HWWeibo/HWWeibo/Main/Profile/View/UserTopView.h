//
//  UserTopView.h
//  HWWeibo
//
//  Created by hyrMac on 15/9/1.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserTopModel;
@class ThemeLabel;

@interface UserTopView : UIView

@property (nonatomic, strong) UserTopModel *model;

/**
 *  @property (nonatomic, copy) NSString *screenName;
 
 @property (nonatomic, copy) NSString *province;
 
 @property (nonatomic, copy) NSString *city;
 
 @property (nonatomic, copy) NSString *userDescription;
 
 @property (nonatomic, copy) NSString *profileImageUrl;
 
 @property (nonatomic, copy) NSString *gender;
 
 @property (nonatomic, strong) NSNumber *followersCount;
 
 @property (nonatomic, strong) NSNumber *friendsCount;
 
 @property (nonatomic, strong) NSNumber *statusesCount;
 */
@property (nonatomic, strong) ThemeLabel *screenNameLabel;

@property (nonatomic, strong) ThemeLabel *provinceLabel;

@property (nonatomic, strong) ThemeLabel *cityLabel;

@property (nonatomic, strong) ThemeLabel *userDescriptionLabel;

@property (nonatomic, strong) UIImageView *profileImageView;

@property (nonatomic, strong) ThemeLabel *genderLabel;

@property (nonatomic, strong) UIButton *followersCountButton;

@property (nonatomic, strong) UIButton *friendsCountButton;

@property (nonatomic, strong) ThemeLabel *statusesCountLabel;


@end




