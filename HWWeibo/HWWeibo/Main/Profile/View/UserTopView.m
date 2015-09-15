//
//  UserTopView.m
//  HWWeibo
//
//  Created by hyrMac on 15/9/1.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "UserTopView.h"
#import "UserTopModel.h"
#import "ThemeLabel.h"
#import "UIImageView+WebCache.h"
#import "UIView+UIViewController.h"
#import "FriendViewController.h"
#import "FollowViewController.h"

@implementation UserTopView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _createSubs];
    }
    return self;
}

- (void)setModel:(UserTopModel *)model {
    
    if (_model != model) {
        _model = model;
        [self setNeedsLayout];
    }
}

- (void)_createSubs {
    
    /**
     
      @property (nonatomic, strong) UIImageView *profileImageView;
      @property (nonatomic, strong) ThemeLabel *screenNameLabel;
      @property (nonatomic, strong) ThemeLabel *genderLabel;
      @property (nonatomic, strong) ThemeLabel *provinceLabel;
      @property (nonatomic, strong) ThemeLabel *userDescriptionLabel;
                   @property (nonatomic, strong) ThemeLabel *cityLabel;
      @property (nonatomic, strong) UIButton *friendsCountButton;
      @property (nonatomic, strong) UIButton *followersCountButton;
     
    
     
     @property (nonatomic, strong) ThemeLabel *statusesCountLabel;
     *
     *
     */
    
    _profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 50, 50)];
    [self addSubview:_profileImageView];
    
    _screenNameLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(66, 8,kScreenWidth-66-10, 25)];
    [self addSubview:_screenNameLabel];
    
    _genderLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(66, 40, 15, 15)];
    [self addSubview:_genderLabel];
    
    _provinceLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(85, 40, 30, 15)];
    [self addSubview:_provinceLabel];
    
    _userDescriptionLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(66, 60, kScreenWidth-66-10, 15)];
    [self addSubview:_userDescriptionLabel];
    
    
    _friendsCountButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 70, 100, 40)];
    [_friendsCountButton addTarget:self
                            action:@selector(friendAction)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_friendsCountButton];
    
    
    
    _followersCountButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 70, 100, 40)];
    [self addSubview:_followersCountButton];
    [_followersCountButton addTarget:self
                              action:@selector(followAction)
                    forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _statusesCountLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(8, 120, kScreenWidth-18, 30)];
    [self addSubview:_statusesCountLabel];
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    NSString *imgStr = _model.profileImageUrl;
    [_profileImageView sd_setImageWithURL:[NSURL URLWithString:imgStr]];
    
    _screenNameLabel.text = _model.screenName;
    
    _genderLabel.text = _model.gender;
    
    _provinceLabel.text = _model.province;
    
    _userDescriptionLabel.text = _model.userDescription;
    
    
    [_friendsCountButton setTitle:[NSString stringWithFormat:@"关注%@",_model.friendsCount] forState:UIControlStateNormal];
    
    [_followersCountButton setTitle:[NSString stringWithFormat:@"粉丝%@",_model.followersCount] forState:UIControlStateNormal];
    
    
    _statusesCountLabel.text = [NSString stringWithFormat:@"共%@条微博",_model.statusesCount];
    
    
    
    
}


- (void)friendAction {
    
    //关注详情控制器
    FriendViewController *vc = [[FriendViewController alloc] init];
    vc.title = @"关注";
    
    //事件响应者链
    [self.viewController.navigationController pushViewController:vc
                                                        animated:YES];
    
    
    
}

- (void)followAction {
    
    //关注详情控制器
    FollowViewController *vc = [[FollowViewController alloc] init];
    
    vc.title = @"粉丝";
    //事件响应者链
    [self.viewController.navigationController pushViewController:vc
                                                        animated:YES];
    
}


@end
