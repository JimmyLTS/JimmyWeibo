//
//  LeftDrawerViewController.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/10.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "LeftDrawerViewController.h"
#import "ThemeManager.h"

@interface LeftDrawerViewController () {
    
    UITableView *_tableView;
    
    NSArray *_array;
}

@end

@implementation LeftDrawerViewController

- (void)viewWillAppear:(BOOL)animated {
    
    if(_tableView != nil) {
        [_tableView reloadData];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _creatTableView];
}

- (void)_creatTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight - 70) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    _array = @[@"界面切换效果",@"无",@"偏移",@"偏移&缩放",@"旋转",@"视差",@"图片浏览模式",@"小图",@"大图"];
    
    _tableView.rowHeight = 40;
    
    _tableView.sectionHeaderHeight = 50;
    
    _tableView.bounces = NO;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = _array[indexPath.row + 1];
        cell.textLabel.textColor = [[ThemeManager shareManager] getThemeColor:@"More_Item_Text_color"];
    }else {
        cell.textLabel.text = _array[indexPath.row + 7];
        cell.textLabel.textColor = [[ThemeManager shareManager] getThemeColor:@"More_Item_Text_color"];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return _array[0];
    }
    
    return _array[6];
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
