//
//  MusicDescribeView.m
//  忆首歌
//
//  Created by qianfeng on 15/10/30.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "MusicDescribeView.h"
#import "UIImageView+WebCache.h"
@implementation MusicDescribeView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
//        [self createView];
        _dictionary=[[NSDictionary alloc]init];
        _dic=[[NSDictionary alloc]init];
    }
    return self;
}

-(void)createView{
//    NSLog(@"2");
    UILabel * nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 20, 100, 20)];
    nameLabel.text=@"艺人:";
    [self addSubview:nameLabel];

    self.nickNmaeLabel=[[UILabel alloc]initWithFrame:CGRectMake(70, 50, SELFWIDTH.width-70, 20)];
    [self addSubview:self.nickNmaeLabel];
    
    self.pic=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    self.pic.layer.cornerRadius=30;
    self.pic.layer.masksToBounds=YES;
    [self addSubview:self.pic];
    
    self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 80, SELFWIDTH.width, 20)];
    [self addSubview:self.timeLabel];
    
    self.longLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 105, SELFWIDTH.width, 20)];
    [self addSubview:self.longLabel];
    
    
    self.descriptions=[[UITextView alloc]initWithFrame:CGRectMake(10, 160, SELFWIDTH.width-20, 170)textContainer:nil];
    self.descriptions.backgroundColor=[UIColor whiteColor];
    self.descriptions.font=[UIFont systemFontOfSize:17];
    self.descriptions.textColor=[UIColor blackColor];
    self.descriptions.editable=NO;
    [self addSubview:self.descriptions];
    //nickNmaeLabel timeLabel longLabel descriptions
    
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[_dictionary objectForKey:@"playListPic"]] placeholderImage:[UIImage imageNamed:@"head_holder.png"]];
    NSDictionary * dic=[_dictionary objectForKey:@"creator"];
    self.nickNmaeLabel.text=[dic objectForKey:@"nickName"];
    
    self.timeLabel.text=[_dictionary objectForKey:@"updateTime"];
    
    self.longLabel.text=[NSString stringWithFormat:@"播放次数:%@",[_dictionary objectForKey:@"totalViews"]];
    
    self.descriptions.text=[NSString stringWithFormat:@"描述:%@",[_dictionary objectForKey:@"description"]];
}

-(void)giveDictionary:(NSMutableDictionary *)dictionary
{
//    NSLog(@"%@",dictionary);
//    NSLog(@"1");
//    NSLog(@"%@",dictionary);
    _dictionary=[NSDictionary dictionaryWithDictionary:dictionary];
//    NSLog(@"%@",_dictionary);
    NSArray * array=[dictionary objectForKey:@"artists"];
    _dic=array[0];
    [self createView];
//    [self.pic sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"artistAvatar"]]];
//    
//    self.nickNmaeLabel.text=[dictionary objectForKey:@"artistName"];
//    
//    self.timeLabel.text=[dictionary objectForKey:@"regdate"];
//    
//    self.longLabel.text=[NSString stringWithFormat:@"播放次数:%@  PC端:%@  移动端:%@",[dictionary objectForKey:@"totalViews"],[dictionary objectForKey:@"totalPcViews"],[dictionary objectForKey:@"totalMobileViews"]];
//    
//    self.descriptions.text=[NSString stringWithFormat:@"描述:%@",[dictionary objectForKey:@"description"]];
   
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
