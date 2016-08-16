//
//  CommentTableViewCell.m
//  忆首歌
//
//  Created by qianfeng on 15/11/1.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation CommentTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self createCell];
    }
    return self;
}

-(void)createCell{

    self.userHeadImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.userNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(65, 25, 200, 15)];
//    self.contentLabel=[UILabel]
    
}

-(void)setDictionaryWith:(NSDictionary *)dictionary Height:(CGFloat)height
{
    for (id obj in self.contentView.subviews) {
        
        [obj removeFromSuperview];
    }
    
    self.userHeadImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    [self.userHeadImg sd_setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"userHeadImg"]]];
    self.userHeadImg.layer.cornerRadius=25;
    self.userHeadImg.layer.masksToBounds=YES;
    [self.contentView addSubview:self.userHeadImg];
    
    self.userNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(65, 25, 200, 15)];
    self.userNameLabel.text=[dictionary objectForKey:@"userName"];
    [self.contentView addSubview:self.userNameLabel];
    
    self.contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 70, SELFWIDTH.width-20, height)];
    self.contentLabel.numberOfLines=0;
    self.contentLabel.text=[dictionary objectForKey:@"content"];
    [self.contentView addSubview:self.contentLabel];
    
    self.dateCreated=[[UILabel alloc]initWithFrame:CGRectMake(SELFWIDTH.width-80, height+70, 80, 15)];
    self.dateCreated.text=[dictionary objectForKey:@"dateCreated"];
    [self.contentView addSubview:self.dateCreated];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
