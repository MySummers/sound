//
//  MVDisplayViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "MVDisplayViewController.h"

#import "ImportantTwoViewController.h"
#import "MVShouBoTableViewCell.h"
#import "QFRequestManager.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#define WANGZHI @"http://mapi.yinyuetai.com/video/list.json?D-A=0&promoTitle=true&area=%@&supportBanner=true&offset=0&size=%ld&%@"
#define DEVICE @"deviceinfo=%7B%22aid%22%3A%2210201027%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.4.4%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22m1%20note%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%2252d8f6fa4d7e20415c571f5c81a9070f%22%2C%22clid%22%3A110008000%7D"
@interface MVDisplayViewController ()
{
    NSMutableArray * _dataSourceArray;
    
    UITableView * _tableView;
    
    NSInteger _page;
    
    BOOL _isPull;

}
@end


//http://mapi.yinyuetai.com/video/list.json?D-A=0&promoTitle=true&area=ALL&supportBanner=true&offset=0&size=20&deviceinfo=%7B%22aid%22%3A%2210201027%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.4.4%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22m1%20note%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%2252d8f6fa4d7e20415c571f5c81a9070f%22%2C%22clid%22%3A110008000%7D
@implementation MVDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSourceArray=[[NSMutableArray alloc]init];
    self.view.backgroundColor=[UIColor greenColor];
   
//    NSLog(@"%@",self.str);
    
    _page=20;
    self.navigationController.navigationBar.translucent=NO;
    [self createDataSource];

    [self createTableView];
    
    [self createRefresh];
}

-(void)createRefresh{

    [_tableView addHeaderWithTarget:self action:@selector(wangXiaBaLa)];
    
    [_tableView addFooterWithTarget:self action:@selector(wangShangHuaLa)];
}

-(void)wangXiaBaLa{

    _page=20;
    
    _isPull=YES;
    
    [self createDataSource];
    
    [_tableView headerEndRefreshing];
}

-(void)wangShangHuaLa{

    _page += 20;
    
    _isPull=NO;
    
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
    return _dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVShouBoTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell=[[MVShouBoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    NSDictionary * dic=_dataSourceArray[indexPath.row];
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
//    NSLog(@"%@",self.str);
    ImportantTwoViewController * important=[[ImportantTwoViewController alloc]init];
    
    NSDictionary * dic=_dataSourceArray[indexPath.row];
    
    important.IDString=[dic objectForKey:@"id"];
    
    important.MyUrl=[dic objectForKey:@"url"];
    
    important.backdropString=[dic objectForKey:@"posterPic"];
    
//    important.IDString=
    
    [self.navigationController pushViewController:important animated:YES];

}

-(void)createDataSource{

//    [QFRequestManager requestWithUrl:[NSString stringWithFormat:WANGZHI,self.str,20,DEVICE] IsCache:YES finishBlock:^(NSData *data) {
//        NSDictionary * rootDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        _dataSourceArray=[rootDic objectForKey:@"videos"];
////        NSLog(@"%@",_dataSource);
//        
//    } failedBlock:^{
//        
//    }];
    
    if (_isPull) {
//        [_dataSourceArray removeAllObjects];
    }
    
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
   [manager GET:[NSString stringWithFormat:WANGZHI,self.str,_page,DEVICE] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
       _dataSourceArray=[responseObject objectForKey:@"videos"];
//       NSLog(@"%@",_dataSourceArray);
       
       [self performSelectorOnMainThread:@selector(BakeMain) withObject:nil waitUntilDone:YES];

       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
   }];
    
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
