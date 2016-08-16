//
//  MusicDescribeView.h
//  忆首歌
//
//  Created by qianfeng on 15/10/30.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicDescribeView : UIView
@property(nonatomic,strong)UIImageView * pic;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * nickNmaeLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * longLabel;
@property(nonatomic,strong)UITextView * descriptions;

@property(nonatomic,copy)NSDictionary * dictionary;
@property(nonatomic,copy)NSDictionary * dic;

-(void)giveDictionary:(NSMutableDictionary *)dictionary;
@end
