//
//  RightDrawerViewController.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/10.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "RightDrawerViewController.h"
#import "SendWeiboViewController.h"
#import "ThemeManager.h"
#import "TabBarButton.h"
#import "BaseNavigationController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface RightDrawerViewController ()

@end

@implementation RightDrawerViewController

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [[ThemeManager shareManager]getThemeColor:@"Timeline_Content_color"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatEditButton];
}

//添加微博编辑按钮
- (void)creatEditButton {
    
    for (int i = 0; i < 5; i++) {
        TabBarButton *editButton = [TabBarButton buttonWithType:UIButtonTypeCustom];
        editButton.frame = CGRectMake( 20, 64 + 60 * i, 50, 50);
        editButton.normalImageName = [NSString stringWithFormat:@"newbar_icon_%i",i+1];

        editButton.tag = i;
        [self.view addSubview:editButton];
        
        [editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)editButtonAction:(TabBarButton *)button {
    
    if (button.tag == 0) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            
            //弹出发送微博控制器
            
            BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:[[SendWeiboViewController alloc]init]];
            
            [self.mm_drawerController presentViewController:nav animated:YES completion:nil];
            
        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
