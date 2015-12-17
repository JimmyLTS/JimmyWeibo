//
//  WeiboTabelView.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/10.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboTabelView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *weiboDataArray;

@end
