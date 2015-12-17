//
//  WeiboCell.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/10.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboView.h"
#import "WeiboLayoutFrame.h"

@class ThemeLabel;

@class WeiboModel;

@interface WeiboCell : UITableViewCell

@property (nonatomic, strong) WeiboLayoutFrame *layoutFrame;

@property (weak, nonatomic) IBOutlet UIImageView *userHdImageView;

@property (weak, nonatomic) IBOutlet ThemeLabel *relayLabel;   //回复
@property (weak, nonatomic) IBOutlet ThemeLabel *transmitLabel; //转发
@property (weak, nonatomic) IBOutlet ThemeLabel *userNameLabel; //用户名
@property (weak, nonatomic) IBOutlet ThemeLabel *dataResource;

@property (nonatomic, strong) WeiboView *weiboView;

@end
