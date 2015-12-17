//
//  WeiboModel.h
//  Jimmy微博
//
//  Created by Jimmy on 15/12/10.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "UserModel.h"
#import "RegexKitLite.h"

@interface WeiboModel : BaseModel

#pragma mark - 原生态
//@property (nonatomic, copy)NSString *created_at;
//@property (nonatomic, copy)NSString *idstr;
//@property (nonatomic, copy)NSString *mytext;

#pragma mark - BaseModel

@property(nonatomic,copy)NSString       *createDate;       //微博创建时间
@property(nonatomic,retain)NSNumber     *weiboId;           //微博ID
@property(nonatomic,copy)NSString       *weiboIdStr;        //字符串微博ID
@property(nonatomic,copy)NSString       *text;              //微博的内容
@property(nonatomic,copy)NSString       *source;              //微博来源
@property(nonatomic,retain)NSNumber     *favorited;         //是否已收藏
@property(nonatomic,copy)NSString       *thumbnailImage;     //缩略图片地址
@property(nonatomic,copy)NSString       *bmiddlelImage;     //中等尺寸图片地址
@property(nonatomic,copy)NSString       *originalImage;     //原始图片地址
@property(nonatomic,retain)NSDictionary *geo;               //地理信息字段
@property(nonatomic,retain)NSNumber     *repostsCount;      //转发数
@property(nonatomic,retain)NSNumber     *commentsCount;      //评论数

@property(nonatomic, strong)UserModel *usermodel;

@property (nonatomic, strong)WeiboModel *repostWeiboModel;

@end
