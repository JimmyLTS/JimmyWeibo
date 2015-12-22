//
//  NetworkService.h
//  TestAFNetWoring
//
//  Created by gj on 15/12/17.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"
#import "Common.h"


typedef void (^BlockType)(id result , NSURLResponse *response , NSError *error);

@interface NetworkService : NSObject

+ (void)requestDataWithURL:(NSString *)urlString
                HTTPMethod:(NSString *)method
                    params:(NSMutableDictionary *)params
          completionHandle:(BlockType) completionHandle;




+ (NSURLSessionDataTask *)requestAFUrl:(NSString *)urlString
                            httpMethod:(NSString *)method
                                params:(NSMutableDictionary *)params //token  文本
                                  data:(NSMutableDictionary *)dataDic //文件
                                 block:(BlockType)block;


+ (void)getHomeList:(NSMutableDictionary *)params
              block:(BlockType)block;
+ (void)sendWeibo:(NSMutableDictionary *)params
            block:(BlockType)block;

+ (NSURLSessionDataTask *)sendWeibo:(NSString *)text
                               image:(UIImage *)image
                               block:(BlockType)block;


+ (void)getAFHomeList:(NSMutableDictionary *)params block:(BlockType)block;

@end
