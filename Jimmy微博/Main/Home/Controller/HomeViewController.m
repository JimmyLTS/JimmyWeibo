//
//  HomeViewController.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/7.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ThemeImageView.h"
#import "ThemeManager.h"
#import "TabBarButton.h"
#import "ThemeLabel.h"
#import "WeiboTabelView.h"
#import "WeiboLayoutFrame.h"
#import "WXRefresh.h"
#import "UIViewExt.h"


@interface HomeViewController ()
@property (nonatomic, copy) NSMutableArray *weiboDataArray;
@property (nonatomic, strong) WeiboTabelView *weiboTableView;
@property (nonatomic, strong) ThemeImageView *barImageView;
@property (nonatomic, strong) ThemeLabel *barLabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //使tabelView 从导航栏下端开始
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _weiboTableView = [[WeiboTabelView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    
    [self.view addSubview:_weiboTableView];
    
    [self _loginWeibo];
    
//    [self loadWeiboNewData];
    
    [self refreshHomeData];
    
}

#pragma mark - 刷新页面
- (void)refreshHomeData {
    
    __weak HomeViewController *weakSelf = self;
    [_weiboTableView addPullDownRefreshBlock:^{
        NSLog(@"下拉刷新");
        __strong HomeViewController *strong = weakSelf;
        [strong loadWeiboNewData];
    }];
    
    [_weiboTableView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"上拉加载");
        [weakSelf loadWeiboOldData];
    }];

    //设置下拉刷新Title
    [_weiboTableView.pullToRefreshView setTitle:@"正在刷新···" forState:PullDownRefreshStateLoading];
    [_weiboTableView.pullToRefreshView setTitle:@"下拉刷新数据···" forState:PullDownRefreshStateStopped];
    [_weiboTableView.pullToRefreshView setTitle:@"松手刷新数据···" forState:PullDownRefreshStateTriggered];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 登录微博
- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)_loginWeibo {
    
    SinaWeibo *sinaWeibo = [self sinaweibo];
    
    if ([sinaWeibo isAuthValid]) {
        NSLog(@"已经登陆");
        
        [self loadWeiboNewData];
    }else {
        [sinaWeibo logIn];
    }
    
}


#pragma mark - 获取微博数据
//加载新的微博数据
- (void)loadWeiboNewData {
//    [self showLoading:YES];
    
    [self showHUD:@"正在加载。。。"];
    
    SinaWeibo *sinaWeibo = [self sinaweibo];
    
    if ([sinaWeibo isAuthValid]) {
        NSLog(@"已经登陆");
    
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        
        if (_weiboDataArray.count != 0) {
            WeiboLayoutFrame *layoutFrame = _weiboDataArray[0];
            NSString *idStr = layoutFrame.weiboModel.weiboIdStr;
            
            [params setObject:idStr forKey:@"since_id"];
        }
        
        [params setObject:@"5" forKey:@"count"];
        
        SinaWeiboRequest *request = [sinaWeibo requestWithURL:home_timeline params:[params mutableCopy]  httpMethod:@"GET" delegate:self];
        
        request.tag = 100;
        
    }else {
        [sinaWeibo logIn];
        
    }
}

//加载以前的微博数据
- (void)loadWeiboOldData {
//    [self showLoading:YES];
    
    SinaWeibo *sinaWeibo = [self sinaweibo];
    
    if ([sinaWeibo isAuthValid]) {
        NSLog(@"已经登陆");
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        
        if (_weiboDataArray.count != 0) {
            WeiboLayoutFrame *layoutFrame = _weiboDataArray.lastObject;
            NSString *idStr = layoutFrame.weiboModel.weiboIdStr;
            
            [params setObject:idStr forKey:@"max_id"];
        }
        
        [params setObject:@"5" forKey:@"count"];
        
        SinaWeiboRequest *request = [sinaWeibo requestWithURL:home_timeline params:[params mutableCopy]  httpMethod:@"GET" delegate:self];
        
        request.tag = 101;
        
    }else {
        [sinaWeibo logIn];
    }
    
}

#pragma mark - 获取数据完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
//    NSLog(@"%@", result);
//    [self showLoading:NO];
    
   [self completeHUD:@"加载完成!"];
//     [self hideHUD];
    
    [_weiboTableView.pullToRefreshView stopAnimating];
    [_weiboTableView.infiniteScrollingView stopAnimating];
    
    NSArray *dicarray = result[@"statuses"];
    NSMutableArray *weiboTempArray = [[NSMutableArray alloc]initWithCapacity:dicarray.count];
    
    for (NSDictionary *weiboDic in dicarray) {
        WeiboModel *weiboModel = [[WeiboModel alloc]initWithDataDic:weiboDic];
        WeiboLayoutFrame *layoutFrame = [[WeiboLayoutFrame alloc]init];

        layoutFrame.weiboModel = weiboModel;
        
        [weiboTempArray addObject:layoutFrame];
    }
    
    if (weiboTempArray.count == 0) {
        return;
    }
    
    if (_weiboDataArray == nil) {
        _weiboDataArray = weiboTempArray;
    }else {
        //上拉刷新
        if (request.tag == 100) {
            [self showNewWeiboCount:weiboTempArray.count];
            
            NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(0, weiboTempArray.count)];
            
            [_weiboDataArray insertObjects:weiboTempArray atIndexes:indexSet];
            
        }else {
            //下拉加载
            if (weiboTempArray.count > 1) {
                [weiboTempArray removeObjectAtIndex:0];
                [_weiboDataArray addObjectsFromArray:weiboTempArray];
            }else {
                return;
            }
            
        }
        
    }
    
    
    _weiboTableView.weiboDataArray = _weiboDataArray;
    [_weiboTableView reloadData];
}

#pragma mark - 刷新时显示提示消息
- (void)showNewWeiboCount:(NSInteger)count {
    
    if(_barImageView == nil) {
        _barImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(10, -40, kScreenWidth - 20, 40)];
        _barImageView.imageName = @"timeline_notify.png";
        [self.view addSubview:_barImageView];
        
        _barLabel = [[ThemeLabel alloc]initWithFrame:_barImageView.bounds];
        _barLabel.textColorName = @"Timeline_Notice_color";
        _barLabel.textAlignment = NSTextAlignmentCenter;
        _barLabel.backgroundColor = [UIColor clearColor];
        [_barImageView addSubview:_barLabel];
    
    }
    if (count > 0) {
        _barLabel.text = [NSString stringWithFormat:@"更新了%li条微博", count];
        [UIView animateWithDuration:0.6 animations:^{
            _barImageView.transform = CGAffineTransformMakeTranslation(0, 40);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.6 animations:^{
                //停留1秒
                [UIView setAnimationDelay:1];
                _barImageView.transform = CGAffineTransformIdentity;
            }];
            
        }];
    }
    
    //播放声音 播放系统声音
    NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //impor <AcdioToolbox/AcdioToolbox.h>
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
    AudioServicesPlaySystemSound(soundId);
}


@end
