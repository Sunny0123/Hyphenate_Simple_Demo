//
//  AppDelegate.m
//  Hyphenate_test
//
//  Created by Sunny Zhang on 16/10/17.
//  Copyright © 2016年 ZhaiJia. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "ConversationListController.h"
#import "LoginViewController.h"
#import "AppDelegate+EaseMob.h"

@interface AppDelegate ()

@end

#define EaseMobAppKey @"1101161014115255#shuaihuo"
#define APNSCERTNAME_DEV @"Dev_saleTool_push_123"//环信推送开发证书
#define APNSCERTNAME_DIS @"dis_saleTool_push_123"//环信推送 生产证书

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];



    FirstViewController *first = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    first.title = @"首页";
    ConversationListController *list = [[ConversationListController alloc] init];
    list.title = @"聊天";
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil ];
    login.title = @"登录";
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:first];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:list];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:login];

    
    
    UITabBarController *tabb = [[UITabBarController alloc] init];
    NSArray *arr = [[NSArray alloc] initWithObjects:nav1,nav2,nav3, nil];
    tabb.viewControllers     = arr;
    self.window.rootViewController = tabb;
    [self.window makeKeyAndVisible];

    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = APNSCERTNAME_DEV;
#else
    apnsCertName = APNSCERTNAME_DIS;
#endif
    NSString *appkey = EaseMobAppKey;
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:appkey
                apnsCertName:apnsCertName
                 otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    

    
    return YES;
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
}

@end
