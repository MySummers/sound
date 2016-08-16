//
//  CommentTableViewCell.h
//  忆首歌
//
//  Created by qianfeng on 15/11/1.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * userHeadImg;
@property(nonatomic,strong)UILabel * userNameLabel;
@property(nonatomic,strong)UILabel * contentLabel;
@property(nonatomic,strong)UILabel * dateCreated;

-(void)setDictionaryWith:(NSDictionary *)dictionary Height:(CGFloat)height;
@end
