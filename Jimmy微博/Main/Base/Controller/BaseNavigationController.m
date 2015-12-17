//
//  BaseNavigationController.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/7.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"
#import "TabBarButton.h"

@interface BaseNavigationController ()



@end

@implementation BaseNavigationController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadThemeResources) name:kThemeChangeNotification object:nil];
    }
    return self;
}

- (void)loadThemeResources {
    
    //设置 NavigationBar 背景图片
    ThemeManager *manager = [ThemeManager shareManager];
    UIImage *image = [manager getThemeImage:@"mask_titlebar64.png"];
    if (!ios7) {
        image = [manager getThemeImage:@"mask_titlebar.png"];
    }
    
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //设置 navigationBar 的 title 颜色
    UIColor *navTitleColor = [manager getThemeColor:@"Mask_Title_color"];
    
    self.navigationBar.titleTextAttributes = @{
                                               NSForegroundColorAttributeName:navTitleColor
                                               };
    self.navigationBar.tintColor = navTitleColor;
}

// 释放通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadThemeResources];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
