//
//  ThemeImageView.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/9.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _topCapHeight = 0.0;
        _leftCapWidth = 0.0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction) name:kThemeChangeNotification object:nil];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _leftCapWidth = 0.0;
    _topCapHeight = 0.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction) name:kThemeChangeNotification object:nil];
}

- (void)themeChangeAction {
    //重新获取图片，imageName,拼接路径
    //manager 中提供接口：通过图片名字得到图片
    
    [self loadImage];
    
}

- (void)loadImage {
    //获取ThemeManager
    ThemeManager *manager = [ThemeManager shareManager];
    
    UIImage *image = [[manager getThemeImage:_imageName] stretchableImageWithLeftCapWidth:_leftCapWidth topCapHeight:_topCapHeight];
    
    //设置图片
    self.image = image;

}

- (void)setImageName:(NSString *)imageName {
    if (![_imageName isEqualToString:imageName]) {
        _imageName = [imageName copy];
        
        [self loadImage];
    }
}

- (void)dealloc {
    //ARC中不需要调用 [super dealloc] 
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
