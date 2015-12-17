//
//  WeiboLayoutFrame.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/11.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboModel.h"
#import <UIKit/UIKit.h>

@interface WeiboLayoutFrame : NSObject

@property (nonatomic,assign) CGRect frame;//weiboView 布局
@property (nonatomic,assign) CGRect textFrame;//微博布局
@property (nonatomic,assign) CGRect rTextFrame;//转发微博布局
@property (nonatomic,assign) CGRect imageFrame;//微博图片布局
@property (nonatomic,assign) CGRect bgImageFrame;//背景图片布局

@property (nonatomic, strong)WeiboModel *weiboModel;

@property (nonatomic, assign)BOOL isDetail;

@end
