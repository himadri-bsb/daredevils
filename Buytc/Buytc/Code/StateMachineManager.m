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
        _statesToTraverse = [[NSMutableArray alloc] initWithObjects:@(1), @(2), @(3), @(4), @(5), @(6), nil];
    }
    
    return self;
}

- (void)manageStatesForUserReply:(NSString *)userReply {
    
    NSArray *statesTraversed = [self calculateStatesTraversedDuringUserReply:userReply];
    
    //Calculate new states after calculating states traversed because of this reply, this method also filters statesToTraverse array
    StateMachine_StateType newCurrentState = [self calculateNewCurrentStateAfterStatesTraversed:statesTraversed];
    
    if (newCurrentState != StateMachineManager_StateTypeNone) {
        self.currentState = newCurrentState;
    }
    
    switch (self.currentState) {
        case StateMachineManager_StateTypeNone:
        {
            //All states traversal necessary when starting from none
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
            self.currentState = StateMachineManager_StateTypePrice;
        }
            break;
        case StateMachineManager_StateTypePrice:
        {
            [self.chatDelegate displayText:@"Do you have a maximum price in mind?"];
            self.currentState = StateMachineManager_StateTypeSize;
        }
            break;
        case StateMachineManager_StateTypeSize:
        {
            [self.chatDelegate displayText:@"What's your size?"];
            self.currentState = StateMachineManager_StateTypeCompletion;
        }
            break;
        case StateMachineManager_StateTypeCompletion:
        {
            [self.chatDelegate makeHttpCallWithBaseAPI:self.completeBaseAPI parameterDictionary:self.parameterDictionary];
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
    self.baseAPIKeyGender = nil;
    self.baseAPIKeyStyle = nil;
    self.completeBaseAPI = nil;
    self.statesToTraverse = [[NSMutableArray alloc] initWithObjects:@(1), @(2), @(3), @(4), @(5), @(6), nil];
}

- (void)userRepliedWithText:(NSString *)reply {
    [self manageStatesForUserReply:reply];
}

- (NSArray *)calculateStatesTraversedDuringUserReply:(NSString *)userReply {
    NSDictionary *listDictionary = [NSDictionary dictionaryWithContentsOfFile:@"ClothingData"];
    NSMutableArray *statesTraversedDuringParsingUserReply = [[NSMutableArray alloc] init];
    
    for (NSString *key in listDictionary.allKeys) {
        
        if ([key isEqualToString:kPListSizes]) {
            
            if ([self doesAnyKeyExistInUserReply:userReply inArray:listDictionary[key] forParamDictKey:kSize baseAPIKey:nil]) {
                [statesTraversedDuringParsingUserReply addObject:@(StateMachineManager_StateTypeSize)];
            }

        } else if ([key isEqualToString:kPListTypeOfClothing]) {
            
            if ([self doesAnyKeyExistInUserReply:userReply inArray:listDictionary[key] forParamDictKey:nil baseAPIKey:@"style"]) {
                [statesTraversedDuringParsingUserReply addObject:@(StateMachineManager_StateTypeClothingType)];
            }
            
        } else if ([key isEqualToString:kPListBrands]) {
            
            if ([self doesAnyKeyExistInUserReply:userReply inArray:listDictionary[key] forParamDictKey:kBrand baseAPIKey:nil]) {
                [statesTraversedDuringParsingUserReply addObject:@(StateMachineManager_StateTypeBrands)];
            }
            
        } else if ([key isEqualToString:kPListGender]) {
            
            if ([self doesAnyKeyExistInUserReply:userReply inArray:listDictionary[key] forParamDictKey:nil baseAPIKey:@"gender"]) {
                [statesTraversedDuringParsingUserReply addObject:@(StateMachineManager_StateTypeGender)];
            }
            
        } else if ([key isEqualToString:kPListColour]) {
            
            if ([self doesAnyKeyExistInUserReply:userReply inArray:listDictionary[key] forParamDictKey:kColour baseAPIKey:nil]) {
                [statesTraversedDuringParsingUserReply addObject:@(StateMachineManager_StateTypeColor)];
            }
            
        } else if ([key isEqualToString:kPListPrices]) {
            
            if ([self doesAnyKeyExistInUserReply:userReply inArray:listDictionary[key] forParamDictKey:kPrice baseAPIKey:nil]) {
                [statesTraversedDuringParsingUserReply addObject:@(StateMachineManager_StateTypePrice)];
            }
            
        } else {
            NSAssert(YES, @"key should be one of the specified key names");
        }
    }
    
    return statesTraversedDuringParsingUserReply;
}

- (BOOL)doesAnyKeyExistInUserReply:(NSString *)userReply inArray:(NSArray *)array forParamDictKey:(NSString *)paramDictKey baseAPIKey:(NSString *)baseAPIKey {
    BOOL doesExist = NO;
    for (NSString *str in array) {
        if ([userReply containsString:str]) {
            doesExist = YES;
            if (paramDictKey) {
                [self.parameterDictionary setValue:str forKey:paramDictKey];
            } else {
                if ([baseAPIKey isEqualToString:@"style"]) {
                    self.baseAPIKeyStyle = str;
                } else {
                    self.baseAPIKeyGender =str;
                }
            }
            
            break;
        }
    }
    
    return doesExist;
}

- (StateMachine_StateType)calculateNewCurrentStateAfterStatesTraversed:(NSArray *)statesTraversed {
    [self.statesToTraverse removeObjectsInArray:statesTraversed];
    StateMachine_StateType stateType = StateMachineManager_StateTypeNone;
    
    //No states left to traverse, this sentence had everything we needed
    if (self.statesToTraverse.count == 0) {
        stateType = StateMachineManager_StateTypeCompletion;
    } else {
        stateType = ((NSNumber *)[self.statesToTraverse firstObject]).integerValue;
    }
    
    return stateType;
}

@end
