//
//  ImportantTwoViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/25.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "ImportantTwoViewController.h"
#import "CommentTableViewCell.h"
#import "SimilarMVTableViewCell.h"
#import "MusicDescribeView.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#define XIANGQING @"http://mapi.yinyuetai.com/video/show.json?D-A=0&relatedVideos=true&id=%@&%@"
#define PINGLUN @"http://mapi.yinyuetai.com/video/comment/list.json?D-A=0&v=2&offset=0&videoId=%@&size=%ld&%@"
//MVDetailController  MusicDetailViewController  MVDetailController
//http://mapi.yinyuetai.com/video/show.json?D-A=0&relatedVideos=true&id=2406485&deviceinfo=%7B%22aid%22%3A%2210201027%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.4.4%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22m1%20note%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%2252d8f6fa4d7e20415c571f5c81a9070f%22%2C%22clid%22%3A110008000%7D
@interface ImportantTwoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView * _allView;
    
    NSMutableDictionary * _miaoshuDic;
    
    NSMutableArray * _MVArray;
    
    NSMutableArray * _pinglunArray;
    
    MusicDescribeView * _musicDescribe;
    
    UITableView * _commentTable;
    
    UITableView * _MVTable;
    
    NSInteger _page;
    
    UIView * _MVview;
    
    MPMoviePlayerController * _player;

}
@end
//http://mapi.yinyuetai.com/video/comment/list.json?D-A=0&v=2&offset=0&videoId=2376204&size=10&deviceinfo=%7B%22aid%22%3A%2210201027%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.4.4%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22m1%20note%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%2252d8f6fa4d7e20415c571f5c81a9070f%22%2C%22clid%22%3A110008000%7D
@implementation ImportantTwoViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"%@",self.IDString);
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    
    NSLog(@"%@",self.MyUrl);
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _miaoshuDic=[[NSMutableDictionary alloc]init];
    _MVArray=[[NSMutableArray alloc]init];
    _pinglunArray=[[NSMutableArray alloc]init];
    
    _page=10;
    self.navigationController.navigationBar.translucent=NO;
    [self createAllView];
    
    [self createNetDataSource];
    
    [self createPingLunDataSource];
    
    [self createShareAndCollection];
    
    [self createSegmentedControl];
    
    [self createPlayButton];
    
//    [self createSegmentedControl];
}

-(void)createPlayButton{
    
    _MVview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SELFWIDTH.width, 205)];
    
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SELFWIDTH.width, 205)];
    NSString * string=self.backdropString;
    [imageView sd_setImageWithURL:[NSURL URLWithString:string]];
    [_MVview addSubview:imageView];
    [self.view addSubview:_MVview];
    
    UIButton * playButton=[UIButton buttonWithType:UIButtonTypeSystem];
    playButton.frame=CGRectMake((_MVview.frame.size.width-50)/2, (_MVview.frame.size.height-50)/2, 50, 50);
    [playButton setBackgroundImage:[UIImage imageNamed:@"pla.png"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playMV) forControlEvents:UIControlEventTouchUpInside];
    [_MVview addSubview:playButton];
    
    NSURL * url=[NSURL URLWithString:self.MyUrl];
    
    //创建播放器
    _player=[[MPMoviePlayerController alloc]initWithContentURL:url];
    //设置播放来源
    //_player.moviePlayer.movieSourceType=MPMovieSourceTypeStreaming;
    //设置播放尺寸
//    _player.moviePlayer.controlStyle=MPMovieControlStyleNone;
    _player.view.frame=CGRectMake(0, 0, SELFWIDTH.width, 205);
    
    
    //可能是准备播放
     [_MVview addSubview:_player.view];
    
    [_MVview bringSubviewToFront:playButton];
}

-(void)playMV{

    [_MVview bringSubviewToFront:_player.view];
    
//    NSURL * url=[NSURL URLWithString:self.MyUrl];
//    
//    //创建播放器
//    _player=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
//    //设置播放来源
//    _player.moviePlayer.movieSourceType=MPMovieSourceTypeStreaming;
//    //设置播放尺寸
//    _player.moviePlayer.controlStyle=MPMovieControlStyleEmbedded;
//    
//    //
//    [_player.moviePlayer prepareToPlay];
    
    
//    if ([_player.moviePlayer play]) {
//        NSLog(@"播放了");
//    }
    [_player play];

   
    
    //当播放结束后 系统给播放器发送通知 返回界面
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishPlay) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

