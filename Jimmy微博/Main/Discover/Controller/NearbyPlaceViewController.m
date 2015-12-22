//
//  NearbyPlaceViewController.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/18.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "NearbyPlaceViewController.h"
#import "NetworkService.h"
#import "PositionModel.h"
#import "UIImageView+WebCache.h"

@interface NearbyPlaceViewController () {
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation NearbyPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //01、创建tableView
    [self _creatTableView];
    
    //02 定位
    [self _location];
}

#pragma mark - tableView
- (void)_creatTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"positionCell"];
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate、UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"positionCell" forIndexPath:indexPath];
    PositionModel *model = _dataArray[indexPath.row];
    
    cell.textLabel.text = model.title;
    
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"Icon"]];
    
    return cell;
}


#pragma mark - 定位
- (void)_location {
    
    if (_locationManager == nil) {
        
        //创建位置管理对象
        _locationManager = [[CLLocationManager alloc]init];
        if (ios8) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    
    _locationManager.delegate = self;
    
    [_locationManager setDistanceFilter:kCLLocationAccuracyBest];
    
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [_locationManager stopUpdatingLocation];
    
    CLLocation *location = locations.lastObject;
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    [self loadNearbyPositionWithLatitude:latitude Longitude:longitude];
}

#pragma mark - 网络获取附近地点
- (void)loadNearbyPositionWithLatitude:(NSString *)latitude Longitude:(NSString *)longitude {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setObject:latitude forKey:@"lat"];
    [params setObject:longitude forKey:@"long"];
    [params setObject:@"50" forKey:@"count"];
    
    [NetworkService requestDataWithURL:nearby_pois HTTPMethod:@"GET" params:params completionHandle:^(id result, NSURLResponse *response, NSError *error) {
        
        NSLog(@"%@", result);
        
        NSArray *array = result[@"pois"];
        NSMutableArray *modelArray = [[NSMutableArray alloc]init];
        
        for (NSDictionary *poisDic in array) {
            
            PositionModel *model = [[PositionModel alloc]initWithDataDic:poisDic];
            
            [modelArray addObject:model];
        }
        
        _dataArray = modelArray;
        [_tableView reloadData];
        
    }];
    
}

#if 0
//测试定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [_locationManager stopUpdatingLocation];
    
    CLLocation *location = locations.lastObject;
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"纬度：%f, 经度：%f",coordinate.latitude, coordinate.longitude);
    
    //地理位置反编码
    
    //方法一：微博接口 http://open.weibo.com/wiki/2/location/geo/geo_to_address
    
    NSString *coordinateStr = [NSString stringWithFormat:@"%f,%f",coordinate.longitude,coordinate.latitude];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setObject:coordinateStr forKey:@"coordinate"];
    
    [NetworkService requestDataWithURL:geo_to_address HTTPMethod:@"GET" params:params completionHandle:^(id result, NSURLResponse *response, NSError *error) {
        
        NSLog(@"%@", result);
        NSArray *geos = result[@"geos"];
        
        if (geos.count > 0) {
            NSDictionary *dic = [geos lastObject];
            
            NSString *addrs = dic[@"address"];
            NSLog(@"%@", addrs);
        }
        
    }];
    
    //方法二：官方反编码
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placeMark = [placemarks lastObject];
        
        NSLog(@"%@", placeMark.name);
    }];
    
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
