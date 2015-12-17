//
//  WeiboDetailViewController.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/14.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "WeiboDetailViewController.h"
#import "ThemeManager.h"
#import "AppDelegate.h"
#import "CommentModel.h"

@interface WeiboDetailViewController (){
    SinaWeiboRequest *_request;
}

@property (nonatomic, strong)DetailTableView *detailTableView;
@property (nonatomic, copy)NSMutableArray *commentArray;

@end

@implementation WeiboDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"微博详情";
    UIImage *bgImage = [[ThemeManager shareManager] getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    
    //创建 TableView
    [self creatDetailTableView];
    
    //获取数据
    [self loadWeiboCommentNewData];
    
}

#pragma mark - 刷新页面
- (void)creatDetailTableView {
    //创建TableView
    _detailTableView = [[DetailTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    //传递数据
    _detailTableView.weiboModel = self.layoutFrame.weiboModel;
    
    [self.view addSubview:_detailTableView];
    
    //为TableView添加下拉刷新、上拉加载
    __weak WeiboDetailViewController *weakSelf = self;
    [_detailTableView addPullDownRefreshBlock:^{
        NSLog(@"下拉刷新");
        [weakSelf loadWeiboCommentNewData];
    }];
    
    [_detailTableView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"上拉加载");
        [weakSelf loadWeiboCommentOldData];
    }];
    
    //设置下拉刷新Title
    [_detailTableView.pullToRefreshView setTitle:@"正在刷新···" forState:PullDownRefreshStateLoading];
    [_detailTableView.pullToRefreshView setTitle:@"下拉刷新数据···" forState:PullDownRefreshStateStopped];
    [_detailTableView.pullToRefreshView setTitle:@"松手刷新数据···" forState:PullDownRefreshStateTriggered];
    
}

#pragma mark - 请求数据
- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

//加载新的微博数据
- (void)loadWeiboCommentNewData {
    // 注意bug: 在 http://open.weibo.com/wiki/2/place/nearby_timeline 接口中返回的微博id 类型为string ,以前是NSNumber，会导致在 跳转微博详情的时候数据解析错误
    // 以下用self.weiboModel.weiboIdStr
    
    SinaWeibo *sinaWeibo = [self sinaweibo];
        
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    if (_commentArray.count != 0) {
        CommentModel *model = _commentArray[0];
        NSString *str = model.commentId;
        [params setObject:str forKey:@"since_id"];
    }
    
    NSString *idStr = _layoutFrame.weiboModel.weiboIdStr;
    
    [params setObject:idStr forKey:@"id"];
    
    _request = [sinaWeibo requestWithURL:comments params:params  httpMethod:@"GET" delegate:self];
    
    _request.tag = 100;
    
}

//加载之前的评论
//加载新的微博数据
- (void)loadWeiboCommentOldData {
    SinaWeibo *sinaWeibo = [self sinaweibo];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    NSString *idStr = [_layoutFrame.weiboModel.weiboId stringValue];
    
    [params setObject:idStr forKey:@"id"];
    
    CommentModel *model = _commentArray.lastObject;
    if (model == nil) {
        
        return;
    }
    NSString *lastID = model.commentId ;
    [params setObject:lastID  forKey:@"max_id"];
    
    _request = [sinaWeibo requestWithURL:comments params:params  httpMethod:@"GET" delegate:self];
    
    _request.tag = 101;
}

//获取数据完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
//    NSLog(@"%@", result);
    
    [_detailTableView.pullToRefreshView stopAnimating];
    [_detailTableView.infiniteScrollingView stopAnimating];
    
    NSArray *dicarray = result[@"comments"];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *commentDic in dicarray) {
        CommentModel *commentModel = [[CommentModel alloc]initWithDataDic:commentDic];
        
        [tempArray addObject:commentModel];
    }
    
    if (tempArray.count == 0) {
        return;
    }
    
    if (_commentArray == nil) {
        _commentArray = tempArray;
    }else {
        //上拉刷新
        if (request.tag == 100) {
            NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(0, tempArray.count)];
        
            [_commentArray insertObjects:tempArray atIndexes:indexSet];
        
        }else if (request.tag == 101){
            //下拉加载
            if (tempArray.count > 1) {
                [tempArray removeObjectAtIndex:0];
                
                [_commentArray addObjectsFromArray:tempArray];
            }else {
                return;
            }
                    
        }
    }
    
    _detailTableView.commentArray = _commentArray;
    //评论个数获取
    NSNumber *total = [result objectForKey:@"total_number"];
    NSInteger count = [total integerValue];
    _detailTableView.totalNumber = count;
    [_detailTableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [_request disconnect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
