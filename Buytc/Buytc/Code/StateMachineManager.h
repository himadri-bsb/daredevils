//
//  StateMachineManager.h
//  Buytc
//
//  Created by Jatin Arora on 25/04/15.
//  Copyright (c) 2015 Himadri. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kBrand = @"brands_filter_facet";
static NSString *const kColour = @"colour_family_list";
static NSString *const kPrice = @"discounted_price";
static NSString *const kSize = @"sizes_facet";

static NSString *const kPListSizes = @"Sizes";
static NSString *const kPListTypeOfClothing = @"Type of clothing";
static NSString *const kPListBrands = @"Brands";
static NSString *const kPListGender = @"Gender";
static NSString *const kPListColour = @"Colour";
static NSString *const kPListPrices = @"Prices";

@protocol StateMachineManagerDelegate <NSObject>

- (void)displayText:(NSString *)textToDisplay;

/** Example for complete API:
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
    StateMachineManager_StateTypeSize,
    StateMachineManager_StateTypeCompletion,
};

@interface StateMachineManager : NSObject

@property (nonatomic, weak)  id <StateMachineManagerDelegate> chatDelegate;
@property (nonatomic, assign) StateMachine_StateType currentState;
@property (nonatomic, strong) NSMutableArray *statesToTraverse;
@property (nonatomic, strong) NSMutableDictionary *parameterDictionary;
@property (nonatomic, strong) NSString *baseAPIKeyGender;
@property (nonatomic, strong) NSString *baseAPIKeyStyle;

+ (StateMachineManager *)sharedInstance;
- (void)resetStateMachine;
- (void)userRepliedWithText:(NSString *)reply;
- (NSString *)completeBaseAPI;

@end
