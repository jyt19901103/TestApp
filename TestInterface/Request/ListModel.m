//
//  ListModel.m
//  TestInterface
//
//  Created by 蒋月婷 on 17/1/12.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel
+ (ListModel *)modelWithDict:(NSArray *)dict
{
    return [[self alloc]initWithDict:dict];
}

- (instancetype)initWithDict:(NSArray *)dict
{
    self = [super init];
    if (self) {
        //        NSString * header = [dict objectForKey:@"header"];
        //        NSString * body = [dict objectForKey:@"body"];
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
