//
//  WeiboAnnotation.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/19.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    
    _coordinate = newCoordinate;
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
    }
    
    NSDictionary *geo = _weiboModel.geo;
    
    NSArray *coordinates = geo[@"coordinates"];
    
    if (coordinates.count >= 2) {
        
        NSNumber *longitude = coordinates[1];
        NSNumber *latitude = coordinates[0];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        
        _coordinate = coordinate;
    }
    
}

@end
