//
//  WeiboView.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/11.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "WeiboView.h"
#import "UIImageView+WebCache.h"

@implementation WeiboView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self creatSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
    }
    return self;
}

- (void)creatSubView {
    
    _textLabel = [[WXLabel alloc]initWithFrame:CGRectZero];
    
    _textLabel.linespace = 5.0f;
    _textLabel.wxLabelDelegate = self;
    
    _repostTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    
    _repostTextLabel.linespace = 5.0;
    _repostTextLabel.wxLabelDelegate = self;
    
    _imageView = [[ZoomImageView alloc] initWithFrame:CGRectZero];
    _bgImageView = [[ThemeImageView alloc] initWithFrame:CGRectZero];
    
    _bgImageView.topCapHeight = 10;
    _bgImageView.leftCapWidth = 30;
    
    _bgImageView.imageName = @"timeline_rt_border_9.png";
    
    [self addSubview:_bgImageView];
    [self addSubview:_textLabel];
    [self addSubview:_repostTextLabel];
    [self addSubview:_imageView];
    
}

- (void)setLayoutFrame:(WeiboLayoutFrame *)layoutFrame {
    if (_layoutFrame != layoutFrame) {
        _layoutFrame = layoutFrame;
        
        [self setNeedsLayout];
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    WeiboModel *_weiboModel = _layoutFrame.weiboModel;
    
//    self.frame = _layoutFrame.frame;
    _textLabel.font = [UIFont systemFontOfSize:FontSize_Weibo(_layoutFrame.isDetail)];
    _repostTextLabel.font = [UIFont systemFontOfSize:FontSize_ReWeibo(_layoutFrame.isDetail)];
    
    
    _textLabel.frame = _layoutFrame.textFrame;
    _textLabel.text = _weiboModel.text;
    
    _repostTextLabel.frame = _layoutFrame.rTextFrame;
    _repostTextLabel.text = _weiboModel.repostWeiboModel.text;
    
    _bgImageView.frame = _layoutFrame.bgImageFrame;
    
    //判断是否转发
    if (_weiboModel.repostWeiboModel == nil) {
        
        //未转发，显示自己微博的图片
        if (_weiboModel.thumbnailImage != nil) {
            _imageView.hidden = NO;
            
            _imageView.frame = _layoutFrame.imageFrame;
            
            NSURL *url = [NSURL URLWithString:_weiboModel.thumbnailImage];
            
            NSString *fullUrl = _weiboModel.originalImage;
            _imageView.fullUrlString = fullUrl;
            
            if (_layoutFrame.isDetail) {
                url = [NSURL URLWithString:_weiboModel.bmiddlelImage];
            }
            
            [_imageView sd_setImageWithURL:url];
        }
        else
            _imageView.hidden = YES;
        
    }else {
        
        if (_weiboModel.repostWeiboModel.thumbnailImage != nil) {
            _imageView.hidden = NO;
            //转发带图片，显示转发中的图片
            _imageView.frame = _layoutFrame.imageFrame;
            NSURL *url = [NSURL URLWithString:_weiboModel.repostWeiboModel.thumbnailImage];
            
            NSString *fullUrl = _weiboModel.repostWeiboModel.originalImage;
            _imageView.fullUrlString = fullUrl;
            
            if (_layoutFrame.isDetail) {
                url = [NSURL URLWithString:_weiboModel.repostWeiboModel.bmiddlelImage];
            }
            
            [_imageView sd_setImageWithURL:url];
        }else
            _imageView.hidden = YES;
    }
    
    NSString *extersion;
    _imageView.gifImageView.frame = CGRectMake(_imageView.width - 25, _imageView.height - 15, 25, 15);
    
    if (_imageView.hidden == NO) {
        if (_weiboModel.repostWeiboModel == nil) {
            extersion = [_weiboModel.thumbnailImage pathExtension];
        }else {
            extersion = [_weiboModel.repostWeiboModel.thumbnailImage pathExtension];
        }
    }
    
    if ([extersion isEqualToString:@"gif"]) {
        _imageView.gifImageView.hidden = NO;
    }else {
        _imageView.gifImageView.hidden = YES;
    }
    
}

#pragma mark - WXLabel Delegate
//返回用于处理高亮文字的正则表达式
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    //需要高亮的：@用户  链接   话题
    
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([a-zA-Z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)", regex1, regex2, regex3];
    
    return regex;
}

//手指离开当前超链接文本响应的协议方法
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context {
    NSLog(@"%@", context);
}

//手指接触当前超链接文本响应的协议方法
- (void)toucheBenginWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context {
    
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    
    return [UIColor orangeColor];
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {
    return [UIColor purpleColor];
}
//检索文本中图片的正则表达式的字符串 1.png 2.png  [兔子]
//- (NSString *)imagesOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
//    
//}


@end
