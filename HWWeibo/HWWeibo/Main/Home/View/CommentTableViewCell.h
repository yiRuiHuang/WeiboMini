//
//  CommentTableViewCell.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/28.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"

@class CommentModel;
@class ThemeLabel;

@interface CommentTableViewCell : UITableViewCell <WXLabelDelegate>

/**
 *  @property (weak, nonatomic) IBOutlet UIImageView *profileImageView;  // 作者头像
 @property (weak, nonatomic) IBOutlet ThemeLabel *screenName;
 */

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;  // 评论者头像
@property (weak, nonatomic) IBOutlet ThemeLabel *screenName;  //评论者昵称


@property (weak, nonatomic) IBOutlet WXLabel *commentContentLabel;  // 评论内容



@property (nonatomic, strong) CommentModel *model;
@end
