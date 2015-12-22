//
//  BaseViewController.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/7.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
//通过activityView显示提示
- (void)showLoading:(BOOL)show;
- (void)setNavBarItem;

//通过三方显示提示
- (void)showHUD:(NSString *)title;
- (void)hideHUD;
- (void)completeHUD:(NSString *)title;
@end
