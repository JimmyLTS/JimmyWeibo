//
//  HomeViewController.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/7.
//  Copyright © 2015年 Jimmy. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import "BaseViewController.h"
#import "SinaWeiboRequest.h"

@interface HomeViewController : BaseViewController<SinaWeiboRequestDelegate>

- (void)loadWeiboNewData;
@end
