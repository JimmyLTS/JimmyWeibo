//
//  WeiboLayoutFrame.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/11.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "WeiboLayoutFrame.h"
#import "WXLabel.h"


@implementation WeiboLayoutFrame {
    CGFloat weiboViewWidth;
}

- (void)setWeiboModel:(WeiboModel *)weiboModel{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        //计算各控件frame
        [self _caculateFrame];
    }
}


- (void)_caculateFrame {
    weiboViewWidth = 0;
    CGFloat weiboTextFont = FontSize_Weibo(self.isDetail);
    CGFloat reWeiboTextFont = FontSize_ReWeibo(self.isDetail);
    
    if (self.isDetail) {
        weiboViewWidth = kScreenWidth;
        _frame = CGRectMake(0, 70, kScreenWidth, 0);
    }else {
        //1、weiboView的坐标及宽度
        weiboViewWidth = kScreenWidth - 70;
        
        _frame = CGRectMake(60, 35, weiboViewWidth, 0);
    }
    
    //2、原创微博内容宽度
    CGFloat textWidth = weiboViewWidth - 20;
    NSString *text = self.weiboModel.text;

    CGFloat textHeight = [WXLabel getTextHeight:weiboTextFont width:textWidth text:text linespace:5];
    _textFrame = CGRectMake(10, 10, textWidth, textHeight);
    
    //3、判断是否有转发
    if (self.weiboModel.repostWeiboModel == nil) {
        //无转发
        //判断是否有图片
        if (self.weiboModel.thumbnailImage != nil) {
            if (_isDetail) {
                CGFloat imageX = kScreenWidth/2 - 80;
                
                CGFloat imageY = CGRectGetMaxY(self.textFrame) + 10;
                
                self.imageFrame = CGRectMake(imageX, imageY, 160, 160);
                
                _frame.size.height = CGRectGetMaxY(self.imageFrame) + 10;
            }else {
                CGFloat imageX = CGRectGetMinX(self.textFrame);
                
                CGFloat imageY = CGRectGetMaxY(self.textFrame) + 10;
                
                self.imageFrame = CGRectMake(imageX, imageY, 80, 80);
                
                _frame.size.height = CGRectGetMaxY(self.imageFrame) + 10;
            }
            
        }else {
            _frame.size.height = CGRectGetMaxY(self.textFrame) + 10;

        }
        
    }else {
        
        //转发微博背景
        CGFloat bgImageX = CGRectGetMinX(self.textFrame);
        CGFloat bgImageY = CGRectGetMaxY(self.textFrame) + 10;
        
        _bgImageFrame = CGRectMake(bgImageX, bgImageY, textWidth, 0);
        
        //转发微博文字
        NSString *rText = self.weiboModel.repostWeiboModel.text;
        CGFloat rTextWidth = textWidth - 20;
        CGFloat rTextHeight = [WXLabel getTextHeight:reWeiboTextFont width:rTextWidth text:rText linespace:5];
        _rTextFrame = CGRectMake(bgImageX + 10, bgImageY + 10, rTextWidth, rTextHeight);
        
        if (self.weiboModel.repostWeiboModel.thumbnailImage != nil) {
            if (_isDetail) {
                
                CGFloat rImageX = kScreenWidth/2 - 80;
                
                CGFloat rImageY = CGRectGetMaxY(self.rTextFrame) + 10;
                
                self.imageFrame = CGRectMake(rImageX, rImageY, 160, 160);
                
            }else {
                CGFloat rImageX = CGRectGetMinX(self.rTextFrame);
                
                CGFloat rImageY = CGRectGetMaxY(self.rTextFrame) + 10;
                
                self.imageFrame = CGRectMake(rImageX, rImageY, 80, 80);
                
            }
            
            
            _bgImageFrame.size.height = CGRectGetMaxY(self.imageFrame) - bgImageY + 10;
        }else {
            _bgImageFrame.size.height = CGRectGetMaxY(self.rTextFrame) - bgImageY + 10;
        }
        
        _frame.size.height = CGRectGetMaxY(self.bgImageFrame) + 10;
    }
    
    
    
}

@end
