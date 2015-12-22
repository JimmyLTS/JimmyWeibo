//
//  ZoomImageView.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/16.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIViewExt.h"

@class ZoomImageView;
@protocol ZoomImageViewDelegate <NSObject>

- (void)imageViewWillZoomIn:(ZoomImageView *)imageView;
- (void)imageViewWillZoomOut:(ZoomImageView *)imageView;

@end


@interface ZoomImageView : UIImageView<UIScrollViewDelegate,NSURLConnectionDataDelegate,NSURLSessionDataDelegate,UIAlertViewDelegate> {
    
    NSMutableData *_fullImageData; //图片数据
    CGFloat _dataLength; //数据总长度
    
    MBProgressHUD *_hud;//进度条
}

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)UIImageView *fullImageView;

@property (nonatomic, copy)NSString *fullUrlString;

@property (nonatomic, strong)UIImageView *gifImageView;

@property (nonatomic, weak)id<ZoomImageViewDelegate> delegate;
@end
