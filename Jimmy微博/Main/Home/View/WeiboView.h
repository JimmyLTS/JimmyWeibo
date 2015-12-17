//
//  WeiboView.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/11.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"
#import "WeiboLayoutFrame.h"
#import "WXLabel.h"
#import "ZoomImageView.h"

@interface WeiboView : UIView<WXLabelDelegate>

@property (nonatomic,strong) WXLabel *textLabel; //原创微博
@property (nonatomic,strong) WXLabel *repostTextLabel;//被转发的微博
@property (nonatomic,strong) ZoomImageView *imageView;//微博图片
@property (nonatomic,strong) ThemeImageView *bgImageView;//背景图片


@property (nonatomic, strong) WeiboLayoutFrame *layoutFrame;

@end
