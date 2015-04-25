//
//  StateMachineManager.h
//  Buytc
//
//  Created by Jatin Arora on 25/04/15.
//  Copyright (c) 2015 Himadri. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kBrand = @"brands_filter_face";
static NSString *const kColour = @"colour_family_list";
static NSString *const kPrice = @"discounted_price";
static NSString *const kSize = @"sizes_facet";

@protocol StateMachineManagerDelegate <NSObject>

- (void)displayText:(NSString *)textToDisplay;
/**
 http://developer.myntra.com/search/data/men-casual-shirts?f=discounted_price%3A849%2C849%3A%3Aglobal_attr_article_type_facet%3AShirts%3A%3Abrands_filter_facet%3A883%20Police&p=1&userQuery=false
 **/
- (void)makeHttpCallWithBaseAPI:(NSString *)baseAPI parameterDictionary:(NSDictionary *)parameterDictionary;

@end

typedef NS_ENUM(NSUInteger, StateMachine_StateType) {
    StateMachineManager_StateTypeNone = 0,
    StateMachineManager_StateTypeGender,
    StateMachineManager_StateTypeClothingType,
    StateMachineManager_StateTypeBrands,
    StateMachineManager_StateTypePrice,
    StateMachineManager_StateTypeColor,
    StateMachineManager_StateTypeCompletion,
};

@interface StateMachineManager : NSObject

+ (StateMachineManager *)sharedInstance;
- (void)resetStateMachine;
- (void)userRepliedWithText:(NSString *)reply;

@property (nonatomic, strong) NSMutableArray *statesToTraverse;

@end
