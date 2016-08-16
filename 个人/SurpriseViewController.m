//
//  SurpriseViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/28.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "SurpriseViewController.h"
#import "SurpriseCollectionReusableView.h"
#import "SurpriseCollectionViewCell.h"
#import "StoryViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#define STORY @"http://mobile.ximalaya.com/m/explore_user_index?device=android&page=1"
@interface SurpriseViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView * _collectionView;
    
    NSMutableArray * _xiangxiArray;
    
    NSMutableArray * _nameAndLogoArray;
}
@end

@implementation SurpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _xiangxiArray=[[NSMutableArray alloc]init];
    _nameAndLogoArray=[[NSMutableArray alloc]init];
    [self createDataSource];
    
    [self createCollectionView];
}

-(void)createCollectionView{

    UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc]init];
    
    layout.minimumLineSpacing=20;
    layout.minimumInteritemSpacing=0;
    layout.itemSize=CGSizeMake(118, 148);
    layout.headerReferenceSize=CGSizeMake(0, 40);
    
    _collectionView=[[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[SurpriseCollectionViewCell class] forCellWithReuseIdentifier:@"collectCellll"];
    
    [_collectionView registerClass:[SurpriseCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"headerrrr"];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _nameAndLogoArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SurpriseCollectionReusableView * reusable=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerrrr" forIndexPath:indexPath];
    reusable.backgroundColor=[UIColor whiteColor];
    
    reusable.titleLabel.text=[_nameAndLogoArray[indexPath.section]objectForKey:@"title"];
    
    return reusable;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SurpriseCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectCellll" forIndexPath:indexPath];
    NSDictionary * dic=_nameAndLogoArray[indexPath.section];
    _xiangxiArray=[dic objectForKey:@"list"];
    NSDictionary * dictionary=_xiangxiArray[indexPath.item];
    
    [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:[dictionary objectForKey:@"smallLogo"]]];
    cell.nameLabel.text=[dictionary objectForKey:@"nickname"];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoryViewController * story=[[StoryViewController alloc]init];
    
    NSDictionary * dic=_nameAndLogoArray[indexPath.section];
    _xiangxiArray=[dic objectForKey:@"list"];
    NSDictionary * dictionary=_xiangxiArray[indexPath.item];
    
    story.uid=[dictionary objectForKey:@"uid"];
    
    [self.navigationController pushViewController:story animated:YES];
}

-(void)createDataSource{

    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager GET:STORY parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * rootDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSArray * array=[rootDic objectForKey:@"list"];
        _nameAndLogoArray=[rootDic objectForKey:@"list"];
//        for (NSDictionary * dic in array) {
//            [_titleArray addObject:[dic objectForKey:@"title"]];
////            [_nameAndLogoArray addObject:[dic objectForKey:@"list"]];
//        }
//        NSLog(@"%@",_titleArray);
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
