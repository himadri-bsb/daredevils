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

const unsigned char SpeechKitApplicationKey[] =
{
    0x73, 0xc6, 0x6f, 0xb0, 0x11, 0x35, 0x7b, 0x88, 0x45, 0x72, 0x1d, 0x43, 0x50, 0x28, 0x44, 0x90, 0x26, 0x5e, 0xa6, 0x04, 0x64, 0x86, 0xa7, 0xcb, 0xc2, 0x2c, 0x15, 0xf7, 0x4b, 0xa2, 0x28, 0xbf, 0x69, 0x97, 0x6f, 0x7a, 0xcc, 0xea, 0x03, 0x11, 0x5c, 0x20, 0x54, 0xac, 0x48, 0x98, 0x3c, 0x6e, 0xf6, 0xe3, 0x73, 0x5b, 0x69, 0x1a, 0x26, 0x2b, 0x47, 0x3b, 0x22, 0x92, 0xdd, 0x4b, 0x51, 0x46

};

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [ChatDataSource sharedDataSource];
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    [self.window setRootViewController:chatVC];

    [SpeechKit setupWithID:@"NMDPTRIAL_himadrisj20120928234937"
                      host:@"sandbox.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:nil];

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
