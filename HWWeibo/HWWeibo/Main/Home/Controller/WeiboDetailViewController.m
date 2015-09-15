//
//  WeiboDetailViewController.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/28.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "WeiboDetailViewController.h"
#import "WeiboView.h"
#import "WeiboViewLayout.h"
#import "ThemeLabel.h"
#import "UIImageView+WebCache.h"
#import "WeiboModal.h"
#import "UserMoal.h"
#import "UIViewExt.h"
#import "CommentTableViewCell.h"
#import "AppDelegate.h"
#import "CommentModel.h"
#import "MJRefresh.h"

@interface WeiboDetailViewController () <SinaWeiboRequestDelegate>
{
    UITableView *_commentTableView;
    NSMutableArray *_data;
}
@end

@implementation WeiboDetailViewController



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.hidesBottomBarWhenPushed = YES;
        self.view.backgroundColor = [UIColor clearColor];
        
        self.navigationItem.title = @"微博正文";
        
         _data = [NSMutableArray array];
        
    }
    return self;
}


- (void)setLayoutFrame:(WeiboViewLayout *)layoutFrame {
    if (_layoutFrame != layoutFrame) {
        
        _layoutFrame = layoutFrame;
        _layoutFrame.isDetail = YES;
        
        [self _createWeibo];
        [self _createCommentTableView];
        [self _loadWeiboData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self _createWeibo];
//    [self _createCommentTableView];
    
    
}

#pragma mark - createSubViews

- (void)_createWeibo {
    
    WeiboModal *_modal = _layoutFrame.weiboModal;
//---------------------------------------------------------------
    // WeiboCellView 的高度计算
    _WeiboCellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    
    // 内容集合体
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    WeiboViewLayout *layoutframe = [[WeiboViewLayout alloc] init];
    layoutframe.isDetail = YES;
    layoutframe.weiboModal = _modal;
    _weiboView.layoutFrame = layoutframe;
    _weiboView.frame = layoutframe.weiboViewfame;
    
    [_WeiboCellView addSubview:_weiboView];
    
    CGRect weiboViewfame = layoutframe.weiboViewfame;
    CGFloat height = weiboViewfame.size.height + 60;

    
    _WeiboCellView.bounds = CGRectMake(0, 0, kScreenWidth, height);
    _WeiboCellView.backgroundColor = [UIColor clearColor];
    self.WeiboCellView.backgroundColor = [UIColor clearColor];
//-----------------------------------------------------------------
    
    
    // 用户头像
    NSString *profileStr = _modal.userMoal.profile_image_url;
    _profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 45, 45)];
    [_profileImageView sd_setImageWithURL:[NSURL URLWithString:profileStr]];
    [_WeiboCellView addSubview:_profileImageView];
    
    // 用户昵称
    _screenName = [[ThemeLabel alloc] initWithFrame:CGRectMake(69, 8, 130, 21)];
    _screenName.text = _modal.userMoal.screen_name;
    _screenName.font = [UIFont boldSystemFontOfSize:14];
    _screenName.colorName = @"Timeline_Name_color";
    [_WeiboCellView addSubview:_screenName];
    
    
    
}

- (void)_createCommentTableView {
    
    _commentTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    _commentTableView.backgroundColor = [UIColor clearColor];
    _commentTableView.tableHeaderView = _WeiboCellView;
    
    
    [_commentTableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"commentCell"];
    
    [self.view addSubview:_commentTableView];
    
    
    _commentTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _commentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
}

#pragma mark - 下载评论数据

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)_loadNewData {
    SinaWeibo * sina = [self sinaweibo];
    if ([sina isAuthValid]) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"20" forKey:@"count"];//idstr
