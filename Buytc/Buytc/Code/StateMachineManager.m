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
        //Not using price the key at 4
        _statesToTraverse = [[NSMutableArray alloc] initWithObjects:@(1), @(2), @(3), @(5), @(6), nil];
        _parameterDictionary = [[NSMutableDictionary alloc] init];
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
//            self.currentState = StateMachineManager_StateTypePrice;
            self.currentState = StateMachineManager_StateTypeSize;
        }
            break;
//        case StateMachineManager_StateTypePrice:
//        {
//            [self.chatDelegate displayText:@"Do you have a maximum price in mind?"];
//            self.currentState = StateMachineManager_StateTypeSize;
//        }
            break;
        case StateMachineManager_StateTypeSize:
        {
            [self.chatDelegate displayText:@"Can i know your clothing size?"];
            self.currentState = StateMachineManager_StateTypeCompletion;
        }
            break;
        case StateMachineManager_StateTypeCompletion:
        {
            [self.chatDelegate makeHttpCallWithBaseAPI:[self completeBaseAPI] parameterDictionary:self.parameterDictionary];
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
    //Not using price the key at 4
    self.statesToTraverse = [[NSMutableArray alloc] initWithObjects:@(1), @(2), @(3), @(5), @(6), nil];
}

- (void)userRepliedWithText:(NSString *)reply {
    if ([reply localizedCaseInsensitiveContainsString:@"Cancel"] || [reply localizedCaseInsensitiveContainsString:@"Done"] || [reply localizedCaseInsensitiveContainsString:@"Bye"]) {
        [self.chatDelegate displayText:@"It is always nice talking to you, Himadri"];
        [self resetStateMachine];
    } else {
        [self manageStatesForUserReply:reply];
    }
}

- (NSArray *)calculateStatesTraversedDuringUserReply:(NSString *)userReply {
    NSDictionary *listDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ClothingData" ofType:@"plist"]];
    NSMutableArray *statesTraversedDuringParsingUserReply = [[NSMutableArray alloc] init];
    
    for (NSString *key in listDictionary.allKeys) {
        
        if ([key localizedCaseInsensitiveContainsString:kPListSizes]) {
            
            if ([self parseForNumberInUserReply:userReply forParamDictKey:kSize]) {
                [statesTraversedDuringParsingUserReply addObject:@(StateMachineManager_StateTypeSize)];
            } else if ([self parseForSizeInUserReply:userReply inCollection:listDictionary[key] forParamDictKey:kSize]) {
                [statesTraversedDuringParsingUserReply addObject:@(StateMachineManager_StateTypeSize)];                
            }

        } else if ([key localizedCaseInsensitiveContainsString:kPListTypeOfClothing]) {
            
            if ([self doesAnyKeyExistInUserReply:userReply inCollection:listDictionary[key] forParamDictKey:nil baseAPIKey:@"style"]) {
                [statesTraversedDuringParsingUserReply addObject:@(StateMachineManager_StateTypeClothingType)];
            }
            
        } else if ([key localizedCaseInsensitiveContainsString:kPListBrands]) {
            
            if ([self doesAnyKeyExistInUserReply:userReply inCollection:listDictionary[key] forParamDictKey:kBrand baseAPIKey:nil]) {
                [statesTraversedDuringParsingUserReply addObject:@(StateMachineManager_StateTypeBrands)];
            }
            
        } else if ([key localizedCaseInsensitiveContainsString:kPListGender]) {
            
            if ([self doesAnyKeyExistInUserReply:userReply inCollection:listDictionary[key] forParamDictKey:nil baseAPIKey:@"gender"]) {
                [statesTraversedDuringParsingUserReply addObject:@(StateMachineManager_StateTypeGender)];
            }
            
        } else if ([key localizedCaseInsensitiveContainsString:kPListColour]) {
            
            if ([self doesAnyKeyExistInUserReply:userReply inCollection:listDictionary[key] forParamDictKey:kColour baseAPIKey:nil]) {
                [statesTraversedDuringParsingUserReply addObject:@(StateMachineManager_StateTypeColor)];
            }
            
        }
//        else if ([key localizedCaseInsensitiveContainsString:kPListPrices]) {
//            
//            if ([self parseForNumberInUserReply:userReply forParamDictKey:kPrice]) {
//                [statesTraversedDuringParsingUserReply addObject:@(StateMachineManager_StateTypePrice)];
//            } else if ([self doesAnyKeyExistInUserReply:userReply inCollection:listDictionary[key] forParamDictKey:kPrice baseAPIKey:nil]) {
//                [statesTraversedDuringParsingUserReply addObject:@(StateMachineManager_StateTypePrice)];
//            }
//            
//        }
        else {
            //Do nothing
//            NSAssert(YES, @"key should be one of the specified key names");
        }
    }
    
    return statesTraversedDuringParsingUserReply;
}

