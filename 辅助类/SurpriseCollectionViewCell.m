//
//  SurpriseCollectionViewCell.m
//  忆首歌
//
//  Created by qianfeng on 15/10/28.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "SurpriseCollectionViewCell.h"

@implementation SurpriseCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self createCell];
    }
    return self;
}

-(void)createCell{

    self.logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, (SELFWIDTH.width-20)/3, (SELFWIDTH.width-20)/3)];
    [self.contentView addSubview:self.logoImage];
    
    self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, (SELFWIDTH.width-20)/3, (SELFWIDTH.width-20)/3, 30)];
    [self.contentView addSubview:self.nameLabel];
    
}

@end
