//
//  QFRequestManager.m
//  QFNSURLSessionManager
//
//  Created by qianfeng on 15/9/21.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "QFRequestManager.h"
#import "QFRequest.h"
@implementation QFRequestManager
+(void)requestWithUrl:(NSString *)UrlString IsCache:(BOOL)isCache finishBlock:(void(^)(NSData * data))finishBlock failedBlock:(void(^)())failedBlock
{
    QFRequest * request=[[QFRequest alloc]init];
    request.urlString=UrlString;
    request.isCache=isCache;
    request.finishBlock=finishBlock;
    request.failedBlock=failedBlock;
    [request startRequest];
}
@end
