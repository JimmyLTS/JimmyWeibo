//
//  ThemeLabel.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/9.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeChangeNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeChangeNotification object:nil];
}

- (void)themeDidChange {
    
    ThemeManager *manager = [ThemeManager shareManager];
    
    UIColor *color = [manager getThemeColor:_textColorName];
    
    self.textColor = color;
    
}

- (void)setTextColorName:(NSString *)textColorName {
    
    if (![_textColorName isEqualToString:textColorName]) {
        _textColorName = [textColorName copy];
        
        [self themeDidChange];
    }
}

@end
