//
//  DetailCell.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/14.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "DetailCell.h"
#import "UIImageView+WebCache.h"

@implementation DetailCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _commentTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _commentTextLabel.wxLabelDelegate = self;
    
    _commentUserHdImageView.layer.cornerRadius = 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //评论用户头像
    NSString *userHdImageString = _commentModel.userModel.profile_image_url;
    NSURL *userHdImageUrl = [NSURL URLWithString:userHdImageString];
    [_commentUserHdImageView sd_setImageWithURL:userHdImageUrl placeholderImage:[UIImage imageNamed:@"Icon"]];
    
    //评论用户名
    _commentUserLabel.text = _commentModel.userModel.screen_name;
    
    //评论文字
    
    _commentTextLabel.linespace = 5.0;
    NSString *textStr = _commentModel.text;
    CGFloat textWidth = kScreenWidth - 70;
    
    CGFloat textHeight = [WXLabel getTextHeight:15 width:textWidth text:textStr linespace:5];
    _commentTextLabel.frame = CGRectMake(60, 40, textWidth, textHeight + 30);
    _commentTextLabel.text = textStr;

    [self addSubview:_commentTextLabel];
}

- (void)setCommentModel:(CommentModel *)commentModel {
    if (_commentModel != commentModel) {
        _commentModel = commentModel;
        
        [self setNeedsLayout];
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
    NSLog(@"%@", context);
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    return [UIColor orangeColor];
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {
    return [UIColor purpleColor];
}

@end
