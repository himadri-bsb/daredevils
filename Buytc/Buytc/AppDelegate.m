//
//  AppDelegate.m
//  Buytc
//
//  Created by Himadri Jyoti on 25/04/15.
//  Copyright (c) 2015 Himadri. All rights reserved.
//

#import "AppDelegate.h"
#import "ChatViewController.h"
#import "ChatDataSource.h"
#import <SpeechKit/SpeechKit.h>


//#if DEMO
//const unsigned char SpeechKitApplicationKey[] =
//{
//    0x6f, 0x9e, 0x9f, 0x32, 0xc5, 0xde, 0x6a, 0x4e, 0xad, 0xe3, 0x50, 0x10, 0x5b, 0xf5, 0x8e, 0x2d, 0xd5, 0x29, 0x13, 0xb4, 0x14, 0x81, 0xb9, 0x34, 0xb2, 0xa7, 0x9d, 0xe9, 0x2e, 0x0e, 0x70, 0x9d, 0xad, 0x0f, 0xd0, 0x72, 0xed, 0x3a, 0xc0, 0x9b, 0x1d, 0x10, 0xab, 0x79, 0x06, 0x39, 0xa6, 0xdb, 0x62, 0xb9, 0x8f, 0x77, 0x3a, 0x48, 0xab, 0xed, 0xef, 0x48, 0xd6, 0x1d, 0x57, 0x46, 0xbb, 0x04
//
//};
//
//#else
const unsigned char SpeechKitApplicationKey[] =
{
    0x73, 0xc6, 0x6f, 0xb0, 0x11, 0x35, 0x7b, 0x88, 0x45, 0x72, 0x1d, 0x43, 0x50, 0x28, 0x44, 0x90, 0x26, 0x5e, 0xa6, 0x04, 0x64, 0x86, 0xa7, 0xcb, 0xc2, 0x2c, 0x15, 0xf7, 0x4b, 0xa2, 0x28, 0xbf, 0x69, 0x97, 0x6f, 0x7a, 0xcc, 0xea, 0x03, 0x11, 0x5c, 0x20, 0x54, 0xac, 0x48, 0x98, 0x3c, 0x6e, 0xf6, 0xe3, 0x73, 0x5b, 0x69, 0x1a, 0x26, 0x2b, 0x47, 0x3b, 0x22, 0x92, 0xdd, 0x4b, 0x51, 0x46

};
//#endif

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [ChatDataSource sharedDataSource];
    
    ChatViewController *chatVc = [[ChatViewController alloc] initWithMode:ChatModeBot];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:chatVc];
    [self.window setRootViewController:navVC];

//#if DEMO
//    [SpeechKit setupWithID:@"NMDPTRIAL_himadri_hike_in20150425142038"
//                      host:@"sandbox.nmdp.nuancemobility.net"
//                      port:443
//                    useSSL:NO
//                  delegate:nil];
//
//#else
    [SpeechKit setupWithID:@"NMDPTRIAL_himadrisj20120928234937"
                      host:@"sandbox.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:nil];
//#endif

    // Set earcons to play
    SKEarcon* earconStart	= [SKEarcon earconWithName:@"earcon_listening.wav"];
    SKEarcon* earconStop	= [SKEarcon earconWithName:@"earcon_done_listening.wav"];
    SKEarcon* earconCancel	= [SKEarcon earconWithName:@"earcon_cancel.wav"];

    [SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
    [SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
    [SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[ChatDataSource sharedDataSource] writeDataToMemory];
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
    [[ChatDataSource sharedDataSource] writeDataToMemory];

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
