//
//  FriendViewController.m
//  HWWeibo
//
//  Created by hyrMac on 15/9/1.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "FriendViewController.h"
#import "DataService.h"
#import "FriendModel.h"
#import "FriendCollectionViewCell.h"

@interface FriendViewController ()
{
    NSMutableArray *_data;
    
    UICollectionView *_collectionView;
}

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.      friendships_friends
    
    [self _createCollectionView];
    
    [self _loadData];
}


- (void)_loadData {
    
    
    _data = [NSMutableArray array];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"LeoWellv" forKey:@"screen_name"];
    
    __weak FriendViewController *weakSelf = self;
    
    [DataService requestUrl:friendships_friends httpMethod:@"GET" params:params block:^(id result) {
        
        
        __strong FriendViewController *strongSelf = weakSelf;
        
        NSArray * users = [result objectForKey:@"users"];
        
        for (NSDictionary *dict in users) {
            
            FriendModel *model = [[FriendModel alloc] initWithDataDic:dict];
            
            
            [strongSelf->_data addObject:model];
            
        }
        
        
        [_collectionView reloadData];
    }];
    
}



- (void)_createCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth-40)/3, (kScreenWidth-40)/3*1.2);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_collectionView];
    
    UINib *nib = [UINib nibWithNibName:@"FriendCollectionViewCell" bundle:[NSBundle mainBundle]];
    
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"friendItem"];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _data.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"friendItem" forIndexPath:indexPath];
    
    cell.model = _data[indexPath.row];
    
    
    return cell;
    
    
    
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
