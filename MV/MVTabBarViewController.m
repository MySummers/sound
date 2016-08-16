//
//  MVTabBarViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "MVTabBarViewController.h"
#import "SCNavTabBarController.h"
#import "MVDisplayViewController.h"
#import "AppDelegate.h"

@interface MVTabBarViewController ()<BSShareMenuDelegate>

@end

@implementation MVTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNa];
}

-(void)createNa{
    
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(goNext)];
    
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)goNext{
    BSShareMenu * share=[[BSShareMenu alloc]initWithDelegate:self];
    [share show];
}

-(void)shareMenuSelected:(int)index
{
    AppDelegate * delegate=[UIApplication sharedApplication].delegate;
    
    switch (index) {
        case 1:
            [delegate goIntoMainView:0];
            break;
        case 2:
            [delegate goIntoMainView:1];
            break;
        case 3:
            [delegate goIntoMainView:2];
            break;
        case 4:
            [delegate goIntoMainView:3];
            break;
        case 5:
            [delegate goIntoMainView:4];
            break;
        case 6:
            [delegate goIntoMainView:5];
            break;
            
            
        default:
            break;
    }
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.tabBarController.tabBar.hidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"%@",self.str);
    MVDisplayViewController * one=[[MVDisplayViewController alloc]init];
    one.title=@"全部";
    one.str=[NSString stringWithFormat:@"%@ALL",self.str];
    
    MVDisplayViewController * two=[[MVDisplayViewController alloc]init];
    two.title=@"日本";
    two.str=[NSString stringWithFormat:@"%@JP",self.str];
    
    MVDisplayViewController * three=[[MVDisplayViewController alloc]init];
    three.title=@"韩国";
    three.str=[NSString stringWithFormat:@"%@KR",self.str];
    
    MVDisplayViewController * four=[[MVDisplayViewController alloc]init];
    four.title=@"内地";
    four.str=[NSString stringWithFormat:@"%@ML",self.str];
    
    MVDisplayViewController * five=[[MVDisplayViewController alloc]init];
    five.title=@"欧美";
    five.str=[NSString stringWithFormat:@"%@US",self.str];
    
    //    [self.view addSubview:one.view];
    SCNavTabBarController * navTabBarController=[[SCNavTabBarController alloc]init];
    navTabBarController.subViewControllers=@[one,two,three,four,five];
    navTabBarController.showArrowButton=YES;
    [navTabBarController addParentController:self];

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
