//
//  AppDelegate.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/7.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "LeftDrawerViewController.h"
#import "RightDrawerViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "WeiboDetailViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@", NSHomeDirectory());
    // Override point for customization after application launch.
    self.sinaweibo = [[SinaWeibo alloc]initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    
    //1、创建tabBarController
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    
    MainTabBarController *mainTabBarController = [[MainTabBarController alloc]init];
    
    LeftDrawerViewController *leftViewController = [[LeftDrawerViewController alloc]init];
    RightDrawerViewController *rightViewContoller = [[RightDrawerViewController alloc]init];
    
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:mainTabBarController
                                             leftDrawerViewController:leftViewController
                                             rightDrawerViewController:rightViewContoller];
    
    [drawerController setMaximumRightDrawerWidth:80.0];
    [drawerController setMaximumLeftDrawerWidth:200.0];
    
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    MMDrawerControllerDrawerVisualStateBlock block = [MMDrawerVisualState swingingDoorVisualStateBlock];
    
    [drawerController setDrawerVisualStateBlock:block];
    
    self.window.rootViewController = drawerController;
    
    
    //2、从沙河中读取数据
    [self readAuthData];
    
    return YES;
}


#pragma mark - SinaWeiboDelegate
//新浪微博登录代理
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
    
    NSLog(@"登陆成功");
    
    [self storeAuthData];
    
    MMDrawerController *draw = (MMDrawerController *)self.window.rootViewController;
    
    MainTabBarController *main = (MainTabBarController *)draw.centerViewController;
    NSArray *vcArray = main.viewControllers;
    
    BaseNavigationController *base = (BaseNavigationController *)vcArray[0];
    
    UIViewController *last = base.viewControllers.lastObject;
    
    if ([last isKindOfClass:[HomeViewController class]]) {
        HomeViewController *h = (HomeViewController *)last;
        [h loadWeiboNewData];
    }else if ([last isKindOfClass:[WeiboDetailViewController class]]) {
        WeiboDetailViewController *detail = (WeiboDetailViewController *)last;
        [detail loadWeiboCommentNewData];
    }
    
    
}



//新浪微博注销代理
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo {
    
    NSLog(@"注销成功");
    
}

//存储账号信息
- (void)storeAuthData {
    SinaWeibo *sinaWeibo = self.sinaweibo;
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaWeibo.accessToken,@"AccessTokenKey",
                              sinaWeibo.expirationDate,@"ExpirationDateKey",
                              sinaWeibo.userID,@"UserIDKey",
                              sinaWeibo.refreshToken,@"refresh_token",nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"JimmyWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//重复登录，读取账号信息
- (void)readAuthData {
    
    NSDictionary *authData = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"JimmyWeiboAuthData"];
    
    if ([authData objectForKey:@"AccessTokenKey"] && [authData objectForKey:@"ExpirationDateKey"] && [authData objectForKey:@"UserIDKey"]) {
        self.sinaweibo.accessToken = [authData objectForKey:@"AccessTokenKey"];
        self.sinaweibo.userID = [authData objectForKey:@"UserIDKey"];
        self.sinaweibo.expirationDate = [authData objectForKey:@"ExpirationDateKey"];
    }
    
}


//新浪微博注销代理

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
