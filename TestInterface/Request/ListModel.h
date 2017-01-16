//
//  ListModel.h
//  TestInterface
//
//  Created by 蒋月婷 on 17/1/12.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *array;

@property (nonatomic, copy) NSArray *Token;
@property (nonatomic, copy) NSArray *Chat;
@property (nonatomic, copy) NSArray *ChatGroup;
@property (nonatomic, copy) NSArray *ChatRoom;
@property (nonatomic, copy) NSArray *Users;


+ (ListModel *)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
