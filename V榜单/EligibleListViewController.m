//
//  EligibleListViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "EligibleListViewController.h"
#import "EligibleListTableViewCell.h"
#import "ImportantTwoViewController.h"
#import "MJRefresh.h"
#import "DOPDropDownMenu.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#define WANGZHI @"http://mapi.yinyuetai.com/vchart/trend.json?D-A=0&date=true&area=%@&offset=0&size=%ld&%@"
@interface EligibleListViewController ()<DOPDropDownMenuDelegate,DOPDropDownMenuDataSource,UITableViewDelegate,UITableViewDataSource>
{
    NSString * _type;//写完之后才发现这玩应并没有什么卵用 有用 不用不行
    
    NSArray * _nameArray;
    
    NSMutableArray * _dataArray;
    
    UITableView * _tableView;
    
    NSInteger _page;
}
@end

@implementation EligibleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"V榜单";
    _nameArray=@[@"大陆",@"日本",@"欧美",@"韩国"];
    _dataArray=[[NSMutableArray alloc]init];
    self.view.backgroundColor=[UIColor purpleColor];
    self.navigationController.navigationBar.translucent=NO;
    _page=20;
    
    _type=@"ML";
    [self getType:@"ML"];
    
    [self createDOPD];
    
    [self createTableView];
    
    [self createRefresh];
}

-(void)createRefresh{

    [_tableView addHeaderWithTarget:self action:@selector(WangXiaBaLa)];
    
    [_tableView addFooterWithTarget:self action:@selector(WangShangHuaLa)];
}

-(void)WangXiaBaLa{

    _page=20;
    
    [self getType:_type];
    
    [_tableView headerEndRefreshing];
}

-(void)WangShangHuaLa{

    _page+=20;
    
    [self getType:_type];
    NSLog(@"%@",_type);
    [_tableView footerEndRefreshing];
}

-(void)createTableView{

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, SELFWIDTH.width, SELFWIDTH.height-40)];
    
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
    EligibleListTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell=[[EligibleListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    NSDictionary * dic=_dataArray[indexPath.row];
    [cell.posterPic sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"posterPic"]]];
    cell.titleLabel.text=[dic objectForKey:@"title"];
    cell.artistName.text=[dic objectForKey:@"artistName"];
    
    return cell;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185;
}

-(void)createDOPD{

    DOPDropDownMenu * menu=[[DOPDropDownMenu alloc]initWithOrigin:CGPointMake(0, 0) andHeight:40];
    menu.delegate=self;
    menu.dataSource=self;
    menu.backgroundColor=[UIColor colorWithRed:0.0 green:0.5 blue:0.5 alpha:1.0];
    
    [self.view addSubview:menu];
}

-(NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 1;
}

-(NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    return _nameArray.count;
}

-(NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return [_nameArray objectAtIndex:indexPath.row];
}

-(void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
//    [_dataArray removeAllObjects];
    if (indexPath.row==0) {
        [self getType:@"ML"];
        _type=@"ML";
    }else if (indexPath.row==1){
        [self getType:@"JP"];
        _type=@"JP";
    }else if (indexPath.row==2){
        [self getType:@"US"];
        _type=@"US";
    }else{
        [self getType:@"KR"];
        _type=@"KR";
    }
    [_tableView reloadData];
}

-(void)getType:(NSString *)type{

    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
//    NSLog(@"%ld",_page);
    [manager GET:[NSString stringWithFormat:WANGZHI,type,_page,deviceinfo] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * rootDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        _dataArray=[rootDic objectForKey:@"videos"];
//        NSLog(@"lllll");
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
