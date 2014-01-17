//
//  AppDelegate.m
//  ShootingTest
//
//  Created by 遠藤 豪 on 13/09/25.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "AppDelegate.h"
#import "Utils.h"
#import <AppSocially/AppSocially.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"applicaiton:didFinishLaunchingWithOptions");
    // Override point for customization after application launch.
    
    //https://appsocial.ly/v2/526906b9f5eb66c75b0005c6/
    [AppSocially setAPIKey:@"7774ac78f4afd9934a1483eb5485e2d5"];//38abee1be738a828fecc1a56a79d4592"];
    
//RodeoQuest APP's AppSociallyAPIKey and FacebookAppID
//    https://developers.facebook.com/x/apps/487381754714313/dashboard/
    [AppSocially setFacebookAppID:@"487381754714313"];
    
    
    //from:FirstSample by appSocially
    // appearance
//    NSDictionary *attributes = @{UITextAttributeTextColor: [UIColor grayColor],
//                                 UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
//                                 UITextAttributeFont: [UIFont fontWithName:@"Futura-Medium" size:20.0f]};
//    
//    UIImage *barColorImage = [UIImage imageNamed:@"BarColor.png"];
//    [[UINavigationBar appearance] setBackgroundImage:barColorImage
//                                       forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
//    
//    NSString *version = [[UIDevice currentDevice] systemVersion];
//    if (version.floatValue < 7.0) {
//        [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
//    }
    
    
    
    //from:AppSociallyDemoAppDelegate
    
    
    UIColor *baseColor = [UIColor colorWithRed:9.0/255.0 green:187./255.0 blue:198./255.0 alpha:1.0];
    
    NSDictionary *attributes = @{UITextAttributeTextColor:[UIColor whiteColor],
                                 UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
                                 UITextAttributeFont:[UIFont fontWithName:@"Futura-Medium" size:20.0f]};
    
    UIImage *barColorImage = [Utils drawImageOfSize:CGSizeMake(1, 1) andColor:baseColor];
    [[UINavigationBar appearance] setBackgroundImage:barColorImage
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barColorImage
                                            forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitleTextAttributes: @{
                                                            UITextAttributeTextColor: [UIColor whiteColor],
                                                            UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
                                                            }
                                                forState:UIControlStateNormal];
    
    [AppDelegate setupSearchBarStyle];
    [AppDelegate setupSegmentedControlStyle];

    
    return YES;
}


+ (void)setupSearchBarStyle {
    
    UIImage *searchBarImage = [Utils drawImageOfSize:CGSizeMake(320, 44) andColor:[UIColor whiteColor]];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:searchBarImage
                                                   forState:UIControlStateNormal];
    [[UISearchBar appearance] setBackgroundImage:searchBarImage];
}

+ (void)setupSegmentedControlStyle {
    
    UIFont *font = [UIFont fontWithName:@"Futura-Medium" size:18.0f];
    
    UIImage *segmentedSelectedBackground = [Utils drawImageOfSize:CGSizeMake(50, 30) andColor:[UIColor whiteColor]];
    UIImage *segmentedBackground = [Utils drawImageOfSize:CGSizeMake(50, 30) andColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    UIImage *segmentedDividerImage = [Utils drawImageOfSize:CGSizeMake(1, 30) andColor:[UIColor whiteColor]];
    
    UISegmentedControl *segmentedAppearance = [UISegmentedControl appearance];
    [segmentedAppearance setBackgroundImage:segmentedBackground forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [segmentedAppearance setBackgroundImage:segmentedSelectedBackground forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [segmentedAppearance setDividerImage:segmentedDividerImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [segmentedAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor lightGrayColor], UITextAttributeTextColor,
                                                 font, UITextAttributeFont,[NSValue valueWithCGSize:CGSizeMake(0.0,0.0)], UITextAttributeTextShadowOffset,
                                                 nil] forState:UIControlStateNormal];
    
    [segmentedAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor darkGrayColor], UITextAttributeTextColor,
                                                 font, UITextAttributeFont, [NSValue valueWithCGSize:CGSizeMake(0.0,0.0)], UITextAttributeTextShadowOffset,
                                                 nil] forState:UIControlStateSelected];
    
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    //電話がかかってきた時やSMSが来た時
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //ホームボタンが押された時
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //homeボタンが押された時
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didEnterBackground"
                                                        object: nil
                                                      userInfo: nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //バックグランドから
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
