//
//  AllViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "AllViewController.h"
#import "AppDelegate.h"
@interface AllViewController ()

@end

@implementation AllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
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
