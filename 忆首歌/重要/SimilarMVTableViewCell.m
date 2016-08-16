//
//  SimilarMVTableViewCell.m
//  忆首歌
//
//  Created by qianfeng on 15/11/1.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "SimilarMVTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation SimilarMVTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

-(void)giveMeADinctionary:(NSDictionary *)dictionary
{
    for (id object in self.contentView.subviews) {
        [object removeFromSuperview];
    }
    
//    NSLog(@"%@",dictionary);
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"posterPic"]]];
    [self.contentView addSubview:imageView];
    
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(155, 25, SELFWIDTH.width-155-10, 15)];
    titleLabel.text=[dictionary objectForKey:@"title"];
    [self.contentView addSubview:titleLabel];
    
    UILabel * artistNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(155, 45, SELFWIDTH.width-165, 15)];
    artistNameLabel.text=[dictionary objectForKey:@"artistName"];
    [self.contentView addSubview:artistNameLabel];

    UILabel * totalViewsLabel=[[UILabel alloc]initWithFrame:CGRectMake(155, 65, SELFWIDTH.width-165, 15)];
    totalViewsLabel.text=[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"totalViews"]];
    [self.contentView addSubview:totalViewsLabel];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
