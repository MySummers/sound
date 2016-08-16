//
//  StationDianJiViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/26.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "StationDianJiViewController.h"
#import "StationCollectionViewCell.h"
#import "AudioFrequencyViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#define WANGZHI @"http://api2.pianke.me/ting/radio_detail"
@interface StationDianJiViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView * _collectionView;
    
    NSMutableArray * _dataArray;
    
    NSMutableDictionary * _radioDictionary;

}
@end

@implementation StationDianJiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray=[[NSMutableArray alloc]init];
    _radioDictionary=[[NSMutableDictionary alloc]init];
//    NSLog(@"%@",self.radioid);
    self.view.backgroundColor=[UIColor whiteColor];
    [self createDataSource];
    
    [self createCollectionView];
    
//    [self createHead];
}

-(void)createCollectionView{

    UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(self.view.frame.size.width/3+50, self.view.frame.size.height/4);
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing=10;
    layout.minimumLineSpacing=10;
    
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, SELFWIDTH.height/4+25, SELFWIDTH.width, SELFWIDTH.height-SELFWIDTH.height/4-25) collectionViewLayout:layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor=[UIColor whiteColor];
    [_collectionView registerClass:[StationCollectionViewCell class] forCellWithReuseIdentifier:@"ID"];
    
    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StationCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    
    NSDictionary * dic=_dataArray[indexPath.item];
//    NSLog(@"%@",dic);
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"coverimg"]]];
    cell.titleLabel.text=[dic objectForKey:@"title"];
    cell.countLabel.text=[NSString stringWithFormat:@"🎶%@",[dic objectForKey:@"musicVisit"]];
    cell.smallImage.image=[UIImage imageNamed:@"iconfont-erji.png"];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AudioFrequencyViewController * audioFrequency=[[AudioFrequencyViewController alloc]init];
    
    NSDictionary * dic=_dataArray[indexPath.item];
    NSString * str=[dic objectForKey:@"musicUrl"];
//    NSLog(@"%@",str);
    audioFrequency.musicUrl=str;
    audioFrequency.circularImage=[dic objectForKey:@"coverimg"];
    audioFrequency.titleLabel=[dic objectForKey:@"title"];
    [self.navigationController pushViewController:audioFrequency animated:YES];
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake((SELFWIDTH.width-30)/2, 130);
//}


-(void)createDataSource{

    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
//    NSLog(@"lllll");
    NSDictionary *dict = @{@"radioid":[NSString stringWithFormat:@"%@",self.radioid],@"start":@"0",@"client":@"2",@"limit":@"10"};

    [manager POST:WANGZHI parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * rootDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",rootDic);
        NSDictionary * dic=[rootDic objectForKey:@"data"];
        _dataArray=[dic objectForKey:@"list"];
        _radioDictionary=[dic objectForKey:@"radioInfo"];
        
        [self performSelectorOnMainThread:@selector(backMain) withObject:nil waitUntilDone:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
//    [self createHead];
}

-(void)backMain{

    [_collectionView reloadData];
    
    [self createHead];
}

-(void)createHead{
   
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SELFWIDTH.height/4+94)];
    view.backgroundColor=[UIColor whiteColor];
    
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SELFWIDTH.width, SELFWIDTH.height/4)];

    [imageView sd_setImageWithURL:[NSURL URLWithString:[_radioDictionary objectForKey:@"coverimg"]]];
    [view addSubview:imageView];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, SELFWIDTH.height/4+74, SELFWIDTH.width, 20)];
    NSString * str=[NSString stringWithFormat:@"🎵%@",[_radioDictionary objectForKey:@"title"]];
//    NSLog(@"%@",[_radioDictionary objectForKey:@"title"]);
    label.text=str;
    [view addSubview:label];
    
    [self.view addSubview:view];
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
