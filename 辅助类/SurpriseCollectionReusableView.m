//
//  SurpriseCollectionReusableView.m
//  忆首歌
//
//  Created by qianfeng on 15/10/28.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "SurpriseCollectionReusableView.h"

@implementation SurpriseCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 5, 375, 30)];
        self.titleLabel.backgroundColor=[UIColor clearColor];
        self.titleLabel.font=[UIFont systemFontOfSize:20];
        self.titleLabel.textColor=[UIColor redColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

@end
