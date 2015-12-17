//
//  CommentModel.m
//  Jimmy微博
//
//  Created by Jimmy on 15/12/15.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "CommentModel.h"
#import "RegexKitLite.h"

@implementation CommentModel

- (NSDictionary *)attributeMapDictionary {
    NSDictionary *mapAtt = @{
                             @"commentId":@"idstr",
                             @"text":@"text",
                             @"source":@"source",
                             };
    
    return mapAtt;
}

- (void)setAttributes:(NSDictionary*)dataDic {
    
    [super setAttributes:dataDic];
    //01、微博用户
    NSDictionary *userDic = dataDic[@"user"];
    
    self.userModel = [[UserModel alloc]initWithDataDic:userDic];
    
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
    
    //谓词查找、替换
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
