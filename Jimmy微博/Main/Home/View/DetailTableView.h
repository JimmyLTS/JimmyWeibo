//
//  DetailTableView.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/14.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboLayoutFrame.h"

@interface DetailTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WeiboModel *weiboModel;

@property (nonatomic, copy)NSArray *commentArray;

@property (nonatomic, assign)NSInteger totalNumber;


@end
