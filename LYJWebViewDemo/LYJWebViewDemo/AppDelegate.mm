//
//  AppDelegate.m
//  LYJWebViewDemo
//
//  Created by 娇 on 2019/3/1.
//  Copyright © 2019年 yunli. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "JSCacheUtil.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [JSCacheUtil saveJSFile:@[@"https://ylxdcdn.yunlibeauty.com/pro/apply/vendor_7e308103.js", @"https://ylxdcdn.yunlibeauty.com/pro/apply/app_56524d74.js", @"https://ylxdcdn.yunlibeauty.com/javascripts/dist/jsweixin-1.1.0.js", @"https://g.alicdn.com/sd/nch5/index.js?t=2019042310", @"https://ylxdcdn.yunlibeauty.com/javascripts/app/__build__/main.44a81a5e22b10c46941c.js"]];
    [JSCacheUtil saveCSSFile:@[@"https://ylxdcdn.yunlibeauty.com/stylesheets/style/style.css", @"https://ylxdcdn.yunlibeauty.com/stylesheets/dist/slick.css"]];

    ViewController* webVC = [[ViewController alloc] initWithUrl:@""];
    webVC.useCustomNav = NO;
    UINavigationController* vc = [[UINavigationController alloc] initWithRootViewController:webVC];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
