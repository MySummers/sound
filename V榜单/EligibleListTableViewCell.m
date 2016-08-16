//
//  EligibleListTableViewCell.m
//  忆首歌
//
//  Created by qianfeng on 15/10/27.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "EligibleListTableViewCell.h"

@implementation EligibleListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}

-(void)createCell{

    self.posterPic=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, SELFWIDTH.width-10, 180)];
    self.posterPic.layer.cornerRadius=20;
    self.posterPic.layer.masksToBounds=YES;
    [self.contentView addSubview:self.posterPic];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 100, SELFWIDTH.width-15, 20)];
    self.titleLabel.textAlignment=NSTextAlignmentRight;
    [self.posterPic addSubview:self.titleLabel];
    
    self.artistName=[[UILabel alloc]initWithFrame:CGRectMake(0, 125, SELFWIDTH.width-15, 20)];
    self.artistName.textAlignment=NSTextAlignmentRight;
    [self.posterPic addSubview:self.artistName];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
