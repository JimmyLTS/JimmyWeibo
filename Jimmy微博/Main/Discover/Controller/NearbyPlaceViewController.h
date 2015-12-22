//
//  NearbyPlaceViewController.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/18.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NearbyPlaceViewController :UIViewController <CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource> {
    
    CLLocationManager *_locationManager;
    CLLocation *_location;
    
}

@end
