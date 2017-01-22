//
//  HttpRequest.h
//  TestInterface
//
//  Created by 蒋月婷 on 17/1/5.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpRequest : NSObject
typedef enum RequestTypes{
    GET,
    POST,
    PUT,
    DELETE
    
}RequestType;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (void)httpRequest:(NSString *)url RequestType:(NSString *)type Header:(NSDictionary *)headers Parameters:(NSDictionary *)params  WithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

+ (void)httpRequest:(NSString *)url
        RequestType:(NSString *)type
             Header:(NSDictionary *)headers
         Parameters:(NSDictionary *)params
        WithSuccess:(void (^)(id result))success
            failure:(void (^)(NSError *error))failure
         statusCode:(void (^)(NSInteger statusCode))statusCode;

+ (void)httpOtherRequest:(NSString *)url
             RequestType:(NSString *)type
                  Header:(NSDictionary *)headers
              Parameters:(NSDictionary *)params
             WithSuccess:(void (^)(id result))success
                 failure:(void (^)(NSError *error))failure
              statusCode:(void (^)(NSInteger statusCode))statusCode;

+ (void)uploadFile:(NSString *)url
            Header:(NSDictionary *)headers
       WithSuccess:(void (^)(id result))success
           failure:(void (^)(NSError *error))failure
        statusCode:(void (^)(NSInteger statusCode))statusCode;

@end
