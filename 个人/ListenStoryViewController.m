//
//  ListenStoryViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/29.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "ListenStoryViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
@interface ListenStoryViewController ()
{
    UIVisualEffectView * _visual;
    
    AVAudioPlayer * _player;
    
    BOOL _isPlay;
    
    UIProgressView * _progressView;

}
@end

@implementation ListenStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;
//    NSLog(@"%@",self.playUrl64);
//    NSLog(@"%@",self.coverSmall);
//    NSLog(@"%@",self.selfTitle);
    
    [self createMao];
    [self createBlur];
    
    [self createImage];
    
    [self createAvplayer];
}

-(void)createAvplayer{

    NSURL * musicUrl=[NSURL URLWithString:self.playUrl64];
    
//    NSData * data=[NSData dataWithContentsOfURL:musicUrl];
//    
//    _player=[[AVAudioPlayer alloc]initWithData:data error:nil];
    
    _player=[[AVAudioPlayer alloc]initWithContentsOfURL:musicUrl error:nil];
    
    [_player setVolume:10];
    
    [_player prepareToPlay];
    
    [_player play];
    _player.numberOfLoops=-1;
    _isPlay=YES;
}

-(void)createImage{

    UIImageView * backImage=[[UIImageView alloc]initWithFrame:CGRectMake(50, 80, SELFWIDTH.width-100, SELFWIDTH.width-100)];
    [backImage sd_setImageWithURL:[NSURL URLWithString:self.coverSmall]];
    backImage.layer.cornerRadius=(SELFWIDTH.width-100)/2;
    backImage.layer.masksToBounds=YES;
    [self.view addSubview:backImage];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, SELFWIDTH.height-80-SELFWIDTH.width+100+60, SELFWIDTH.width, 60)];
    label.numberOfLines=0;
    label.textAlignment=NSTextAlignmentCenter;
    label.text=self.selfTitle;
    [self.view addSubview:label];
    
    UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(SELFWIDTH.width/2-30, SELFWIDTH.height-80-SELFWIDTH.width+100+60+100, 60, 60)];
    button.layer.cornerRadius=30;
    button.layer.masksToBounds=YES;
    [button setBackgroundImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(50, SELFWIDTH.height-80-SELFWIDTH.width+100+60+80, SELFWIDTH.width-100, 8)];
    _progressView.layer.cornerRadius=4;
    _progressView.layer.masksToBounds=YES;
    [self.view addSubview:_progressView];
}

-(void)click:(UIButton *)button{

    if (_isPlay) {
        [button setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
        [_player stop];
        _isPlay=NO;
    }else{
        [button setBackgroundImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
        [_player play];
        
        //创建NSTimer 改变进度条
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeProgerss) userInfo:nil repeats:YES];
        
        _isPlay=YES;
    }
    
}

-(void)changeProgerss{

    CGFloat currentTime=_player.currentTime;//当前时间
    CGFloat durationTime=_player.duration;//总时间
    
    _progressView.progress=currentTime/durationTime;
}

-(void)createMao{

    UIBlurEffect * blur=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * vis=[[UIVisualEffectView alloc]initWithEffect:[UIVibrancyEffect effectForBlurEffect:blur]];
    [vis setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_visual.contentView addSubview:vis];
}

-(void)createBlur{

    UIImageView * imageView=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image=[UIImage imageNamed:@"as.png"];
    [self.view addSubview:imageView];
    
    _visual=[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _visual.frame=[UIScreen mainScreen].bounds;
    [imageView addSubview:_visual];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
