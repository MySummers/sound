//
//  MusicFormTableViewCell.m
//  忆首歌
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "MusicFormTableViewCell.h"

@implementation MusicFormTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{

    _bigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, SELFWIDTH.width-10, 180)];
    _bigImageView.layer.cornerRadius=10;
    _bigImageView.layer.masksToBounds=YES;
    [self.contentView addSubview:_bigImageView];
    
    _smallImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 70, 60, 60)];
    _smallImageView.layer.cornerRadius=50;
    _smallImageView.layer.masksToBounds=YES;
    [_bigImageView addSubview:_smallImageView];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 130, 200, 20)];
    [_bigImageView addSubview:_titleLabel];
    
    _totalLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 155, SELFWIDTH.width, 20)];
    [_bigImageView addSubview:_totalLabel];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
