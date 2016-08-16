//
//  ChannelViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "ChannelViewController.h"
#import "MyCollectionViewCell.h"
#import "ChannelTableViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#define WANGZHI @"http://mapi.yinyuetai.com/recommend/video/aggregation.json?D-A=0&%@"
@interface ChannelViewController ()
{
    UICollectionView * _collectionView;
    
    NSMutableArray * _dataArray;
}
@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"频道";
    _dataArray=[[NSMutableArray alloc]init];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.translucent=NO;
    [self createDataSource];
    
    [self createCollectionView];
}

-(void)createCollectionView{

    UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing=10;
    layout.minimumLineSpacing=10;
    _collectionView=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    //注册一个item 相当于tableView  再复用队列里没找到可用的cell的步骤
    [_collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"ID"];
    
    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  _dataArray.count-1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    
    NSDictionary * dic=_dataArray[indexPath.item+1];
    
    [cell.img sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"img"]]];
    
    cell.titleLabel.text=[dic objectForKey:@"title"];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SELFWIDTH.width/2-5, SELFWIDTH.width/2-5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelTableViewController * channelTable=[[ChannelTableViewController alloc]init];
    
    NSDictionary * dic=_dataArray[indexPath.item+1];
    NSString * str=[dic objectForKey:@"id"];
    
    channelTable.titleLabel=[dic objectForKey:@"title"];
    channelTable.IDNumber=str;
    
    [self.navigationController pushViewController:channelTable animated:YES];

}

-(void)createDataSource{

    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:WANGZHI,deviceinfo] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * rootDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        _dataArray=[rootDic objectForKey:@"data"];
//        NSLog(@"%@",_dataArray);
        [self performSelectorOnMainThread:@selector(backMain) withObject:nil waitUntilDone:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(void)backMain{

    [_collectionView reloadData];
    
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
