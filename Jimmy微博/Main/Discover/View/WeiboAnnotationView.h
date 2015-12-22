//
//  WeiboAnnotationView.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/19.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "WeiboModel.h"
#import "WeiboAnnotation.h"
#import "UIImageView+WebCache.h"

@interface WeiboAnnotationView : MKAnnotationView {
    
    UIImageView *_userHdImageView;
    UILabel *_textLabel;
}

@end
