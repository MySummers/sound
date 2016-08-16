//
//  QFRequest.m
//  QFNSURLSessionManager
//
//  Created by qianfeng on 15/9/21.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "QFRequest.h"
#import "NSString+Hashing.h"
@implementation QFRequest
-(void)startRequest{

    //如果用缓存 并且缓存里还有数据
    if (self.isCache) {
        //先找到缓存路径
        //MD5Hash 路径加密
        NSString * sandBoxPath=[NSHomeDirectory() stringByAppendingFormat:@"/tmp/%@",[self.urlString MD5Hash]];
        //文件管理器
//        NSLog(@"%@",NSHomeDirectory());
        NSFileManager * manager=[NSFileManager defaultManager];
        //判断一下 该路径下 是否存在这个文件
        if ([manager fileExistsAtPath:sandBoxPath]) {
            //如果存在 证明有缓存
            NSData * data=[NSData dataWithContentsOfFile:sandBoxPath];
            self.finishBlock(data);
            return;
        }
        //如果不存在 去重新请求数据
        NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
        NSURLSession * session=[NSURLSession sharedSession];
        NSURLSessionTask * task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            //如果使用缓存 把data写入缓存 方便再次读取缓存
             NSString * sandBoxPath=[NSHomeDirectory() stringByAppendingFormat:@"/tmp/%@",[self.urlString MD5Hash]];
            
            [data writeToFile:sandBoxPath atomically:YES];
            
            self.finishBlock(data);
            self.failedBlock(error);
        }];
        [task resume];
    }
}
@end
