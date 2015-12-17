//
//  DataService.m
//  时光电影
//
//  Created by huiwenjiaoyu on 15/11/3.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

#import "DataService.h"

@implementation DataService

+ (id)requestData:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:NULL];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    id jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    
    return jsonDic;
}

@end
