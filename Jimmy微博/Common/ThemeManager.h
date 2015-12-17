//
//  ThemeManager.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/9.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeManager : NSObject

@property (nonatomic, copy)NSString *themeName;

+ (instancetype)shareManager;

- (UIImage *)getThemeImage:(NSString *)themeImageName;
- (UIColor *)getThemeColor:(NSString *)colorName;

@end
