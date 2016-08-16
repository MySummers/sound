//
//  MusicFormViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "MusicFormViewController.h"
#import "ImportantViewController.h"
#import "MusicFormTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MJRefresh.h"

#define REMEN @"http://mapi.yinyuetai.com/playlist/list.json?D-A=0&category=HOT&offset=0&size=%ld&%@"
#define ZUIXIN @"http://mapi.yinyuetai.com/playlist/list.json?D-A=0&category=NEW&offset=0&size=%ld&%@"
#define JINGXUAN @"http://mapi.yinyuetai.com/playlist/list.json?D-A=0&category=CHOICE&offset=0&size=%ld&%@"

#define deviceInfo @"deviceinfo=%7B%22aid%22%3A%2210201027%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.4.4%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22m1%20note%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%2252d8f6fa4d7e20415c571f5c81a9070f%22%2C%22clid%22%3A110008000%7D"
//http://mapi.yinyuetai.com/playlist/list.json?D-A=0&category=HOT&offset=0&size=10&deviceinfo=%7B%22aid%22%3A%2210201027%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.4.4%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22m1%20note%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%2252d8f6fa4d7e20415c571f5c81a9070f%22%2C%22clid%22%3A110008000%7D
@interface MusicFormViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * _dataArray;
    
    UITableView * _tableView;
    
    NSUInteger _page;
    
    NSString * _path;
    
    NSString * _address;

}
@end

@implementation MusicFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"乐单";
    _page=20;
    
    _path=[NSString stringWithFormat:JINGXUAN,_page,deviceInfo];
    _address=JINGXUAN;
    [self createDataSource:_path];
    _dataArray=[[NSMutableArray alloc]init];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self createTableView];

    [self createSegmented];
    
    [self createRefresh];
}

-(void)createRefresh{

    [_tableView addHeaderWithTarget:self action:@selector(WangXiaBaLa)];
    
    [_tableView addFooterWithTarget:self action:@selector(WangShangHuanLa)];
}

-(void)WangXiaBaLa{

    _page=20;
    
    [self createDataSource:_path];
    
    [_tableView headerEndRefreshing];
}

-(void)WangShangHuanLa{

    _page +=20;
    _path=[NSString stringWithFormat:_address,_page,deviceInfo];
    [self createDataSource:_path];
    
    [_tableView footerEndRefreshing];
}

-(void)createTableView{

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, SELFWIDTH.width, SELFWIDTH.height)];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicFormTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell=[[MusicFormTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    NSDictionary * dic=_dataArray[indexPath.row];
    
    NSDictionary * smallDic=[dic objectForKey:@"creator"];
    
    [cell.bigImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"thumbnailPic"]]];
    [cell.smallImageView sd_setImageWithURL:[NSURL URLWithString:[smallDic objectForKey:@"smallAvatar"]]];
    
    cell.titleLabel.text=[dic objectForKey:@"title"];
    cell.totalLabel.text=[NSString stringWithFormat:@"获得积分: %@  播放:%@",[dic objectForKey:@"totalFavorites"],[dic objectForKey:@"totalViews"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImportantViewController * important=[[ImportantViewController alloc]init];
    NSDictionary * dic=_dataArray[indexPath.row];
    important.IDString=[dic objectForKey:@"id"];
//    important.IDString=
//    important.MyUrl=[dic objectForKey:@"url"];
    important.backdropString=[dic objectForKey:@"thumbnailPic"];
    
    [self.navigationController pushViewController:important animated:YES];

}

-(void)createDataSource:(NSString *)path{

    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _dataArray=[responseObject objectForKey:@"playLists"];
//        NSLog(@"%@",_dataArray);
        [self performSelectorOnMainThread:@selector(backMain) withObject:nil waitUntilDone:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//http://mapi.yinyuetai.com/recommend/video/aggregation.json?D-A=0&deviceinfo=%7B%22aid%22%3A%2210201027%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.4.4%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22m1%20note%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%2252d8f6fa4d7e20415c571f5c81a9070f%22%2C%22clid%22%3A110008000%7D
-(void)backMain{

    [_tableView reloadData];
    
}

-(void)createSegmented{

    NSArray * array=@[@"精选",@"热门",@"最新"];
    
    UISegmentedControl * segment=[[UISegmentedControl alloc]initWithItems:array];
    segment.frame=CGRectMake(5, 2, self.view.frame.size.width-10, 30);
    
    [segment addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
    
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(5, 68, self.view.frame.size.width-10, 30)];
    [view addSubview:segment];
    
//    _tableView.tableHeaderView.frame=CGRectMake(5, 0, self.view.frame.size.width-10, 30);
    _tableView.tableHeaderView=view;
//    _tableView.tableFooterView=segment;
//    [self.view addSubview:segment];
}

-(void)segAction:(UISegmentedControl *)segment{

    if (_dataArray!=0) {
//        [_dataArray removeAllObjects];
    }
    
//    NSString * path=@"";
    
    if (segment.selectedSegmentIndex==0) {
        _path=[NSString stringWithFormat:JINGXUAN,_page,deviceInfo];
        _address=JINGXUAN;
    }else if (segment.selectedSegmentIndex==1){
        _path=[NSString stringWithFormat:REMEN,_page,deviceInfo];
        _address=REMEN;
    }else if (segment.selectedSegmentIndex==2){
        _path=[NSString stringWithFormat:ZUIXIN,_page,deviceInfo];
        _address=ZUIXIN;
    }
    [self createDataSource:_path];
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