//        [params setObject:_layoutFrame.weiboModal.weiboId.stringValue forKey:@"id"];
        [params setObject:_layoutFrame.weiboModal.idstr forKey:@"id"];
        WeiboModal *weiboModal = _data[0];
        if (weiboModal != nil) {
            
            [params setObject:weiboModal.weiboId.stringValue forKey:@"since_id"];
        }
        
        SinaWeiboRequest *request = [sina requestWithURL:comments
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
        [params setObject:@"20" forKey:@"count"];
//        [params setObject:_layoutFrame.weiboModal.weiboId.stringValue forKey:@"id"];
        [params setObject:_layoutFrame.weiboModal.idstr forKey:@"id"];
        
        WeiboModal *weiboModal = [_data lastObject];
        if (weiboModal != nil) {
            
            [params setObject:weiboModal.weiboId.stringValue forKey:@"max_id"];
        }
        
        SinaWeiboRequest *request = [sina requestWithURL:comments
                                                  params:params
                                              httpMethod:@"GET"
                                                delegate:self];
        
        request.tag = 102;
        
    }
}

- (void)_loadWeiboData {
    SinaWeibo * sina = [self sinaweibo];
    
    if ([sina isAuthValid]) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"20" forKey:@"count"];
//        [params setObject:_layoutFrame.weiboModal.weiboId.stringValue forKey:@"id"];
        [params setObject:_layoutFrame.weiboModal.idstr forKey:@"id"];
        
        SinaWeiboRequest *request = [sina requestWithURL:comments
                                                  params:params
                                              httpMethod:@"GET"
                                                delegate:self];
        
        
        request.tag = 100;
        
    } else {
        [sina logIn];
    }
}

#pragma  mark  - <SinaWeiboRequestDelegate>
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    NSLog(@"-----commenTloadingWithResult");
    
    NSArray *commentsArray = [result objectForKey:@"comments"];

     NSMutableArray *modalArray = [[NSMutableArray alloc] initWithCapacity:commentsArray.count];
    
    for (NSDictionary *dataDic in commentsArray) {
        
        WeiboModal *weiboModal = [[WeiboModal alloc] initWithDataDic:dataDic];
       
        [modalArray addObject:weiboModal];
    }

    if (request.tag == 100) {
        
        _data = modalArray;
        
    } else if (request.tag == 101) {
        
        if (modalArray.count > 0) {
            
            NSRange range = NSMakeRange(0, modalArray.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [_data insertObjects:modalArray atIndexes:indexSet];
            
            
        }
        
    } else if (request.tag == 102) {
        
        if (modalArray.count > 1) {
            [modalArray removeObjectAtIndex:0];
            [_data addObjectsFromArray:modalArray];
        } else if (modalArray.count == 1) {
            [modalArray removeObjectAtIndex:0];
        }
        
    }
    
    if (modalArray.count > 0) {
        [_commentTableView reloadData];
    }
    
    [_commentTableView.footer endRefreshing];
    [_commentTableView.header endRefreshing];
    
}




#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    cell.model = _data[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    
    
//    12 转发
    ThemeLabel *label1 = [[ThemeLabel alloc] initWithFrame:CGRectMake(15, 5, 60, 20)];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = [NSString stringWithFormat:@"%@ 转发",_layoutFrame.weiboModal.repostsCount];
    label1.font = [UIFont boldSystemFontOfSize:14];
    label1.colorName = @"Timeline_Name_color";
    
//     4 评论
    ThemeLabel *label2 = [[ThemeLabel alloc] initWithFrame:CGRectMake(90, 5, 60, 20)];
    label2.backgroundColor = [UIColor clearColor];
    label2.text = [NSString stringWithFormat:@"%@ 评论",_layoutFrame.weiboModal.commentsCount];
    label2.font = [UIFont boldSystemFontOfSize:14];
    label2.colorName = @"Timeline_Name_color";
    
//     8 赞
    ThemeLabel *label3 = [[ThemeLabel alloc] initWithFrame:CGRectMake(kScreenWidth-60, 5, 50, 20)];
    label3.backgroundColor = [UIColor clearColor];
    label3.text = [NSString stringWithFormat:@"%@ 赞",_layoutFrame.weiboModal.attitudesCount];
    label3.font = [UIFont boldSystemFontOfSize:14];
    label3.colorName = @"Timeline_Name_color";
    
    [headerView addSubview:label1];
    [headerView addSubview:label2];
    [headerView addSubview:label3];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat maxLabelWidth = 216;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    
    CommentModel *model = _data[indexPath.row];
    CGSize contentSize = [model.text boundingRectWithSize:CGSizeMake(maxLabelWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
   return  contentSize.height+70;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
