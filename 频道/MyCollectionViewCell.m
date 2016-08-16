//
//  MyCollectionViewCell.m
//  忆首歌
//
//  Created by qianfeng on 15/10/25.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];

    if (self) {
        [self createCell];
    }
    return self;
}

-(void)createCell{

    self.img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SELFWIDTH.width/2, SELFWIDTH.width/2)];
    [self.contentView addSubview:self.img];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, SELFWIDTH.width/2-25, 150, 20)];
    [self.img addSubview:self.titleLabel];
    
}

@end
