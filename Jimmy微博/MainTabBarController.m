//
//  MainTabBarController.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/7.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "MainTabBarController.h"
#import "TabBarButton.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"
#import "AppDelegate.h"

@interface MainTabBarController () {
    ThemeImageView *_tabBarBgImageView;
    ThemeImageView *_tabArrowImageView;
    
    ThemeImageView *_badgeView; //提示未读消息
    ThemeLabel *_badgeLabel;
}

@end

@implementation MainTabBarController

#pragma mark - 创建子控制器
- (void)_creatSubViewController {
    
    NSArray *nameArray = @[@"HomeStoryboard",@"MessageStoryboard",@"ProfileStoryboard",@"DiscoverStoryboard",@"MoreStoryboard"];
    NSMutableArray *navArray = [[NSMutableArray alloc]init];
    for (NSString *name in nameArray) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
        UINavigationController *nav = [storyboard instantiateInitialViewController];
        [navArray addObject:nav];
    }
    
    self.viewControllers = navArray;
    
}

#pragma mark - 自定义tabBar
- (void)_customTabBar {
    
    //1、移除tabBarButton
    for (UIView *view in self.tabBar.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:class]) {
            [view removeFromSuperview];
        }
    }
    
    //2、创建 TabBarView
    _tabBarBgImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    _tabBarBgImageView.imageName = @"mask_navbar.png";
    [self.tabBar addSubview:_tabBarBgImageView];
    
    NSArray *namesArray = @[
                            @"home_tab_icon_1.png",
                            @"home_tab_icon_2.png",
                            @"home_tab_icon_3.png",
                            @"home_tab_icon_4.png",
                            @"home_tab_icon_5.png",
                            ];
    
    CGFloat imageWidth = kScreenWidth/namesArray.count;
    
    _tabArrowImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, 49)];
    _tabArrowImageView.imageName = @"home_bottom_tab_arrow.png";
    [self.tabBar addSubview:_tabArrowImageView];
    
    for (int i = 0; i < namesArray.count; i++) {
        
        NSString *name = namesArray[i];
        
        TabBarButton *button = [TabBarButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(imageWidth * i, 0, imageWidth, 49);
        button.tag = i;
        button.normalImageName = name;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tabBar addSubview:button];
    }
    
}

//按钮点击事件
- (void)buttonAction:(UIButton *)button {
    
    self.selectedIndex = button.tag;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _tabArrowImageView.center = button.center;

    }];
    
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //01、创建子控制器
    [self _creatSubViewController];
    //02、自定义tabBar
    [self _customTabBar];
    
    //03、开定时器请求未读信息
//    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 定时器
- (void)timerAction:(NSTimer *)timer {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    SinaWeibo *sinaWeibo = appDelegate.sinaweibo;
    
    [sinaWeibo requestWithURL:unread_count params:nil httpMethod:@"GET" delegate:self];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    CGFloat buttonWidth = kScreenWidth/5;
    
    
    if (_badgeView == nil) {
        _badgeView = [[ThemeImageView alloc] initWithFrame:CGRectMake(buttonWidth-32, 0, 32, 32)];
        _badgeView.imageName = @"number_notify_9.png";
        [self.tabBar addSubview:_badgeView];
        
        
        _badgeLabel = [[ThemeLabel alloc] initWithFrame:_badgeView.bounds];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.font = [UIFont systemFontOfSize:13];
        _badgeLabel.textColorName = @"Timeline_Notice_color";
        [_badgeView addSubview:_badgeLabel];
        
    }
    NSNumber *status = result[@"status"];
    NSInteger count = [status integerValue];
    if (count > 0) {
        _badgeView.hidden = NO;
        if (count > 99) {
            _badgeLabel.text = @"...";
        }else {
            _badgeLabel.text = [NSString stringWithFormat:@"%li", count];
        }
    }else {
        _badgeView.hidden = YES;
    }
    
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}


@end
