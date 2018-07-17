//
//  AppDelegate.m
//  LMNoteDemo
//
//  Created by littleMeaning on 2018/1/10.
//  Copyright © 2018年 littleMeaning. All rights reserved.
//

#import "AppDelegate.h"
#import "FolderViewController.h"

@import LMNote;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    FolderViewController *rootViewController = [[FolderViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
