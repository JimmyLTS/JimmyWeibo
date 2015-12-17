//
//  TabBarButton.m
//  时光网
//
//  Created by imac on 15/10/31.
//  Copyright © 2015年 imac. All rights reserved.
//

#import "TabBarButton.h"
#import "ThemeManager.h"

@implementation TabBarButton

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
    //Image
    UIImage *normalImage = [manager getThemeImage:_normalImageName];
    UIImage *highlightImage = [manager getThemeImage:_highlightImageName];
    UIImage *selectImage = [manager getThemeImage:_selectImageName];
    //TitleColor
    UIColor *titleNormalColor = [manager getThemeColor:_normalTitleColorName];
    UIColor *titleHirhlightColor = [manager getThemeColor:_hightlightTitleColorName];
    // Set Image
    [self setImage:normalImage forState:UIControlStateNormal];
    [self setImage:selectImage forState:UIControlStateSelected];
    [self setImage:highlightImage forState:UIControlStateHighlighted];
    //Set Title Color
    [self setTitleColor:titleNormalColor forState:UIControlStateNormal];
    [self setTitleColor:titleHirhlightColor forState:UIControlStateHighlighted];
}

#pragma mark - 设置器方法

- (void)setNormalImageName:(NSString *)normalImageName {
    
    if (![_normalImageName isEqualToString:normalImageName]) {
        _normalImageName = [normalImageName copy];
        
        [self themeDidChange];
    }
}

- (void)setSelectImageName:(NSString *)selectImageName {
    
    if (![_selectImageName isEqualToString:selectImageName]) {
        _selectImageName = [selectImageName copy];
        
        [self themeDidChange];
    }
}

- (void)setHighlightImageName:(NSString *)highlightImageName {
    
    if (![_highlightImageName isEqualToString:highlightImageName]) {
        _highlightImageName = [highlightImageName copy];
        
        [self themeDidChange];
    }
}

- (void)setTextColorName:(NSString *)textColorName {
    if (![_normalTitleColorName isEqualToString:textColorName]) {
        _normalTitleColorName = [textColorName copy];
        
        [self themeDidChange];
    }
}

- (void)setHightlightTitleColorName:(NSString *)hightlightTitleColorName {
    if (![_hightlightTitleColorName isEqualToString:hightlightTitleColorName]) {
        _hightlightTitleColorName = [hightlightTitleColorName copy];
        
        [self themeDidChange];
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
