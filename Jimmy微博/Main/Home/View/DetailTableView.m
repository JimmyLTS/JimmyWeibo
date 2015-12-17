//
//  DetailTableView.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/14.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "DetailTableView.h"
#import "ThemeManager.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"
#import "WeiboView.h"
#import "DetailCell.h"

@implementation DetailTableView {
    UIView *headerView;
    WeiboView *weiboView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:kDetailCell];
        self.separatorColor = [[ThemeManager shareManager] getThemeColor:@"More_Item_Line_color"];
        self.sectionHeaderHeight = 30;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:kDetailCell];
        self.separatorColor = [[ThemeManager shareManager] getThemeColor:@"More_Item_Line_color"];
        
        self.sectionHeaderHeight = 30;
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
    return _commentArray.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailCell forIndexPath:indexPath];
    
    cell.commentModel = self.commentArray[indexPath.row];
    
    return cell;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentModel *model = _commentArray[indexPath.row];
    
    CGFloat textHeight = [WXLabel getTextHeight:15 width:(kScreenWidth - 70) text:model.text linespace:5];
    
    return textHeight + 50 + 20;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    label.font = [UIFont systemFontOfSize:20];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = [NSString stringWithFormat:@" 评论：%li", self.totalNumber];
    return label;
}


#pragma mark - 创建HeaderView
- (void)_creatHeaderView {
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
    
    //用户头像
    UIImageView *userHdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    userHdImageView.layer.cornerRadius = 30;
    NSString *userHdImageString = self.weiboModel.usermodel.profile_image_url;
    NSURL *userHdImageUrl = [NSURL URLWithString:userHdImageString];
    [userHdImageView sd_setImageWithURL:userHdImageUrl placeholderImage:[UIImage imageNamed:@"Icon"]];
    [headerView addSubview:userHdImageView];
    
    //用户昵称
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 200, 25)];
    userNameLabel.text = self.weiboModel.usermodel.screen_name;
    userNameLabel.font = [UIFont systemFontOfSize:18];
    [headerView addSubview:userNameLabel];
    
    //来源：
    UILabel *sourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, 200, 20)];
    sourceLabel.text = self.weiboModel.source;
    sourceLabel.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:sourceLabel];
    
    //微博内容
    weiboView = [[WeiboView alloc]initWithFrame:CGRectZero];
    
    WeiboLayoutFrame *layoutFrame = [[WeiboLayoutFrame alloc]init];
    
    layoutFrame.isDetail = YES;
    
    layoutFrame.weiboModel = _weiboModel;
    
    weiboView.layoutFrame = layoutFrame;
    
    weiboView.frame = layoutFrame.frame;
    
    headerView.height = CGRectGetMaxY(weiboView.frame) + 10;
    
    [headerView addSubview:weiboView];
    
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        [self _creatHeaderView];
        
        self.tableHeaderView = headerView;

    }
}

@end
