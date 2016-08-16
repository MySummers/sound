//
//  MVShouBoTableViewCell.m
//  忆首歌
//
//  Created by qianfeng on 15/10/21.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "MVShouBoTableViewCell.h"

@implementation MVShouBoTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{

    _bigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(3, 0, SELFWIDTH.width-6, 180)];
    _bigImageView.layer.cornerRadius=10;
    _bigImageView.layer.masksToBounds=YES;
    
    [self.contentView addSubview:_bigImageView];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 105, 300, 20)];
    [_bigImageView addSubview:_titleLabel];
    
    _artisNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 130, 100, 20)];
    [_bigImageView addSubview:_artisNameLabel];
    
    _totalViewsLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 155, 300, 20)];
    [_bigImageView addSubview:_totalViewsLabel];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
