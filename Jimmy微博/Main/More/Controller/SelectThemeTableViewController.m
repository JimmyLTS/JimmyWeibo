//
//  SelectThemeTableViewController.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/10.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "SelectThemeTableViewController.h"
#import "ThemeManager.h"
#import "ThemeLabel.h"

@interface SelectThemeTableViewController () {
    NSDictionary *_configDic;
    NSArray *_configArray;
}

@end

@implementation SelectThemeTableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadThemeSources) name:kThemeChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadThemeSources) name:kThemeChangeNotification object:nil];

    }
    return self;
}

- (void)loadThemeSources {
    
    ThemeManager *manager = [ThemeManager shareManager];
    //背景颜色、分割线颜色
    self.tableView.backgroundColor = [manager getThemeColor:@"More_Item_color"];
    self.tableView.separatorColor = [manager getThemeColor:@"More_Item_Line_color"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self loadThemeSources];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"Theme" ofType:@"plist"];
    
    _configDic = [NSDictionary dictionaryWithContentsOfFile:configPath];
    _configArray = [_configDic allKeys];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _configArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"themeNameCell" forIndexPath:indexPath];
    
    cell.textLabel.text = _configArray[indexPath.row];
    
    cell.textLabel.textColor = [[ThemeManager shareManager] getThemeColor:@"More_Item_Text_color"];
    
    if ([cell.textLabel.text isEqualToString:[ThemeManager shareManager].themeName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [ThemeManager shareManager].themeName = cell.textLabel.text;
    
    [tableView reloadData];
    
    
}



@end
