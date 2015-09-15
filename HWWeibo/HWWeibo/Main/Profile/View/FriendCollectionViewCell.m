//
//  FriendCollectionViewCell.m
//  HWWeibo
//
//  Created by hyrMac on 15/9/1.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "FriendCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "FriendModel.h"

@implementation FriendCollectionViewCell

- (void)awakeFromNib {
    // Initialization code

    _name.textAlignment =  NSTextAlignmentCenter;
    _name.font = [UIFont boldSystemFontOfSize:14];
    
    _follows.textAlignment = NSTextAlignmentCenter;
    _follows.font = [UIFont systemFontOfSize:12];
    
}

- (void)setModel:(FriendModel *)model {
    
    
    if (_model != model) {
        _model = model;
        [self setNeedsLayout];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSString *imgStr = _model.profileImageUrl;
    [_icon sd_setImageWithURL:[NSURL URLWithString:imgStr]];
    
    _name.text = _model.name;
    
    _follows.text = [NSString stringWithFormat:@"%@粉丝",_model.followersCount];
    
}

@end
