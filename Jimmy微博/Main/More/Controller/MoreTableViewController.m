//
//  MoreTableViewController.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/10.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "MoreTableViewController.h"
#import "ThemeManager.h"
#import "ThemeLabel.h"
#import "ThemeImageView.h"
#import "AppDelegate.h"

@interface MoreTableViewController ()

@property (weak, nonatomic) IBOutlet ThemeImageView *clearImage;
@property (weak, nonatomic) IBOutlet ThemeImageView *suggestImage;
@property (weak, nonatomic) IBOutlet ThemeImageView *manageImage;
@property (weak, nonatomic) IBOutlet ThemeImageView *themeImage;

@property (weak, nonatomic) IBOutlet ThemeLabel *cacheLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *themeNameLabel;


@property (weak, nonatomic) IBOutlet ThemeLabel *themeSelectLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *manageLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *suggestLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *clearCacheLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *logoutLabel;

@end

@implementation MoreTableViewController

- (void)viewWillAppear:(BOOL)animated {
    
    ThemeManager *manager = [ThemeManager shareManager];
    //背景颜色、分割线颜色
    self.tableView.backgroundColor = [manager getThemeColor:@"More_Item_color"];
    self.tableView.separatorColor = [manager getThemeColor:@"More_Item_Line_color"];
    
    //主题名称、缓存 文字颜色
    _cacheLabel.textColor = [manager getThemeColor:@"More_Item_Text_color"];
    _themeNameLabel.textColor = [manager getThemeColor:@"More_Item_Text_color"];
    
    //选择主题、清除缓存、管理、注销、建议 文字颜色
    _themeSelectLabel.textColor = [manager getThemeColor:@"More_Item_Text_color"];
    _clearCacheLabel.textColor = [manager getThemeColor:@"More_Item_Text_color"];
    _logoutLabel.textColor = [manager getThemeColor:@"More_Item_Text_color"];
    _manageLabel.textColor = [manager getThemeColor:@"More_Item_Text_color"];
    _suggestLabel.textColor = [manager getThemeColor:@"More_Item_Text_color"];
    
    //图标
    _themeImage.imageName = @"more_icon_theme.png";
    _manageImage.imageName = @"more_icon_account.png";
    _suggestImage.imageName = @"more_icon_feedback.png";
    _clearImage.imageName = @"more_icon_draft.png";
    
    //主题名字
    _themeNameLabel.text = manager.themeName;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        SinaWeibo *sinaWeibo = appDelegate.sinaweibo;
        
        if ([_logoutLabel.text isEqualToString:@"注销登录"]) {
            [sinaWeibo logOut];
            _logoutLabel.text = @"登录";
        }else {
            _logoutLabel.text = @"注销登录";
            
            [sinaWeibo logIn];
        }
        
        
        
    }
}

/*
 图标： more_icon_theme.png
 more_icon_account.png
 more_icon_feedback.png
 more_icon_draft.png
 文字：More_Item_Text_color
 页面背景颜色：  More_Item_color
 页面分割线颜色：More_Item_Line_color

*/

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
