//
//  FriendCollectionViewCell.h
//  HWWeibo
//
//  Created by hyrMac on 15/9/1.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendModel;

@interface FriendCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *follows;


@property (nonatomic, strong) FriendModel *model;

@end
