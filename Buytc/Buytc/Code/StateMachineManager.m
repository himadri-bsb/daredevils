//
//  StateMachineManager.m
//  Buytc
//
//  Created by Jatin Arora on 25/04/15.
//  Copyright (c) 2015 Himadri. All rights reserved.
//

#import "StateMachineManager.h"

@implementation StateMachineManager

+ (StateMachineManager *)sharedInstance {
    static StateMachineManager *myManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myManager = [[StateMachineManager alloc] init];
    });
    return myManager;
}


@end
