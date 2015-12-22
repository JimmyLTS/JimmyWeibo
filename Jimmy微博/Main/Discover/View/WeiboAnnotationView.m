
//
//  WeiboAnnotationView.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/19.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "WeiboAnnotationView.h"

@implementation WeiboAnnotationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        self.bounds = CGRectMake(0, 0, 100, 40);
        [self _creatSubviews];
    }
    return self;
}

- (void)_creatSubviews {
    
    _userHdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self addSubview:_userHdImageView];
    
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 60, 40)];
    _textLabel.backgroundColor = [UIColor lightGrayColor];
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.numberOfLines = 0;
    [self addSubview:_textLabel];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    WeiboAnnotation *annotation = self.annotation;
    WeiboModel *weiboModel = annotation.weiboModel;
    
    NSString *urlStr = weiboModel.usermodel.profile_image_url;
    [_userHdImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"Icon"]];
    
    _textLabel.text = weiboModel.usermodel.screen_name;
    
}

@end
