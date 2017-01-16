//
//  HttpsManager.h
//  TestInterface
//
//  Created by 蒋月婷 on 17/1/5.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpsManager : NSObject
#define kTimeOutInterval 30 // 请求超时的时间
typedef void (^SuccessBlock)(NSDictionary *dict, BOOL success); // 访问成功block
typedef void (^AFNErrorBlock)(NSError *error); // 访问失败block
+ (void)httpPostRequest:(NSString *)url  Parameters:(NSDictionary *)params WithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure;
+ (void)httpPostTokenRequest:(NSString *)url  Parameters:(NSDictionary *)params WithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)httpGetRequest:(NSString *)url  Parameters:(NSDictionary *)params WithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure;


+ (void)httpDeleteRequest:(NSString *)url  Parameters:(NSDictionary *)params WithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure;
+ (void)httpPutRequest:(NSString *)url  Parameters:(NSDictionary *)params WithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure;


+ (void)httpPostRequest:(NSString *)url  Parameters:(NSDictionary *)params WithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure statusCode:(void (^)(NSInteger statusCode))statusCode
;
@end
