//
//  BaseViewController.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/7.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerController.h"
#import "AppDelegate.h"
#import "UIViewExt.h"
#import "MBProgressHUD.h"

@interface BaseViewController () {
    MBProgressHUD *_hud;//三方加载提示视图
}
@property (nonatomic, strong) UIView *tipView;
@end

@implementation BaseViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadThemeResources) name:kThemeChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadThemeResources) name:kThemeChangeNotification object:nil];
    }
    return self;
}

- (void)loadThemeResources {
    
    ThemeManager *manager = [ThemeManager shareManager];
    
    UIImage *bgImage = [manager getThemeImage:@"bg_home.jpg"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadThemeResources];
    [self setNavBarItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建 navBarItem
- (void)setNavBarItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setAction)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
}

- (void)setAction {
    MMDrawerController *mmDrawCtrl = self.mm_drawerController;
    
//    [mmDrawCtrl openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        mmDrawCtrl = (MMDrawerController*) appDelegate.window.rootViewController;
        [mmDrawCtrl openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)editAction {
    MMDrawerController *mmDrawCtrl = self.mm_drawerController;
    
    [mmDrawCtrl openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    
}

#pragma mark - 加载初始数据时的提示
- (void)showLoading:(BOOL)show {
    
    if(_tipView == nil) {
        
        _tipView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight/2 - 15, kScreenWidth, 30)];
        
        _tipView.backgroundColor = [UIColor clearColor];
        
        //1、loading视图
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [_tipView addSubview:activityView];
        
        //2、label
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"玩命加载中...";
        label.textColor = [UIColor blackColor];
        
        [label sizeToFit]; //自适应大小
        [_tipView addSubview:label];
        
        //3、设置位置
        label.left = (kScreenWidth - label.width)/2;
        activityView.right = label.left - 5;
    }
    if (show) {
        [self.view addSubview:_tipView];
    }else {
        if (_tipView.superview) {
            [_tipView removeFromSuperview];
        }
    }
}

#pragma  mark - 通过三方显示加载数据时的提示

- (void)showHUD:(NSString *)title {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud show:YES];
    _hud.labelText = title;
//    _hud.detailsLabelText = @"详情文字";
    _hud.dimBackground = YES;
}

- (void)hideHUD{
    
    [_hud hide:YES];
    
}
- (void)completeHUD:(NSString *)title{
    
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    //自定义视图
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    
    //延迟隐藏
    [_hud hide:YES afterDelay:1];
}




@end
