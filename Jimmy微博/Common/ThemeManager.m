//
//  ThemeManager.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/9.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager {
    
    NSDictionary *_themeFigDic;
    NSDictionary *_colorFigDic;
    
}

//初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        //01 设置默认主题
        
        _themeName = [[NSUserDefaults standardUserDefaults] objectForKey:ThemeNameKey];
        if (_themeName == nil) {
            _themeName = @"Cat";
        }
        
        //02 读取主题配置文件： 主题名字 对应的 路径
        NSString *themeFigPath = [[NSBundle mainBundle] pathForResource:@"Theme" ofType:@"plist"];
        
        _themeFigDic = [NSDictionary dictionaryWithContentsOfFile:themeFigPath];
        
    }
    return self;
}

#pragma mark - 创建单例对象 manager
+ (instancetype)shareManager {
    
    static ThemeManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self allocWithZone:nil]init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [super allocWithZone:zone];
    
}

- (id)copy {
    return self;
}

// 复写
- (void)setThemeName:(NSString *)themeName {
    if (![_themeName isEqualToString:themeName]) {
        _themeName = [themeName copy];
        
        //发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeChangeNotification object:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:_themeName forKey:ThemeNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

//简单实现
//- (UIImage *)getThemeImage:(NSString *)themeImageName {
//    
//    NSString *imageFullName = [NSString stringWithFormat:@"Skins/%@/%@", _themeName, themeImageName];
//    
//    NSLog(@"%@", imageFullName);
//    
//    UIImage *image = [UIImage imageNamed:imageFullName];
//    
//    return image;
//}

//根据完整路径获取图片
- (UIImage *)getThemeImage:(NSString *)themeImageName {
    
    //拼接图片完整路径
    NSString *themeImagePath = [[self getThemeBundlePath] stringByAppendingPathComponent:themeImageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:themeImagePath];
    
    return image;
    
}

//获取主题颜色
- (UIColor *)getThemeColor:(NSString *)colorName {
    
    //02 获取颜色配置文件
    NSString *themePath = [self getThemeBundlePath];
    NSString *colorFigPath = [themePath stringByAppendingPathComponent:@"config.plist"];
    _colorFigDic = [NSDictionary dictionaryWithContentsOfFile:colorFigPath];
    
    
    NSDictionary *RGBDic = _colorFigDic[colorName];
    
    CGFloat r = [RGBDic[@"R"] floatValue];
    CGFloat g = [RGBDic[@"G"] floatValue];
    CGFloat b = [RGBDic[@"B"] floatValue];
    NSNumber *alpha = RGBDic[@"alpha"];
    
    if (alpha == nil) {
        alpha = @1;
    }
    
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:[alpha floatValue]];
    
    return color;
}

//获取主题包的路径
- (NSString *)getThemeBundlePath {
    
    //01 获取资源包根目录路径
    NSString *boundlePath = [[NSBundle mainBundle] resourcePath];
    
    //02 在theme.plist 文件中找到对应的 子路径 Skins/cat
    NSString *subPath = [_themeFigDic objectForKey:_themeName];
    
    //03 拼接出完整路径
    NSString *themeFullPath = [boundlePath stringByAppendingPathComponent:subPath];
    return themeFullPath;
}

@end
