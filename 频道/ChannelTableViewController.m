//
//  ChannelTableViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/25.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "ChannelTableViewController.h"
#import "MVShouBoTableViewCell.h"
#import "ImportantTwoViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#define WANGZHI @"http://mapi.yinyuetai.com/channel/videos.json?D-A=0&order=VideoPubDate&detail=true&offset=0&channelId=%@&size=%ld&%@"
@interface ChannelTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    
    NSMutableArray * _dataArray;
    
    NSInteger  _page;
}
@end

@implementation ChannelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.titleLabel;
    _dataArray=[[NSMutableArray alloc]init];
//    NSLog(@"%@",self.IDNumber);
    
    _page=20;
    
    self.navigationController.navigationBar.translucent=NO;
    
    [self createDataSource];
    
    [self createTableView];
    
    [self createRefresh];
}

-(void)createRefresh{

    [_tableView addHeaderWithTarget:self action:@selector(WangXiaBaLa)];
    
    [_tableView addFooterWithTarget:self action:@selector(WangShangHuaLa)];
}

-(void)WangXiaBaLa{

    _page=20;
    
    [self createDataSource];
    
    [_tableView headerEndRefreshing];
}

-(void)WangShangHuaLa{
    
    _page+=20;
    
    [self createDataSource];
    
    [_tableView footerEndRefreshing];
}

-(void)createTableView{

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SELFWIDTH.width, SELFWIDTH.height-110)];
    
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
    MVShouBoTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell=[[MVShouBoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    NSDictionary * dic=_dataArray[indexPath.row];
    
    [cell.bigImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"posterPic"]]];
    cell.titleLabel.text=[dic objectForKey:@"title"];
    cell.artisNameLabel.text=[dic objectForKey:@"artistName"];
    cell.totalViewsLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"totalViews"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImportantTwoViewController * important=[[ImportantTwoViewController alloc]init];
    
    NSDictionary * dic=_dataArray[indexPath.row];
    important.IDString=[dic objectForKey:@"id"];
    important.MyUrl=[dic objectForKey:@"url"];
    important.backdropString=[dic objectForKey:@"posterPic"];
    [self.navigationController pushViewController:important animated:YES];
}

-(void)createDataSource{
//    NSLog(@"lllll");
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:WANGZHI,self.IDNumber,_page,deviceinfo] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * rootDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        _dataArray=[rootDic objectForKey:@"videos"];
//        NSLog(@"%@",_dataArray);
        [self performSelectorOnMainThread:@selector(backMain) withObject:nil waitUntilDone:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(void)backMain{

    [_tableView reloadData];
    
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