-(void)finishPlay{

    //移除播放界面
    [_player.view removeFromSuperview];
    
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

-(void)createNetDataSource{

    //MV描述和相关MV数据
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:XIANGQING,self.IDString,deviceinfo] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _miaoshuDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",_miaoshuDic);
        
        _MVArray=[_miaoshuDic objectForKey:@"relatedVideos"];
        [self performSelectorOnMainThread:@selector(backMain) withObject:nil waitUntilDone:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
//    //评论界面数据
//    AFHTTPRequestOperationManager * pinglunManager=[AFHTTPRequestOperationManager manager];
//    pinglunManager.responseSerializer=[AFHTTPResponseSerializer serializer];
//    [pinglunManager GET:[NSString stringWithFormat:PINGLUN,self.IDString,_page,deviceinfo] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary * rootDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        _pinglunArray=[rootDic objectForKey:@"comments"];
////        NSLog(@"%@",_pinglunArray);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
    
}

-(void)createPingLunDataSource{

    //评论界面数据
    AFHTTPRequestOperationManager * pinglunManager=[AFHTTPRequestOperationManager manager];
    pinglunManager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [pinglunManager GET:[NSString stringWithFormat:PINGLUN,self.IDString,_page,deviceinfo] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * rootDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        _pinglunArray=[rootDic objectForKey:@"comments"];
        //        NSLog(@"%@",_pinglunArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(void)backMain{
    
    [self createMusicDetail];
    
}

-(void)createSegmentedControl{

    NSArray * nameArray=@[@"MV描述",@"乐单评论",@"相关MV"];
    
    UISegmentedControl * segment=[[UISegmentedControl alloc]initWithItems:nameArray];
    segment.frame=CGRectMake(10, 205, SELFWIDTH.width-20, 30);
    segment.layer.cornerRadius=5;
    segment.layer.masksToBounds=YES;
    segment.selectedSegmentIndex=0;
//    [self createMusicDetail];
    segment.tintColor=[UIColor colorWithRed:0.23 green:0.5 blue:0.82 alpha:0.9];
    
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
}

-(void)segmentAction:(UISegmentedControl *)segment{
//    NSLog(@"2");
    [_allView removeFromSuperview];
    
    if (segment.selectedSegmentIndex==0) {
        NSLog(@"进入乐单描述界面");
        [self createMusicDetail];
    }else if (segment.selectedSegmentIndex==1){
        NSLog(@"进入评论页面");
        [self createCommentTable];
    }else if (segment.selectedSegmentIndex==2){
        NSLog(@"进入相关MV界面");
        [self createMVTable];
    }
}

//创建MV界面
-(void)createMVTable{

    [self createAllView];
    NSLog(@"lllll");
    _MVTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SELFWIDTH.width, _allView.frame.size.height) style:UITableViewStylePlain];
    _MVTable.delegate=self;
    _MVTable.dataSource=self;
    _MVTable.rowHeight=100;
    _MVTable.tag=11;
    
    [_allView addSubview:_MVTable];
}

//创建评论界面
-(void)createCommentTable{

    [self createAllView];
    
    _commentTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SELFWIDTH.width, _allView.frame.size.height) style:UITableViewStylePlain];
    _commentTable.delegate=self;
    _commentTable.dataSource=self;
    _commentTable.tag=10;
    
    [_allView addSubview:_commentTable];
    
    [self createRefresh];
}

-(void)createRefresh{

    [_commentTable addHeaderWithTarget:self action:@selector(WangXiaBaLa)];
    
    [_commentTable addFooterWithTarget:self action:@selector(WangShangHuaLa)];
    
}

-(void)WangXiaBaLa{

    _page=0;
    [self createPingLunDataSource];
    
    [_commentTable reloadData];
    
    [_commentTable headerEndRefreshing];
}

