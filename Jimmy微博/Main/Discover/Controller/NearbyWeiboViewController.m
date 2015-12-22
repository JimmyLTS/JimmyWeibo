//
//  NearbyWeiboViewController.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/19.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "NearbyWeiboViewController.h"
#import "WeiboAnnotation.h"

@interface NearbyWeiboViewController ()

@end

@implementation NearbyWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _creatMapView];
    
//    [self _creatAnnotationView];
}

- (void)_creatMapView {
    
    _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    
    _mapView.showsUserLocation = YES;
    
    _mapView.userLocation.title = @"我的位置";
    _mapView.mapType = MKMapTypeHybrid;
    
    _mapView.delegate = self;
    
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    [self.view addSubview:_mapView];
}

#pragma mark - 获取周边微博
- (void)_loadNearbyWeiboWithlong:(NSString *)longStr lat:(NSString *)latStr  {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:longStr forKey:@"long"];
    [params setObject:latStr forKey:@"lat"];
    [params setObject:@"50" forKey:@"count"];
    
    [NetworkService requestDataWithURL:nearby_timeline HTTPMethod:@"GET" params:params completionHandle:^(id result, NSURLResponse *response, NSError *error) {
        
        if ([result allObjects].count > 0) {
            NSArray *statuses = [result objectForKey:@"statuses"];
            
            NSMutableArray *annotationArray = [[NSMutableArray alloc]init];
            
            for (NSDictionary *modelDic in statuses) {
                WeiboModel *weiboModel = [[WeiboModel alloc]initWithDataDic:modelDic];
                if (![weiboModel.geo isEqual:[NSNull null]]) {
                    WeiboAnnotation *annotation = [[WeiboAnnotation alloc]init];
                    annotation.weiboModel = weiboModel;
                    
                    [annotationArray addObject:annotation];
                }
                
            }
            NSLog(@"%li", annotationArray.count);
            [_mapView addAnnotations:annotationArray];
        }
        
        
    }];
    
    
}

#pragma mark - MKMapViewDelegate

//开始定位
- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    NSLog(@"开始定位");
}

//停止定位
- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
    NSLog(@"停止定位");
}

//更新用户位置
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"更新定位");
    
    CLLocation *location = userLocation.location;
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度：%f,纬度：%f", coordinate.latitude,coordinate.longitude);
    
    //数字越小，显示区域越精确
    MKCoordinateSpan span = {0.1,0.1};
    CLLocationCoordinate2D center = coordinate;
    MKCoordinateRegion region = {center,span}; //中心坐标，参数
    
    [_mapView setRegion:region];
    
    NSString *longStr = [NSString stringWithFormat:@"%f", coordinate.longitude];
    NSString *latStr = [NSString stringWithFormat:@"%f", coordinate.latitude];
    
    [self _loadNearbyWeiboWithlong:longStr lat:latStr];
    
//    [self _creatAnnotationView];
    
}

//为标注提供视图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[WeiboAnnotation class]]) {
        WeiboAnnotationView *annotationView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
        if (annotationView == nil) {
            annotationView = [[WeiboAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
        }
        
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    return nil;
}

//当选中 AnnotationView 时，跳转到微博详情页面
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    WeiboDetailViewController *detailController = [[WeiboDetailViewController alloc]init];
    
    WeiboAnnotation *weiboAnnotation = (WeiboAnnotation *)view.annotation;
    
    WeiboLayoutFrame *layoutFrame = [[WeiboLayoutFrame alloc]init];
    
    layoutFrame.weiboModel = weiboAnnotation.weiboModel;
    
    detailController.layoutFrame = layoutFrame;
    
    [self.navigationController pushViewController:detailController animated:YES];
    
    [mapView deselectAnnotation:weiboAnnotation animated:YES];
}

//为 AnnotationView 显示添加动画
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    
    for (int i = 0; i < views.count; i++) {
        WeiboAnnotationView *annotationView = (WeiboAnnotationView *)views[i];
        
        if (![annotationView isKindOfClass:[WeiboAnnotationView class]]) {
            continue;
        }
        
        annotationView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        annotationView.alpha = 0;
        
        [UIView animateWithDuration:1 animations:^{
            
            [UIView setAnimationDelay:0.1 * i];
            annotationView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            annotationView.alpha = 1;
        
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.5 animations:^{
                annotationView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
            
        }];
        
        
    }
    
    
}

#if 0

- (void)_creatAnnotationView {
    
    WeiboAnnotation *annotation1 = [[WeiboAnnotation alloc]init];
    CLLocationCoordinate2D coordinate1 = {30.23,120.20};
    annotation1.coordinate = coordinate1;
    annotation1.title = @"Hello World";
    annotation1.subtitle = @"Today is sunny!";
    
    WeiboAnnotation *annotation2 = [[WeiboAnnotation alloc]init];
    CLLocationCoordinate2D coordinate2 = {30.13,120.20};
    annotation2.coordinate = coordinate2;
    annotation2.title = @"Hello China";
    annotation2.subtitle = @"Binjiang,Hangzhou,Zhejiang";
    
    [_mapView addAnnotations:@[annotation1,annotation2]];

}

//为标注提供视图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    //如果是用户定位信息，则使用默认标注视图
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotation"];
    }
    
    pinView.pinTintColor = [UIColor orangeColor];
    
    pinView.canShowCallout = YES;
    
    return pinView;
}

#endif

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
