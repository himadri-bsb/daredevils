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

- (instancetype)init {
    if (self = [super init]) {
        _currentState = StateMachineManager_StateTypeNone;
    }
    
    return self;
}

- (void)manageStatesWithUserReply:(NSString *)userReply {
    NSDictionary *listDictionary = [NSDictionary dictionaryWithContentsOfFile:@"ClothingData"];
    NSArray *statesTraversed = [self calculateStatesTraversedDuringUserReply:userReply];
    
    
    
    switch (self.currentState) {
        case StateMachineManager_StateTypeNone:
        {
            //All states traversal necessary
            self.statesToTraverse = [[NSMutableArray alloc] initWithObjects:@(1), @(2), @(3), @(4), @(5), @(6), nil];
            self.currentState = StateMachineManager_StateTypeGender;
        }
            break;
        case StateMachineManager_StateTypeGender:
        {
            [self.chatDelegate displayText:@"Can i know the gender of the person you are looking clothes for? Male or Female?"];
            self.currentState = StateMachineManager_StateTypeClothingType;
        }
            break;
        case StateMachineManager_StateTypeClothingType:
        {
            [self.chatDelegate displayText:@"What kind of clothing would you like to buy?"];
            self.currentState = StateMachineManager_StateTypeBrands;
        }
            break;
        case StateMachineManager_StateTypeBrands:
        {
            [self.chatDelegate displayText:@"Do you have any brand preference?"];
            self.currentState = StateMachineManager_StateTypeColor;
        }
            break;
        case StateMachineManager_StateTypeColor:
        {
            [self.chatDelegate displayText:@"What colour would you like to get? If any?"];
            
        }
            break;
        case StateMachineManager_StateTypePrice:
        {
            [self.chatDelegate displayText:@"Do you have a maximum price in mind?"];
        }
            break;
        case StateMachineManager_StateTypeCompletion:
        {
            [self.chatDelegate makeHttpCallWithBaseAPI:self.baseAPI parameterDictionary:self.parameterDictionary];
            [self resetStateMachine];
        }
            break;
        default:
            break;
    }
}

- (void)resetStateMachine {
    self.currentState = StateMachineManager_StateTypeNone;
    [self.parameterDictionary removeAllObjects];
    [self.statesToTraverse removeAllObjects];
    self.baseAPI = nil;
}

- (void)userRepliedWithText:(NSString *)reply {
    [self manageStatesWithUserReply:reply];
}

- (NSArray *)calculateStatesTraversedDuringUserReply:(NSString *)userReply {
    
    return nil;
}

@end
