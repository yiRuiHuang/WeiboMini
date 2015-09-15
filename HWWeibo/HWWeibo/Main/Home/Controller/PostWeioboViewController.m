//
//  PostWeioboViewController.m
//  HWWeibo
//
//  Created by hyrMac on 15/8/29.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "PostWeioboViewController.h"
#import "ThemeButton.h"
#import "ThemeManager.h"
#import "DataService.h"
#import "MMDrawerController.h"
#import "ZoomImageView.h"
#import <CoreLocation/CoreLocation.h>
#import "BaseNavController.h"
#import "LocationDetailViewController.h"
#import "FaceScrollView.h"

@interface PostWeioboViewController () <ZoomImageViewDelegate,CLLocationManagerDelegate,FaceViewDelegate>
{
    UITextView *_textView;
    UILabel *_placeholderLabel;
    
    UIView *_editorBar;
    

    ZoomImageView *_imgView;
    UIImage *selectImg;
    
    
//    定位
    CLLocationManager *locationManager;
    
    
//  地理位置显示label
    UILabel *_locationLabel;
    
    
    // 表情面板
    
    FaceScrollView *_faceViewPanel;
    
}

@end

@implementation PostWeioboViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

// 添加键盘观察者
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [_textView becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发微博";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setNavItem];
    
    [self _createTextView];
    [self _createTabTool];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)_createTabTool {
    // 编辑工具栏
    _editorBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 55)];
    _editorBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editorBar];
    // 创建多个编辑按钮
    NSArray *imgs = @[
                      @"compose_toolbar_1.png",
                      @"compose_toolbar_4.png",
                      @"compose_toolbar_3.png",
                      @"compose_toolbar_5.png",
                      @"compose_toolbar_6.png"
                      ];
    for (int i=0; i<imgs.count; i++) {
        NSString *imgName = imgs[i];
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(15+(kScreenWidth/5)*i, 20, 40, 33)];
        [button addTarget:self action:@selector(buttonActionr:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10+i;
        button.normalImgName = imgName;
        [_editorBar addSubview:button];
    }

    
}

- (void)setNavItem {
    
    ThemeButton *button = [[ThemeButton alloc] init];
    button.frame = CGRectMake(0, 0, 40, 40);
    //    button.normalImgName = @"group_btn_all_on_title.png";
//    button.normalBgImgName = @"button_title.png";
    [button addTarget:self action:@selector(setCancelAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[[ThemeManager shareInstance] getThemeColor:@"Mask_Title_color"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    //    self.visibleViewController.navigationItem
    
    ThemeButton *button2 = [[ThemeButton alloc] init];
    button2.frame = CGRectMake(0, 0, 40, 40);
    //    button2.normalImgName = @"button_icon_plus.png";
//    button2.normalBgImgName = @"button_m.png";
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [button2 setTitle:@"发布" forState:UIControlStateNormal];
    [button2 setTitleColor:[[ThemeManager shareInstance] getThemeColor:@"Mask_Title_color"] forState:UIControlStateNormal];
    button2.enabled = NO;
    [button2 addTarget:self action:@selector(PostAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
}

- (void)_createTextView {

    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 120)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    _textView.editable = YES;
//    _textView.keyboardType = UIKeyboardTypeDefault;
    
    
    [self.view addSubview:_textView];
    [_textView becomeFirstResponder];
    
    
    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 68, 150, 21)];
    _placeholderLabel.text = @"分享新鲜事...";
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.font = [UIFont systemFontOfSize:14];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.enabled = NO;
    [self.view insertSubview:_placeholderLabel belowSubview:_textView];
    
    
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 30)];
    _locationLabel.hidden = YES;
    _locationLabel.numberOfLines = 0;
    _locationLabel.font = [UIFont boldSystemFontOfSize:12];
    
    [self.view addSubview:_locationLabel];


}


#pragma mark - navigationItemAction

- (void)PostAction {
    
    if (_textView.text.length > 140) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微博内容大于140字符" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }

    
    AFHTTPRequestOperation *operation = [DataService sendWeibo:_textView.text withImage:selectImg block:^(id result) {
        
        [self showStatusTip:@"发送成功" show:YES operation:nil];
        
    }];
    [self showStatusTip:@"正在发送..." show:YES operation:operation];
    
    
    [self setCancelAction];
    
}


- (void)setCancelAction {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([window.rootViewController isKindOfClass:[MMDrawerController class]]) {
        MMDrawerController *vc = (MMDrawerController *)window.rootViewController;
        [vc closeDrawerAnimated:YES completion:NULL];
    }
    [_textView resignFirstResponder];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - textViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![text isEqualToString:@""]) {
    
       _placeholderLabel.hidden = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        
        _placeholderLabel.hidden = NO;
        
    }
    
    return YES;
    
}

#pragma mark - 编辑按钮方法

