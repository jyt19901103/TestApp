//
//  UserModel.m
//  TestInterface
//
//  Created by 蒋月婷 on 17/1/10.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (UserModel *)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {

        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
