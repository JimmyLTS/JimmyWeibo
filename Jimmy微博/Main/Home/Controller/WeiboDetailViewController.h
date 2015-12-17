//
//  WeiboDetailViewController.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/14.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboLayoutFrame.h"
#import "DetailTableView.h"
#import "SinaWeiboRequest.h"
#import "WXRefresh.h"

@interface WeiboDetailViewController : UIViewController<SinaWeiboRequestDelegate>

@property (nonatomic, strong) WeiboLayoutFrame *layoutFrame;

@property (nonatomic, assign) NSInteger *totalNumber;
@end
