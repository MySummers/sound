//
//  StoryViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/28.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "StoryViewController.h"
#import "StoryTableViewCell.h"
#import "ListenStoryViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#define SHANGMIAN @"http://mobile.ximalaya.com/mobile/others/ca/homePage?toUid=%@&device=android"
#define XIANMIAN @"http://mobile.ximalaya.com/mobile/others/ca/track/%@/1/30?device=android"
@interface StoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary * _upDictionary;
    
    NSMutableArray * _downArray;

    UITableView * _tableView;
}
@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _upDictionary=[[NSMutableDictionary alloc]init];
    _downArray=[[NSMutableArray alloc]init];
//    NSLog(@"%@",self.uid);
    self.navigationController.navigationBar.translucent=NO;
    [self createUpDataSource];

    [self createDownDataSource];
    
    [self createTableView];
}

-(void)createTableView{

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 210, SELFWIDTH.width, SELFWIDTH.height-210) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=120;
    
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _downArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell=[[StoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    NSDictionary * dic=_downArray[indexPath.row];
    [cell.coverSmall sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"coverSmall"]]];
    cell.titleLabel.text=[dic objectForKey:@"title"];
    cell.nicknameLabel.text=[dic objectForKey:@"nickname"];
//    NSLog(@"%@",[dic objectForKey:@"title"]);
//    NSLog(@"lllll");
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
    imageView.image=[UIImage imageNamed:@"shipin.png"];
    [cell.coverSmall addSubview:imageView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListenStoryViewController * listen=[[ListenStoryViewController alloc]init];
    NSDictionary * dic=_downArray[indexPath.row];
    listen.playUrl64=[dic objectForKey:@"playUrl64"];
    listen.coverSmall=[dic objectForKey:@"coverSmall"];
    listen.selfTitle=[dic objectForKey:@"title"];

    [self.navigationController pushViewController:listen animated:YES];
}

-(void)createDownDataSource{

    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:XIANMIAN,self.uid] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * rootDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",rootDic);
        _downArray=[rootDic objectForKey:@"list"];
        [self performSelectorOnMainThread:@selector(backMain) withObject:nil waitUntilDone:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(void)backMain{

    [_tableView reloadData];
    
}

-(void)createUp{

    UIImageView * backgroundLogo=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SELFWIDTH.width, 210)];
//    NSLog(@"%@",[_upDictionary objectForKey:@"backgroundLogo"]);
    [backgroundLogo sd_setImageWithURL:[NSURL URLWithString:[_upDictionary objectForKey:@"backgroundLogo"]]];
    [self.view addSubview:backgroundLogo];
    
    UIImageView * smallLogo=[[UIImageView alloc]initWithFrame:CGRectMake(SELFWIDTH.width/2-25, 80, 50, 50)];
    smallLogo.layer.cornerRadius=25;
    smallLogo.layer.masksToBounds=YES;
    [smallLogo sd_setImageWithURL:[NSURL URLWithString:[_upDictionary objectForKey:@"mobileSmallLogo"]]];
    [backgroundLogo addSubview:smallLogo];
    
    UILabel * nicknameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 140, SELFWIDTH.width, 20)];
    nicknameLabel.text=[_upDictionary objectForKey:@"nickname"];
    nicknameLabel.textAlignment=NSTextAlignmentCenter;
    [backgroundLogo addSubview:nicknameLabel];
    
    UILabel * personalLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 170, SELFWIDTH.width, 12)];
    personalLabel.font=[UIFont systemFontOfSize:12];
    personalLabel.text=[_upDictionary objectForKey:@"personalSignature"];
    personalLabel.textAlignment=NSTextAlignmentCenter;
    [backgroundLogo addSubview:personalLabel];
}

-(void)createUpDataSource{

    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:SHANGMIAN,self.uid] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _upDictionary=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",_upDictionary );
        
        [self performSelectorOnMainThread:@selector(downBackMain) withObject:nil waitUntilDone:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(void)downBackMain{

    [self createUp];
    
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
