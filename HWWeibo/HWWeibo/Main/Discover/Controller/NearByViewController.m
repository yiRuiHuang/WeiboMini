//
//  NearByViewController.m
//  HWWeibo
//
//  Created by hyrMac on 15/9/2.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "NearByViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "DataService.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"
#import "WeiboModal.h"
#import "WeiboDetailViewController.h"
#import "WeiboView.h"
#import "WeiboViewLayout.h"

@interface NearByViewController () <CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    
    WeiboAnnotation *_weiboAnnotation;
    
    
    NSMutableArray *_weiboArray;
    
//    CLLocationCoordinate2D mycoor;
}

@end

@implementation NearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"附近微博";
    [self _createMapView];
    
    [self _location];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_createMapView {
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.mapType = MKMapTypeHybrid;
//    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    

    
//    NSMutableArray *weiboAnnotationArray = [NSMutableArray array];
//    
//  
//    for (WeiboModal *model in _weiboArray) {
//       WeiboAnnotation * boAnnotation = [[WeiboAnnotation alloc] init];
//        NSArray *locationArray = [model.geo objectForKey:@"coordinates"];
//        CLLocationCoordinate2D coordinate = {[locationArray[0] doubleValue],[locationArray[1] doubleValue]};
//        boAnnotation.coordinate = coordinate;
//        boAnnotation.model = model;
//        
//        [weiboAnnotationArray addObject:boAnnotation];
//    }
//    [_mapView addAnnotations:weiboAnnotationArray];
    
}

- (void)_addDataForView {
    _mapView.delegate = self;
    
    NSMutableArray *weiboAnnotationArray = [NSMutableArray array];
    
    
    for (WeiboModal *model in _weiboArray) {
        WeiboAnnotation * boAnnotation = [[WeiboAnnotation alloc] init];
        NSArray *locationArray = [model.geo objectForKey:@"coordinates"];
        CLLocationCoordinate2D coordinate = {[locationArray[0] doubleValue],[locationArray[1] doubleValue]};
        boAnnotation.coordinate = coordinate;
        boAnnotation.model = model;
        
        [weiboAnnotationArray addObject:boAnnotation];
    }
    [_mapView addAnnotations:weiboAnnotationArray];
}


#pragma mark -
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
//    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
//    if (pinView == nil) {
//        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
//    }
//    return pinView;
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    WeiboAnnotationView *pinView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
    
    if (pinView == nil) {
        pinView = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
    }
    
    pinView.annotation = annotation;
    
    return pinView;
    
}

//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//    
//    WeiboDetailViewController *detailVC = [[WeiboDetailViewController alloc] init];
//    
//    WeiboAnnotation *annoation = (WeiboAnnotation *)view.annotation;
//    WeiboModal *weiboModel = annoation.model;
//    
//    detailVC.weiboView.layoutFrame.weiboModal = weiboModel;
//    [self.navigationController pushViewController:detailVC animated:YES];
//
//}


- (void)_location {
    
    _locationManager = [[CLLocationManager alloc] init];
    
    if (kVersion > 8.0) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
}

//- (void)viewDidAppear:(BOOL)animated {
//    CLLocationCoordinate2D center = mycoor;
//    MKCoordinateSpan span = {0.1,0.1};
//    MKCoordinateRegion region = {center,span};
//    
//    [_mapView setRegion:region];
//}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    [_locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSString *lon = [NSString stringWithFormat:@"%f",coordinate.longitude];
    
    NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
    
    CLLocationCoordinate2D center = coordinate;
//    mycoor = coordinate;
    MKCoordinateSpan span = {0.1,0.1};
    MKCoordinateRegion region = {center,span};
    
    [_mapView setRegion:region];
    
    [self _sendLocation:lon lat:lat];
    
}


- (void)_sendLocation:(NSString *)lon lat:(NSString *)lat {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:lon forKey:@"long"];
    [params setValue:lat forKey:@"lat"];
    
    _weiboArray = [NSMutableArray array];
    __weak NearByViewController *weakSelf = self;
    [DataService requestAFUrl:nearby_timeline httpMethod:@"GET" params:params data:nil block:^(id result) {
//        NSLog(@"%@",result);
        __strong NearByViewController *strongSelf = weakSelf;
        NSArray *statuses = [result objectForKey:@"statuses"];
        
        for (NSDictionary *dict in statuses) {
            
            WeiboModal *model = [[WeiboModal alloc] initWithDataDic:dict];
            
            [_weiboArray addObject:model];
            
        }
//            [self _createMapView];
        [strongSelf _addDataForView];
        
    }];
    
    
   
}

@end









