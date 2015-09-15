//
//  MoreTableViewCell.h
//  HWWeibo
//
//  Created by hyrMac on 15/8/21.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreModal.h"
#import "ThemeLabel.h"
#import "ThemeImageView.h"

@interface MoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ThemeImageView *iconImageView;
@property (weak, nonatomic) IBOutlet ThemeLabel *contentLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *themeLabel;

@property (nonatomic, strong) MoreModal *modal;
@end
