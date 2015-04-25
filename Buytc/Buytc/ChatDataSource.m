//
//  ChatDataSource.m
//  Buytc
//
//  Created by Vijay on 25/04/15.
//  Copyright (c) 2015 Himadri. All rights reserved.
//

#import "ChatDataSource.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "CardModel.h"

@interface ChatDataSource ()
@property (nonatomic,strong) NSString *filePath;
@end
@implementation ChatDataSource

+ (id)sharedDataSource {
    static ChatDataSource *sharedDataSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataSource = [[ChatDataSource alloc] init];
    });
    return sharedDataSource;
}

- (id)init {
    if (self = [super init]) {
        _dataArray = [[NSMutableArray alloc] init];
        [_dataArray addObjectsFromArray:[NSArray arrayWithContentsOfFile:self.filePath]];
    }
    return self;
}

- (void)addMessage:(UUMessage *)message {
    [self.dataArray addObject:message];
}

- (void)writeDataToMemory {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.dataArray writeToFile:self.filePath atomically:YES];
    });
    
}

- (NSString *)filePath {
    if (_filePath) {
        return  _filePath;
    }
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolder = [path objectAtIndex:0];
    _filePath = [documentFolder stringByAppendingPathComponent:@"Database.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:_filePath contents:nil attributes:nil];
    }
    
    return _filePath;
}

- (void)addSpecifiedItem:(NSDictionary *)dic
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = @"http://img0.bdstatic.com/img/image/shouye/xinshouye/mingxing16.jpg";
    if([dataDic objectForKey:@"from"]) {
        [dataDic setObject:[dataDic objectForKey:@"from"] forKey:@"from"];
    }
    else {
        [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    }

    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
    [dataDic setObject:@"Me" forKey:@"strName"];
    [dataDic setObject:URLStr forKey:@"strIcon"];
    
    [self.dataArray addObject:dataDic];
    //[self writeDataToMemory];
}

- (void)addCard:(CardModel *)card {
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [dataDict setObject:card.itemBrandName forKey:@"brandName"];
    [dataDict setObject:card.imageUrl forKey:@"imageUrl"];
    [dataDict setObject:card.price forKey:@"price"];
    [dataDict setObject:card.size forKey:@"size"];
    [dataDict setObject:card.disCount forKey:@"discount"];
    [dataDict setObject:@(UUMessageFromOther) forKey:@"from"];
    [dataDict setObject:@(UUMessageTypeCard) forKey:@"type"];
    
    [self.dataArray addObject:dataDict];
    //[self writeDataToMemory];
}

@end
