//
//  MVYourLoveViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/21.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "MVYourLoveViewController.h"
#import "MVShouBoTableViewCell.h"
#import "ImportantTwoViewController.h"
#import "UIImageView+WebCache.h"
#import "QFRequestManager.h"
#import "MJRefresh.h"
#define WANGZHI @"http://mapi.yinyuetai.com/video/guess.json?D-A=0&offset=0&size=%ld&%@"
#define DEVICE @"deviceinfo=%7B%22aid%22%3A%2210201027%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.4.4%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22m1%20note%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%2252d8f6fa4d7e20415c571f5c81a9070f%22%2C%22clid%22%3A110008000%7D"

@interface MVYourLoveViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * _dataArray;
    
    UITableView * _tableView;
    
    NSInteger _page;
}
@end

@implementation MVYourLoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page=20;
    
    [self createDataSource];
    self.navigationController.navigationBar.translucent=NO;
    [self createTableView];
    
    [self createRefresh];
//    self.view.backgroundColor=[UIColor blackColor];
}

-(void)createRefresh{
    
    [_tableView addHeaderWithTarget:self action:@selector(wangXiaBaLa)];
    
    [_tableView addFooterWithTarget:self action:@selector(wangShangHuaLa)];
}

-(void)wangXiaBaLa{
    
    _page=20;
    
    [self createDataSource];
    
    [_tableView headerEndRefreshing];
}

-(void)wangShangHuaLa{
    
    _page +=20;
    
    [self createDataSource];
    
    [_tableView footerEndRefreshing];
    
}

-(void)createTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds];
    
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
    
    cell.totalViewsLabel.text=[NSString stringWithFormat:@"播放次数   %@",[dic objectForKey:@"totalViews"]];
    
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
    
    [QFRequestManager requestWithUrl:[NSString stringWithFormat:WANGZHI,_page,DEVICE] IsCache:YES finishBlock:^(NSData *data) {
        NSDictionary * rootDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        _dataArray=[rootDic objectForKey:@"videos"];
        //        NSLog(@"%@",_dataSource);
        
    } failedBlock:^{
        
    }];
    
    [self performSelectorOnMainThread:@selector(BakeMain) withObject:nil waitUntilDone:YES];
}

-(void)BakeMain{
    
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
