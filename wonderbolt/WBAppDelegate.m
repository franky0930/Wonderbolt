//
// WBAppDelegate.m
// wonderbolt
//
// Created by Peter Kazazes on 11/9/13.
// Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import "WBAppDelegate.h"
#import "WBHomeViewController.h"
#import "WBDataManager.h"
#import "Appirater.h"
#import "TestFlight.h"
#import "Flurry.h"

#import <Crashlytics/Crashlytics.h>

@interface WBAppDelegate ()
@end

@implementation WBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // http://www.testflightapp.com/sdk/
    // [TestFlight takeOff:@"3d0b4f0d-3304-43ea-8be0-2e344b294d43"];
#ifdef WB_CRASHLYTICS_ENABLED
    [Crashlytics startWithAPIKey:WB_CRASHLYTICS_API_KEY];
#endif
    
    [[WBDataManager sharedInstance] setupDB];
    
    [Appirater appLaunched:YES];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    [Flurry startSession:@"7HNSM5KZGWJRHXDR72W2"];
    [Flurry logAllPageViewsForTarget:self.window.rootViewController.tabBarController];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[WBDataManager sharedInstance] saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[WBDataManager sharedInstance] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[WBDataManager sharedInstance] saveContext];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end