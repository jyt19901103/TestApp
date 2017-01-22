//
//  UserModel.h
//  TestInterface
//
//  Created by 蒋月婷 on 17/1/10.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *staus;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSDictionary *header;
@property (nonatomic, copy) NSDictionary *body;
@property (nonatomic, copy) NSString *api;
@property (nonatomic, copy) NSString *isDownload;
    @property (nonatomic, copy) NSString *upload;
@property (nonatomic, copy) NSDictionary *result;
@property (nonatomic, copy) NSError *error;

+ (UserModel *)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