- (void)buttonActionr:(UIButton *)button {
    
//    NSLog(@"%ld",button.tag);
    
    if (button.tag == 10) {
        
        [self selectImageSourse];
    } else if (button.tag == 13) {
        [self _location];
    }  else if(button.tag == 14) {  //显示、隐藏表情
        
        BOOL isFirstResponder = _textView.isFirstResponder;
        
        //输入框是否是第一响应者，如果是，说明键盘已经显示
        if (isFirstResponder) {
            //隐藏键盘
            [_textView resignFirstResponder];
            //显示表情
            [self _showFaceView];
            //隐藏键盘
            
        } else {
            //隐藏表情
            [self _hideFaceView];
            
            //显示键盘
            [_textView becomeFirstResponder];
        }
        
    }

    
}

#pragma mark - 表情处理

- (void)_showFaceView{
    
    //创建表情面板
    if (_faceViewPanel == nil) {
        
        
        _faceViewPanel = [[FaceScrollView alloc] init];
        [_faceViewPanel setFaceViewDelegate:self];
        //放到底部
        _faceViewPanel.top  = kScreenHeight-64;
        [self.view addSubview:_faceViewPanel];
    }
    
    //显示表情
    [UIView animateWithDuration:0.3 animations:^{
        
        _faceViewPanel.bottom = kScreenHeight;
        //重新布局工具栏、输入框
        _editorBar.bottom = _faceViewPanel.top;
        
    }];
}

//隐藏表情
- (void)_hideFaceView {
    
    //隐藏表情
    [UIView animateWithDuration:0.3 animations:^{
        _faceViewPanel.top = kScreenHeight-64;
        
    }];
    
}


- (void)faceDidSelect:(NSString *)text{
    NSLog(@"选中了%@",text);
    
}



#pragma mark - 地理定位

- (void)_location {
    
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
        if (kVersion > 8.0) {
            
            [locationManager requestWhenInUseAuthorization];
        }
    }
    
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    

}

#pragma mark - 
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    [locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    
    CLLocationCoordinate2D corrdinate = location.coordinate;
    
//    NSLog(@"%f,%f",corrdinate.longitude,corrdinate.latitude);
//    新浪地理位置反编码
    
    NSString *locationStr = [NSString stringWithFormat:@"%f,%f",corrdinate.longitude,corrdinate.latitude];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:locationStr forKey:@"coordinate"];
    
    __weak PostWeioboViewController *weakSelf = self;
    
    [DataService requestAFUrl:geo_to_address httpMethod:@"GET" params:params data:nil block:^(id result) {
        
        
        __strong PostWeioboViewController *strongSelf = weakSelf;
//        NSLog(@"%@",result);
        NSArray *geos = [result objectForKey:@"geos"];
        
        if (geos.count > 0) {
            NSDictionary *dic = [geos lastObject];
            NSString *locationName = [dic objectForKey:@"address"];
//            NSLog(@"%@",locationName);
            
            strongSelf->_locationLabel.hidden = NO;
            strongSelf->_locationLabel.text = locationName;
            strongSelf->_locationLabel.bottom = strongSelf->_editorBar.top;

        }
        
        
    }];
    
    
    
//    er、iOS自己内置的
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:location
//                   completionHandler:^(NSArray *placemarks, NSError *error) {
//        
//                       CLPlacemark *placeMark = [placemarks lastObject];
//                       NSLog(@"%@",placeMark.name);
//                       
//                       
//                       
//    }];
    
    
    
//    弹出附近商家等地理信息

    // 弹出控制器
    LocationDetailViewController *vc = [[LocationDetailViewController alloc] init];
    vc.locationStr = locationStr;
    // 创建导航控制器
    BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];

    
}


- (void)selectImageSourse {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    
    [sheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerControllerSourceType imgType;
    
    if (buttonIndex == 0) {//拍照
        
        imgType = UIImagePickerControllerSourceTypeCamera;
        
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"摄像头不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
    } else if (buttonIndex == 1){
        
        imgType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
    } else {
        return;
    }
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.sourceType = imgType;
    imgPicker.delegate = self;
    
    [self presentViewController:imgPicker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [_textView becomeFirstResponder];
//    NSLog(@"%@",info);
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (_imgView == nil) {
        _imgView = [[ZoomImageView alloc] initWithFrame:CGRectMake(10, _textView.bottom+10, 80, 80)];
        _imgView.image = img;
        _imgView.delegate = self;
        [self.view addSubview:_imgView];
    }
    _imgView.image = img;
    selectImg = img;
}



#pragma mark - 键盘通知处理

- (void)keyBoardWillShow:(NSNotification *)notification {

//    NSLog(@"%@",notification);
    
    // 获取键盘高度
    NSValue *bounsValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [bounsValue CGRectValue];
    
    CGFloat height = frame.size.height;
    
    
    _editorBar.bottom = kScreenHeight - height;
    
}

#pragma mark - ZoomImageViewDelegate

- (void)imageViewWillZoomIn:(ZoomImageView *)imgView {
    
    [_textView resignFirstResponder];
    
}

- (void)imageViewWillZoomOut:(ZoomImageView *)imgView {
    [_textView becomeFirstResponder];
}

@end
