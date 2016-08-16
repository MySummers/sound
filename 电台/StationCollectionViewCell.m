//
//  StationCollectionViewCell.m
//  忆首歌
//
//  Created by qianfeng on 15/10/26.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "StationCollectionViewCell.h"

@implementation StationCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self createCell];
    }
    return self;
}

-(void)createCell{

    CGFloat with=self.frame.size.width;
    CGFloat height=self.frame.size.width;
    
    self.imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, with-20, height-60)];
    [self.contentView addSubview:self.imageV];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, height-50, with-20, 20)];
    [self.contentView addSubview:self.titleLabel];
    
    self.countLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, height-30, with-40, 20)];
    [self.contentView addSubview:self.countLabel];
    
    self.smallImage=[[UIImageView alloc]initWithFrame:CGRectMake(with-40, height-30, 20, 20)];
    [self.contentView addSubview:self.smallImage];
    
}

@end
