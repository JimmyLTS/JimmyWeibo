//
//  WeiboTabelView.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/10.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "WeiboTabelView.h"
#import "WeiboCell.h"
#import "WeiboDetailViewController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "ThemeManager.h"
#import "UIView+UIViewController.h"
#import "AppDelegate.h"

@implementation WeiboTabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:kWeiboCell bundle:nil] forCellReuseIdentifier:kWeiboCell];
        self.separatorColor = [[ThemeManager shareManager] getThemeColor:@"More_Item_Line_color"];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:@"WeiboCell" bundle:nil] forCellReuseIdentifier:kWeiboCell];
        self.separatorColor = [[ThemeManager shareManager] getThemeColor:@"More_Item_Line_color"];
    }
    return self;
}

#pragma mark - TableView delegate 和 datasource

//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _weiboDataArray.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:kWeiboCell forIndexPath:indexPath];
    
    cell.layoutFrame = self.weiboDataArray[indexPath.row];
    
    return cell;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeiboLayoutFrame *layoutFrame = _weiboDataArray[indexPath.row];
    
    CGFloat cellHeight = layoutFrame.frame.size.height + 80;
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaweibo;
    
    if (![sinaWeibo isAuthValid]) {
        [sinaWeibo logIn];
    }
    
    HomeViewController *home = (HomeViewController *)self.viewController;
    WeiboDetailViewController *weiboDetailController = [[WeiboDetailViewController alloc]init];
    
    weiboDetailController.layoutFrame = _weiboDataArray[indexPath.row];
    [weiboDetailController setHidesBottomBarWhenPushed:YES];
    
    [home.navigationController pushViewController:weiboDetailController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
