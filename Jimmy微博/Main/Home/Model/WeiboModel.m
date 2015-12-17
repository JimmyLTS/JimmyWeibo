//
//  WeiboModel.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/10.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "WeiboModel.h"
/*
 返回值字段	字段类型	字段说明
 created_at	string	微博创建时间
 id	int64	微博ID
 mid	int64	微博MID
 idstr	string	字符串型的微博ID
 text	string	微博信息内容
 source	string	微博来源
 favorited	boolean	是否已收藏，true：是，false：否
 truncated	boolean	是否被截断，true：是，false：否
 in_reply_to_status_id	string	（暂未支持）回复ID
 in_reply_to_user_id	string	（暂未支持）回复人UID
 in_reply_to_screen_name	string	（暂未支持）回复人昵称
 thumbnail_pic	string	缩略图片地址，没有时不返回此字段
 bmiddle_pic	string	中等尺寸图片地址，没有时不返回此字段
 original_pic	string	原始图片地址，没有时不返回此字段
 geo	object	地理信息字段 详细
 user	object	微博作者的用户信息字段 详细
 retweeted_status	object	被转发的原微博信息字段，当该微博为转发微博时返回 详细
 reposts_count	int	转发数
 comments_count	int	评论数
 attitudes_count	int	表态数
 mlevel	int	暂未支持
 visible	object	微博的可见性及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；list_id为分组的组号
 pic_ids	object	微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。
 ad	object array	微博流内的推广微博ID
 */

@implementation WeiboModel
//01、原生态
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    if ([key isEqualToString:@"text"]) {
//        _mytext = value;
//    }
//}

//02、BaseModel实现
- (NSDictionary *)attributeMapDictionary {
    
    NSDictionary *mapAtt = @{
                             @"createDate":@"created_at",
                             @"weiboId":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"favorited":@"favorited",
                             @"thumbnailImage":@"thumbnail_pic",
                             @"bmiddlelImage":@"bmiddle_pic",
                             @"originalImage":@"original_pic",
                             @"geo":@"geo",
                             @"repostsCount":@"reposts_count",
                             @"commentsCount":@"comments_count",
                             @"weiboIdStr":@"idstr"
                             };
    
    return mapAtt;
    
}

- (void)setAttributes:(NSDictionary*)dataDic {
    
    [super setAttributes:dataDic];
    //01、微博用户
    NSDictionary *userDic = dataDic[@"user"];
    
    self.usermodel = [[UserModel alloc]initWithDataDic:userDic];
    //02、转发微博
    NSDictionary *repostDic = dataDic[@"retweeted_status"];
    if (repostDic != nil) {
        _repostWeiboModel = [[WeiboModel alloc]initWithDataDic:repostDic];
        
        NSString *repostUser = self.repostWeiboModel.usermodel.screen_name;
        _repostWeiboModel.text = [NSString stringWithFormat:@"@%@:%@", repostUser, _repostWeiboModel.text];
    }
    
    //03、微博来源
//    source = "<a href=\"http://app.weibo.com/t/feed/5yiHuw\" rel=\"nofollow\">iPhone 6 Plus</a>";
    if (self.source != nil) {
        NSString *regex = @">.+<";
        NSArray *array = [self.source componentsMatchedByRegex:regex];
        
        if (array.count != 0) {
            self.source = array[0];
            self.source = [self.source substringWithRange:NSMakeRange(1, self.source.length-2)];
            self.source = [NSString stringWithFormat:@"来源：%@",self.source];
        }
    }
    
    //04、微博表情处理 ：查找文字、文字替换
    //检索出表情文字
    NSString *faceRegex = @"\\[\\w+\\]";
    NSArray *faceItems = [self.text componentsMatchedByRegex:faceRegex];
    
    //在emoticon.plist 中找出表情图片
    NSString *facePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *faceImageArray = [NSArray arrayWithContentsOfFile:facePath];
    
    //01、普通查找、替换
//    for (NSString *faceName in faceItems) {
//        
//        for (NSDictionary *configDic in faceImageArray) {
//            if ([configDic[@"chs"] isEqualToString:faceName]) {
//                //找出相对应的图片名字
//                NSString *faceImageName = configDic[@"png"];
//                //生成 <image url = '%@'>
//                NSString *replaceString = [NSString stringWithFormat:@"<image url = '%@'>", faceImageName];
//                
//                //替换文本
//                self.text = [self.text stringByReplacingOccurrencesOfString:faceName withString:replaceString];
//            }
//        }
//    }
    
    //02、谓词查找、替换
    for (NSString *faceName in faceItems) {
        
        NSString *predicateString = [NSString stringWithFormat:@"self.chs='%@'", faceName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        
        NSArray *items = [faceImageArray filteredArrayUsingPredicate:predicate];
     
        if (items.count > 0) {
            NSDictionary *configDic = items[0];
            
            //找出相对应的图片名字
            NSString *faceImageName = configDic[@"png"];
            //生成 <image url = '%@'>
            NSString *replaceString = [NSString stringWithFormat:@"<image url = '%@'>", faceImageName];
            
            //替换文本
            self.text = [self.text stringByReplacingOccurrencesOfString:faceName withString:replaceString];
        }
    }
    
}

@end
