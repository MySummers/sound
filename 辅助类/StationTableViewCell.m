//
//  StationTableViewCell.m
//  忆首歌
//
//  Created by qianfeng on 15/10/26.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "StationTableViewCell.h"

@implementation StationTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createTableViewCell];
    }
    return self;
}

-(void)createTableViewCell{

    self.coverimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, SELFWIDTH.width-10, 160)];
    [self.contentView addSubview:self.coverimg];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 110, 200, 20)];
    [self.coverimg addSubview:self.titleLabel];
    
    self.unameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 133, 200, 15)];
    self.unameLabel.font=[UIFont systemFontOfSize:12];
    [self.coverimg addSubview:self.unameLabel];
    
    self.descLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 165, SELFWIDTH.width-10, 20)];
    [self.contentView addSubview:self.descLabel];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
