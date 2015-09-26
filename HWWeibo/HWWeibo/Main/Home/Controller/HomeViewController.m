//
//  HomeViewController.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/19.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ThemeManager.h"
#import "WeiboModal.h"
#import "WeiboTableView.h"
#import "WeiboViewLayout.h"
#import "MJRefresh.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MBProgressHUD.h"
#import "WeiboDetailViewController.h"

@interface HomeViewController () <SinaWeiboRequestDelegate,MBProgressHUDDelegate>
{
    WeiboTableView *_weiboTableView;
    NSMutableArray *_data;
    ThemeImageView *_barNewImageView;
    ThemeLabel *_barNewLabel;
    
    MBProgressHUD *HUD; // 菊花
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _data = [NSMutableArray array];
    
    [self setRootNavItem];
    self.navigationItem.title = @"HOME";
    [self _createTableView];
//    [self _loadWeiboData];
    [self _showMBProgress];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDetailWeibo:) name:PushDetailWeiboVC  object:nil];
    
}


- (void)_createTableView {
//    _weiboTableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-49-64)];
    _weiboTableView = [[WeiboTableView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:_weiboTableView];
    
    _weiboTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _weiboTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)_loadNewData {
    
    
    SinaWeibo * sina = [self sinaweibo];
    if ([sina isAuthValid]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"10" forKey:@"count"];
        
        WeiboViewLayout *layoutFrame = _data[0];
        if (layoutFrame != nil) {
            WeiboModal *modal = layoutFrame.weiboModal;
            [params setObject:modal.weiboId.stringValue forKey:@"since_id"];
        }
        
        SinaWeiboRequest *request = [sina requestWithURL:@"statuses/home_timeline.json"
                                                  params:params
                                              httpMethod:@"GET"
                                                delegate:self];
        
        request.tag = 101;
        
    }
}

- (void)_loadMoreData {
    SinaWeibo * sina = [self sinaweibo];
    if ([sina isAuthValid]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"10" forKey:@"count"];
        
        WeiboViewLayout *layoutFrame = [_data lastObject];
        if (layoutFrame != nil) {
            WeiboModal *modal = layoutFrame.weiboModal;
            [params setObject:modal.weiboId.stringValue forKey:@"max_id"];
        }
       
        SinaWeiboRequest *request = [sina requestWithURL:@"statuses/home_timeline.json"
                                                  params:params
                                              httpMethod:@"GET"
                                                delegate:self];
       
        request.tag = 102;
        
    }
}

- (void)_loadWeiboData {
    SinaWeibo * sina = [self sinaweibo];
    
    if ([sina isAuthValid]) {
        
        SinaWeiboRequest *request = [sina requestWithURL:@"statuses/home_timeline.json"
                      params:[NSMutableDictionary dictionaryWithObject:@"16" forKey:@"count"]
                  httpMethod:@"GET"
                    delegate:self];
        //https://open.weibo.cn/2/statuses/home_timeline.json?count=1&access_token=2.00t2JbxBZPXQhCf43df84d31MAhsaD
        request.tag = 100;
        
    } else {
        [sina logIn];
     
    }
}



#pragma  mark  - <SinaWeiboRequestDelegate>
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    NSLog(@"-----FinishLoadingWithResult");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DidFinishRefreshNotification object:self];
    
    NSArray *statuses = [result objectForKey:@"statuses"];

    NSMutableArray *layoutFrameArray = [[NSMutableArray alloc] initWithCapacity:statuses.count];
    for (NSDictionary *dataDic in statuses) {
        WeiboModal *weiboModal = [[WeiboModal alloc] initWithDataDic:dataDic];
        WeiboViewLayout *layoutFrame = [[WeiboViewLayout alloc] init];
        layoutFrame.weiboModal = weiboModal;
        
        [layoutFrameArray addObject:layoutFrame];
    }
    
    if (request.tag == 100) {
        
        _data = layoutFrameArray;
        
    } else if (request.tag == 101) {
        
        if (layoutFrameArray.count > 0) {
            
            NSRange range = NSMakeRange(0, layoutFrameArray.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [_data insertObjects:layoutFrameArray atIndexes:indexSet];
            
            // 更新微博提示
            [self _updatePrompt:layoutFrameArray.count];
            
        }
        
    } else if (request.tag == 102) {
        
        if (layoutFrameArray.count > 1) {
            [layoutFrameArray removeObjectAtIndex:0];
            [_data addObjectsFromArray:layoutFrameArray];
        } else if (layoutFrameArray.count == 1) {
            [layoutFrameArray removeObjectAtIndex:0];
        }
        
    }
    
    if (layoutFrameArray.count > 0) {
        _weiboTableView.layoutFrameArray = _data;
        [_weiboTableView reloadData];
    }
    

    [_weiboTableView.footer endRefreshing];
    [_weiboTableView.header endRefreshing];
    
    // complete
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.5];
}


// 更新微博提示
- (void)_updatePrompt:(NSInteger)count {
    if (_barNewImageView == nil) {
        _barNewImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(5, -40, kScreenWidth-10, 40)];
        
        _barNewImageView.imgName = @"timeline_notify.png";
        
        [self.view addSubview:_barNewImageView];
        
        
        _barNewLabel = [[ThemeLabel alloc] initWithFrame:_barNewImageView.bounds];
        _barNewLabel.backgroundColor = [UIColor clearColor];
        _barNewLabel.textAlignment = NSTextAlignmentCenter;
        _barNewLabel.colorName = @"Timeline_Notice_color";
        
        
        [_barNewImageView addSubview:_barNewLabel];
        
    }
    
    if (count > 0) {
        _barNewLabel.text = [NSString stringWithFormat:@"%ld条新微博",count];
        
        [UIView animateWithDuration:0.6 animations:^{
            _barNewImageView.transform = CGAffineTransformMakeTranslation(0, 110);
        } completion:^(BOOL finished) {
            if (finished) {
               [UIView animateWithDuration:0.6 animations:^{
                   [UIView setAnimationDelay:1];
                   _barNewImageView.transform = CGAffineTransformIdentity;
               }];
            }
        }];
        
        // 注册系统声音
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
        
        AudioServicesPlaySystemSound(soundId);
    }
}


#pragma  mark -  第一次加载的菊花
- (void)_showMBProgress {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    HUD.dimBackground = YES;
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];

    

    // 刷新完成
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:HUD];

    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = @"Completed";
    
    
}

// 在菊花显示时，下载数据
- (void)myTask {
    
    __block HomeViewController *this = self;
    dispatch_sync(dispatch_get_main_queue(), ^{
        [this _loadWeiboData];
//        [NSThread sleepForTimeInterval:1];
    });
    
//    self.navigationController pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>
}





#pragma mark -  弹出微博详情页面
- (void)pushDetailWeibo:(NSNotification *)notification {
    WeiboDetailViewController *detailVC = [[WeiboDetailViewController alloc] init];
    
//    NSLog(@"%@",notification);
    detailVC.layoutFrame = [notification.userInfo objectForKey:@"weiboViewLayout"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
   
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
