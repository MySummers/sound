//
//  AppDelegate.m
//  忆首歌
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 sy. All rights reserved.
//

#import "AppDelegate.h"
#import "AllViewController.h"
#import "StationViewController.h"
#import "MyselfViewController.h"
#import "MusicFormViewController.h"
#import "ChannelViewController.h"

#import "EligibleListViewController.h"

#import "MVTabBarViewController.h"
#import "MVYourLoveViewController.h"
@interface AppDelegate ()
{
    StationViewController * _station;
    
    MyselfViewController * _myself;
    
    MusicFormViewController * _music;
    
    ChannelViewController * _channel;
    
    
    EligibleListViewController * _eligibeList;
    
    NSArray * _array;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    _station=[[StationViewController alloc]init];
    UINavigationController * naVC1=[[UINavigationController alloc]initWithRootViewController:_station];
    
    _myself=[[MyselfViewController alloc]init];
    UINavigationController * naVC2=[[UINavigationController alloc]initWithRootViewController:_myself];
    
    _music=[[MusicFormViewController alloc]init];
    UINavigationController * naVC3=[[UINavigationController alloc]initWithRootViewController:_music];
    
    _channel=[[ChannelViewController alloc]init];
    UINavigationController * naVC4=[[UINavigationController alloc]initWithRootViewController:_channel];

    
    _eligibeList=[[EligibleListViewController alloc]init];
    UINavigationController * naVC6=[[UINavigationController alloc]initWithRootViewController:_eligibeList];
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
/**************************************************/
    MVTabBarViewController * one=[[MVTabBarViewController alloc]init];
    one.str=@"";
    one.title=@"MV热播";
    UITabBarItem * item1=[[UITabBarItem alloc]initWithTitle:@"" image:[UIImage imageNamed:@"tabbar_mv@2x"] selectedImage:[UIImage imageNamed:@"tabbar_mv_press@2x"]];
    one.tabBarItem=item1;
    one.tabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
//    one.tabBarItem.image=[UIImage imageNamed:@"tabbar_mv@2x"];
//    one.tabBarItem.selectedImage=[UIImage imageNamed:@"tabbar_mv_press@2x"];
    UINavigationController * oneVC=[[UINavigationController alloc]initWithRootViewController:one];
    
    MVTabBarViewController * two=[[MVTabBarViewController alloc]init];
    two.title=@"今日热播";
    UITabBarItem * item2=[[UITabBarItem alloc]initWithTitle:@"" image:[UIImage imageNamed:@"tabbar_hot@2x"] selectedImage:[UIImage imageNamed:@"tabbar_hot_press@2x"]];
    two.tabBarItem=item2;
    two.tabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
    UINavigationController * oneVC1=[[UINavigationController alloc]initWithRootViewController:two];
    
    MVTabBarViewController * three=[[MVTabBarViewController alloc]init];
    three.title=@"正在流行";
    three.str=@"POP_";
    UITabBarItem * item3=[[UITabBarItem alloc]initWithTitle:@"" image:[UIImage imageNamed:@"tabbar_pop@2x"] selectedImage:[UIImage imageNamed:@"tabbar_pop_press@2x"]];
    three.tabBarItem=item3;
    three.tabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
    UINavigationController * oneVC2=[[UINavigationController alloc]initWithRootViewController:three];
    
    MVYourLoveViewController * youLove=[[MVYourLoveViewController alloc]init];
    youLove.title=@"猜你喜欢";
    UITabBarItem * item4=[[UITabBarItem alloc]initWithTitle:@"" image:[UIImage imageNamed:@"tabbar_favorite@2x"] selectedImage:[UIImage imageNamed:@"tabbar_favorite_press@2x"]];
    youLove.tabBarItem=item4;
    youLove.tabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
    UINavigationController * youLoveVC=[[UINavigationController alloc]initWithRootViewController:youLove];
    
    UITabBarController * tabBarController=[[UITabBarController alloc]init];
    tabBarController.viewControllers=@[oneVC,oneVC1,oneVC2,youLoveVC];
    
    
    self.window.rootViewController=tabBarController;
        
    [self.window makeKeyAndVisible];
    _array=@[naVC1,naVC2,naVC3,naVC4,tabBarController,naVC6];
    return YES;
}

-(void)goIntoMainView:(int)number{
    
    self.window.rootViewController=_array[number];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "-000phone.com.___" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"___" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"___.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
