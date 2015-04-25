//
//  StateMachineManager.h
//  Buytc
//
//  Created by Jatin Arora on 25/04/15.
//  Copyright (c) 2015 Himadri. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, StateMachine_StateType) {
    StateMachine_StateTypeCategory = 0,
};

@interface StateMachineManager : NSObject

+ (StateMachineManager *)sharedInstance;
@property (nonatomic, strong) NSMutableArray *statesToTraverse;

@end
