//
//  CardModel.m
//  Buytc
//
//  Created by Himadri Jyoti on 25/04/15.
//  Copyright (c) 2015 Himadri. All rights reserved.
//

#import "CardModel.h"


@implementation CardModel

- (NSString *)description {
    return [NSString stringWithFormat:@"\nName=%@,\nURL=%@,\nprice=%@,\nsize=%@,\ndiscount=%@",self.itemBrandName,self.imageUrl,self.price,self.size,self.disCount];
}

@end
