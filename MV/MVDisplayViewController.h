//
//  MVDisplayViewController.h
//  忆首歌
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "AllViewController.h"

@interface MVDisplayViewController : AllViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSString * str;
@end
