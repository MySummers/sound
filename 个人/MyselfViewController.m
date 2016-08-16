//
//  MyselfViewController.m
//  忆首歌
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "MyselfViewController.h"
#import "MyCollectViewController.h"
#import "SoftwareInformationViewController.h"
#import "SurpriseViewController.h"
#import "IGLDropDownMenu.h"
#import "WKAlertView.h"
@interface MyselfViewController ()<IGLDropDownMenuDelegate>
{
    IGLDropDownMenu * _dropDownMenu;

    UIWindow * _sheetWindow;
}
@end

@implementation MyselfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人主页";
    self.view.backgroundColor=[UIColor yellowColor];
    
    [self createBackdrop];
    
    [self createZiDingYi];
}

-(void)createBackdrop{

    UIImageView * backdrop=[[UIImageView alloc]initWithFrame:self.view.frame];
    backdrop.image=[UIImage imageNamed:@"rrr.jpeg"];
    [self.view addSubview:backdrop];
    
}

-(void)createZiDingYi{

    NSArray * dataArray=@[@{@"image":@"sun.png",@"title":@"我的收藏"},
                          @{@"image":@"clouds.png",@"title":@"清除缓存"},
                          @{@"image":@"snow.png",@"title":@"软件信息"},
                          @{@"image":@"windy.png", @"title":@"点击有惊喜哦"}];
    NSMutableArray * dropdownItems=[[NSMutableArray alloc]init];
    for (int i=0; i<dataArray.count; i++) {
        NSDictionary * dic=dataArray[i];
        
        IGLDropDownItem * item=[[IGLDropDownItem alloc]init];
        [item setIconImage:[UIImage imageNamed:dic[@"image"]]];
        [item setText:dic[@"title"]];
        [dropdownItems addObject:item];
    }
    _dropDownMenu=[[IGLDropDownMenu alloc]init];
    _dropDownMenu.menuText=@"系统选项";
    _dropDownMenu.dropDownItems=dropdownItems;
    _dropDownMenu.paddingLeft=15;
    [_dropDownMenu setFrame:CGRectMake(80, 144, 200, 45)];
    _dropDownMenu.delegate=self;
    _dropDownMenu.type=IGLDropDownMenuTypeStack;
    _dropDownMenu.gutterY=5;
    _dropDownMenu.itemAnimationDelay=0.1;
    _dropDownMenu.rotate=IGLDropDownMenuRotateRandom;
    [_dropDownMenu reloadView];
    [self.view addSubview:_dropDownMenu];
}

-(void)selectedItemAtIndex:(NSInteger)index
{
    if (index==0) {
        MyCollectViewController * collect=[[MyCollectViewController alloc]init];
        [self.navigationController pushViewController:collect animated:YES];
        _dropDownMenu.expanding=NO;
    }else if (index==1){
        NSString * path=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        NSFileManager * manager=[NSFileManager defaultManager];
        CGFloat size=[self folderSizeAtPath:path];
        [manager removeItemAtPath:path error:nil];
        
        NSString * detail=[NSString stringWithFormat:@"清除%.2fM数据",size];
        
        _sheetWindow=[WKAlertView showAlertViewWithStyle:WKAlertViewStyleDefalut title:@"清除缓存成功" detail:detail canleButtonTitle:nil okButtonTitle:@"确定" callBlock:^(MyWindowClick buttonIndex) {
            _sheetWindow.hidden=YES;
            _sheetWindow=nil;
        }];
        
        
    }else if (index==2){
        SoftwareInformationViewController * software=[[SoftwareInformationViewController alloc]init];
        [self.navigationController pushViewController:software animated:YES];
    }else if (index==3){
        SurpriseViewController * surprise=[[SurpriseViewController alloc]init];
        [self.navigationController pushViewController:surprise animated:YES];
    }

}

- (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
    
}
//单个文件的大小

- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
    
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
