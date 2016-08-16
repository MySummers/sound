//
//  StationViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "StationViewController.h"
#import "StationTableViewCell.h"
#import "StationDianJiViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#define DIANTAI @"http://api2.pianke.me/ting/radio?client=2"
@interface StationViewController ()
{
    UITableView * _tableView;

    NSMutableArray * _dataArray;
}
@end

@implementation StationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"电台";
    _dataArray=[[NSMutableArray alloc]init];
    self.view.backgroundColor=[UIColor redColor];
    
    [self createDataSoyrce];
    
    [self createTableView];
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
//    NSLog(@"lllllll");
    StationTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell=[[StationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    NSDictionary * dic=_dataArray[indexPath.row];
    NSDictionary * dictionary=[dic objectForKey:@"userinfo"];
    [cell.coverimg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"coverimg"]]];
    cell.titleLabel.text=[dic objectForKey:@"title"];
    cell.unameLabel.text=[dictionary objectForKey:@"uname"];
    cell.descLabel.text=[dic objectForKey:@"desc"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StationDianJiViewController * station=[[StationDianJiViewController alloc]init];
    
    NSDictionary * dic=_dataArray[indexPath.row];
    station.radioid=[dic objectForKey:@"radioid"];
    
    [self.navigationController pushViewController:station animated:YES];
}

-(void)createDataSoyrce{

    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:DIANTAI parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * rootDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary * dic=[rootDic objectForKey:@"data"];
        
        _dataArray=[dic objectForKey:@"alllist"];
        
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
