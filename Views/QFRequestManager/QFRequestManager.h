//
//  QFRequestManager.h
//  QFNSURLSessionManager
//
//  Created by qianfeng on 15/9/21.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFRequestManager : NSObject
+(void)requestWithUrl:(NSString *)UrlString IsCache:(BOOL)isCache finishBlock:(void(^)(NSData * data))finishBlock failedBlock:(void(^)())failedBlock;
@end
