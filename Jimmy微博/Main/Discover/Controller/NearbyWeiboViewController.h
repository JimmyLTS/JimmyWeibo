//
//  NearbyWeiboViewController.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/19.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NetworkService.h"
#import "WeiboAnnotationView.h"
#import "WeiboDetailViewController.h"

@interface NearbyWeiboViewController : UIViewController<MKMapViewDelegate> {
    
    MKMapView *_mapView;
    CLLocationManager *_locationManager;
}

@end
