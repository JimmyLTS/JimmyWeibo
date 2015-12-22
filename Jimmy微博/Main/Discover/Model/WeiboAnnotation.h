//
//  WeiboAnnotation.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/19.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiboModel.h"

@interface WeiboAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// Title and subtitle for use by selection UI.
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;
@property (nonatomic, strong) WeiboModel *weiboModel;
// Called as a result of dragging an annotation view.
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
