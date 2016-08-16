//
//  StoryTableViewCell.m
//  忆首歌
//
//  Created by qianfeng on 15/10/29.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "StoryTableViewCell.h"

@implementation StoryTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}

-(void)createCell{

    self.coverSmall=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 60, 60)];
    self.coverSmall.layer.cornerRadius=30;
    self.coverSmall.layer.masksToBounds=YES;
    [self.contentView addSubview:self.coverSmall];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 0, 300, 80)];
    self.titleLabel.numberOfLines=0;
    self.titleLabel.font=[UIFont systemFontOfSize:20];
    [self.contentView addSubview:self.titleLabel];
    
    self.nicknameLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 80, 300, 40)];
    self.nicknameLabel.font=[UIFont systemFontOfSize:15];
    self.nicknameLabel.textColor=[UIColor grayColor];
    self.nicknameLabel.numberOfLines=0;
    [self.contentView addSubview:self.nicknameLabel];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