-(void)WangShangHuaLa{
    
    _page+=10;
    [self createPingLunDataSource];
//    [self createCommentTable];
    [_commentTable reloadData];
    
    [_commentTable footerEndRefreshing];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==10) {
        return _pinglunArray.count;
    }else {
        return _MVArray.count;
    }
}

//评论界面的自适应高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==10) {
        NSDictionary * dic=_pinglunArray[indexPath.row];
        NSString * neiRong=[dic objectForKey:@"content"];
        CGFloat h=[ImportantTwoViewController heightWith:neiRong];
        return h + 95;
    }else{
        return 100;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc]init];
//    [cell removeFromSuperview];
    if (tableView.tag==10) {
        CommentTableViewCell * commentCell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
        if (!commentCell) {
            commentCell=[[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        }
        
        NSDictionary * dictionary=_pinglunArray[indexPath.row];
        
        CGFloat height=[ImportantTwoViewController heightWith:[dictionary objectForKey:@"content"]];
        
        [commentCell setDictionaryWith:dictionary Height:height];
        
        cell=commentCell;
        
    }else{
        SimilarMVTableViewCell * similarCell=[tableView dequeueReusableCellWithIdentifier:@"id"];
        if (!similarCell) {
            similarCell=[[SimilarMVTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        }
        NSDictionary * dictionary=_MVArray[indexPath.row];
        [similarCell giveMeADinctionary:dictionary];
        cell=similarCell;
    }
    
//    for (UIView * view in cell.subviews) {
//        [view removeFromSuperview];
//    }

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==11) {
        ImportantTwoViewController * impor=[[ImportantTwoViewController alloc]init];
        NSDictionary * dic=_MVArray[indexPath.row];
        impor.IDString=[dic objectForKey:@"id"];
        impor.MyUrl=[dic objectForKey:@"url"];
        impor.backdropString=[dic objectForKey:@"posterPic"];
        [self.navigationController pushViewController:impor animated:YES];
    }

}

//乐单描述界面搭建
-(void)createMusicDetail{

    [self createAllView];
    _musicDescribe=[[MusicDescribeView alloc]initWithFrame:CGRectMake(0, 0, SELFWIDTH.width, SELFWIDTH.height-330)];
    
    _musicDescribe.backgroundColor=[UIColor whiteColor];
//    NSLog(@"%@",_miaoshuDic);
    [_musicDescribe giveDictionary:_miaoshuDic];
    [_allView addSubview:_musicDescribe];
    
}

//创建收藏 分享 按钮
-(void)createShareAndCollection{
    
    UIButton * share=[UIButton buttonWithType:UIButtonTypeSystem];
    share.frame=CGRectMake(0, SELFWIDTH.height-94, SELFWIDTH.width/2-0.5, 30);
    [share setTitle:@"分享" forState:UIControlStateNormal];
    [share setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    share.tag=10;
    share.layer.borderWidth=0.5;
    share.layer.borderColor=[UIColor grayColor].CGColor;
    share.backgroundColor=[UIColor whiteColor];
    [share addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:share];
    
    UIButton * conllection=[UIButton buttonWithType:UIButtonTypeSystem];
    conllection.frame=CGRectMake(SELFWIDTH.width/2-0.5, SELFWIDTH.height-94, SELFWIDTH.width/2, 30);
    [conllection setTitle:@"收藏" forState:UIControlStateNormal];
    [conllection setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    conllection.tag=10;
    conllection.layer.borderWidth=0.5;
    conllection.layer.borderColor=[UIColor grayColor].CGColor;
    conllection.backgroundColor=[UIColor whiteColor];
    [conllection addTarget:self action:@selector(conllectionAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:conllection];
    
}
//添加收藏事件
-(void)conllectionAction{
    
}
//添加分享事件(后续工作 最好加一个在下边往上弹出那个 忘叫啥了)
-(void)shareAction{
    
}

-(void)createAllView{

//    NSLog(@"1");
    _allView=[[UIView alloc]initWithFrame:CGRectMake(0, 235, SELFWIDTH.width, SELFWIDTH.height-330)];
    _allView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_allView];
}

+(CGFloat)heightWith:(NSString *)height{

    //设置完一段文字的字体大小 返回其高度
    CGRect rect=[height boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    return rect.size.height;
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
