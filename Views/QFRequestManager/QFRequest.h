//
//  QFRequest.h
//  QFNSURLSessionManager
//
//  Created by qianfeng on 15/9/21.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFRequest : NSObject
@property(nonatomic,copy)NSString * urlString;
@property(nonatomic,assign)BOOL isCache;
@property(nonatomic,copy)void (^finishBlock)(NSData * data);
@property(nonatomic,copy)void (^failedBlock)(NSError * error);
-(void)startRequest;
@end
