//
//  AudioFrequencyViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/26.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "AudioFrequencyViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
@interface AudioFrequencyViewController ()
{
    //使用音频必须使用全局变量 要不然会被释放 会导致无法播放
    //每个——player只能播放一首歌曲 要播放多个 就要创建多个
    AVAudioPlayer * _player;
    //进度条   可以把进度条和控制进度条的UISlider重叠的放在一起  应该可以
    UIProgressView * _progressView;
    
    BOOL _isPlay;
}
@end

@implementation AudioFrequencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"%@",self.musicUrl);
//    NSLog(@"%@",self.circularImage);
//    NSLog(@"%@",self.titleLabel);
    
    NSLog(@"1");
    [self createUI];
//    [self createPlayer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self createPlayer];
}

-(void)createPlayer{

    NSLog(@"2");
    NSURL * url=[NSURL URLWithString:self.musicUrl];
    
    NSData * data=[NSData dataWithContentsOfURL:url];
    
    _player=[[AVAudioPlayer alloc]initWithData:data error:nil];
    
    //_player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
    //循环播放
    _player.numberOfLoops=-1;
    
    [_player prepareToPlay];
    
    _isPlay=YES;
    
//    [_player play];
    if ([_player play]) {
        NSLog(@"lllll");
    }
}

-(void)createUI{

    UIImageView * backImage=[[UIImageView alloc]initWithFrame:self.view.bounds];
    backImage.image=[UIImage imageNamed:@"ca2d9e65b9887e6c64b49cb7ac6119148c45045e395e6-FDQjvy_fw658.jpeg"];
    
    [self.view addSubview:backImage];
    
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SELFWIDTH.width/2-150,SELFWIDTH.height/2-250+64, 300, 300)];
    imageView.layer.cornerRadius=150;
    imageView.layer.masksToBounds=YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.circularImage]];
    [self.view addSubview:imageView];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(SELFWIDTH.width/2-100, SELFWIDTH.height/2+60+64, 200, 20)];
    label.text=self.titleLabel;
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(SELFWIDTH.width/2-20, SELFWIDTH.height/2+171, 40, 40);
    [button setBackgroundImage:[UIImage imageNamed:@"iconfont-icon12.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //创建进度条
    _progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(50, SELFWIDTH.height/2+60+64+30, SELFWIDTH.width-100, 8)];
    _progressView.progress=0;
    [self.view addSubview:_progressView];
}

-(void)buttonAction:(UIButton *)button{

//    button.selected=!button.selected;
    if (_isPlay) {
        [button setBackgroundImage:[UIImage imageNamed:@"iconfont-iconfontcolor95.png"] forState:UIControlStateNormal];
        _isPlay=NO;
        [_player pause];
    }else{
        [button setBackgroundImage:[UIImage imageNamed:@"iconfont-icon12.png"] forState:UIControlStateNormal];
        [_player play];
        _isPlay=YES;
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeProgerss) userInfo:nil repeats:YES];
    }
}

-(void)changeProgerss{

    //获取播放文件的总时间 和 当前时间
    CGFloat currentTime=_player.currentTime;
    CGFloat totalTime=_player.duration;
    
    _progressView.progress=currentTime/totalTime;
    NSLog(@"%f@",_progressView.progress);
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
