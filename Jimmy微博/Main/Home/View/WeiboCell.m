//
//  WeiboCell.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/10.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "WeiboCell.h"
#import "WeiboModel.h"
#import "ThemeLabel.h"
#import "UIImageView+WebCache.h"

@implementation WeiboCell

- (void)awakeFromNib {
    // Initialization code
    
    self.weiboView = [[WeiboView alloc]initWithFrame:CGRectZero];
    
    [self addSubview:_weiboView];
    
    //圆形头像
    _userHdImageView.layer.cornerRadius = _userHdImageView.frame.size.width/2;
    
    _layoutFrame.isDetail = 1000;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLayoutFrame:(WeiboLayoutFrame *)layoutFrame {
    if (_layoutFrame != layoutFrame) {
        _layoutFrame = layoutFrame;
        
        self.weiboView.layoutFrame = _layoutFrame;
        
        [self setNeedsLayout];
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    WeiboModel *_weiboModel = _layoutFrame.weiboModel;
    
    self.weiboView.frame = _layoutFrame.frame;
    
    _userNameLabel.text = _weiboModel.usermodel.screen_name;
    
    NSString *userHdImageString = _weiboModel.usermodel.profile_image_url;
    NSURL *userHdImageUrl = [NSURL URLWithString:userHdImageString];
    [_userHdImageView sd_setImageWithURL:userHdImageUrl placeholderImage:[UIImage imageNamed:@"Icon"]];
    //评论数
    _relayLabel.text = [NSString stringWithFormat:@"评论：%li", [_weiboModel.commentsCount integerValue]];
    //转发数
    _transmitLabel.text = [NSString stringWithFormat:@"转发：%li", [_weiboModel.repostsCount integerValue]];
    //来源
    _dataResource.text = _weiboModel.source;
}

@end