- (BOOL)parseForNumberInUserReply:(NSString *)userReply forParamDictKey:(NSString *)paramDictKey {
    
    NSString *trimmedUserReply = [userReply stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:1024 range:NSMakeRange(0, [userReply length])];
    NSUInteger numberSubString = [trimmedUserReply integerValue];
    if (numberSubString == 0) {
        return NO;
    }
    
    
    if ([paramDictKey localizedCaseInsensitiveContainsString:kSize] && numberSubString < 100) {
        [self.parameterDictionary setValue:@(numberSubString) forKey:paramDictKey];
        return YES;
    }
//    } else if ([paramDictKey localizedCaseInsensitiveContainsString:kPrice]){
//        [self.parameterDictionary setValue:@(numberSubString) forKey:paramDictKey];
//        return YES;
//    }

    return NO;
}

- (BOOL)parseForSizeInUserReply:(NSString *)userReply inCollection:(id)collection forParamDictKey:(NSString *)paramDictKey {
    
    for (NSString *string in collection) {
        if ([userReply isEqualToString:string]) {
            [self.parameterDictionary setValue:userReply forKey:paramDictKey];
            return YES;
        }
    }
    
    return NO;
}


- (BOOL)doesAnyKeyExistInUserReply:(NSString *)userReply inCollection:(id)collection forParamDictKey:(NSString *)paramDictKey baseAPIKey:(NSString *)baseAPIKey {
    BOOL doesExist = NO;
    
    /**
     If the baseAPIKey type is of type style then we have to iterate over a dictionary
     else over an array
    **/
    
    if ([baseAPIKey localizedCaseInsensitiveContainsString:@"style"] || [baseAPIKey localizedCaseInsensitiveContainsString:@"gender"]) {
        
        for (NSDictionary *dict in collection) {
            NSString *key = [dict allKeys].firstObject;
            if ([userReply localizedCaseInsensitiveContainsString:key]) {
                doesExist = YES;
                if ([baseAPIKey localizedCaseInsensitiveContainsString:@"gender"]) {
                    self.baseAPIKeyGender = [dict valueForKey:key];
                } else {
                    self.baseAPIKeyStyle = [dict valueForKey:key];
                }

                break;
            }
        }
        
    } else {
        
        //Make brand choosing optional
        if ([paramDictKey isEqualToString:kBrand] && [userReply caseInsensitiveCompare:@"No"] == NSOrderedSame) {
            return YES;
        }
        
        for (NSString *str in collection) {
            if ([userReply localizedCaseInsensitiveContainsString:str]) {
                doesExist = YES;
                if (paramDictKey) {
                    [self.parameterDictionary setValue:str forKey:paramDictKey];
                }
                
                break;
            }
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

- (NSString *)completeBaseAPI {
    return [NSString stringWithFormat:@"%@-%@", self.baseAPIKeyGender, self.baseAPIKeyStyle];
}

@end
