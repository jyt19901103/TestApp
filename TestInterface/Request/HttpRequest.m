//
//  HttpRequest.m
//  TestInterface
//
//  Created by 蒋月婷 on 17/1/10.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import "HttpRequest.h"


@implementation HttpRequest


#pragma mark - 创建请求者
+ (AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
        // 声明获取到的数据格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:@"Authorization"];
    
    return manager;
}


+ (void)httpRequest:(NSString *)url
        RequestType:(NSString *)type
             Header:(NSDictionary *)headers
         Parameters:(NSDictionary *)params
        WithSuccess:(void (^)(id result))success 
            failure:(void (^)(NSError *error))failure
         statusCode:(void (^)(NSInteger statusCode))statusCode{
//    NSLog(@"url为   %@",url);
    
    AFHTTPSessionManager *manager = [self manager];
    
    for (NSString *key in [headers allKeys]) {
        [manager.requestSerializer setValue:[headers valueForKey:key] forHTTPHeaderField:key];
    }
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:type URLString:url parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)response;
        statusCode(responses.statusCode);
        if (success) {
            success(responseObject);
        }
        if (failure) {
            failure(error);

        }
    }];

    
    [dataTask resume];
}
#pragma mark - GET Request type as string
- (NSString *)getStringForRequestType:(RequestType)type {
    
    NSString *requestTypeString;
    
    switch (type) {
        case GET:
            requestTypeString = @"GET";
            break;
            
        case POST:
            requestTypeString = @"POST";
            break;
            
        case PUT:
            requestTypeString = @"PUT";
            break;
            
        case DELETE:
            requestTypeString = @"DELETE";
            break;
            
        default:
            requestTypeString = @"GET";
            break;
    }
    
    return requestTypeString;
}

/* 使用NSURLSessionUploadTask上传文件 */
- (void)uploadFile:(id)sender {
    NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSData *data ;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //.......
    }];
    [uploadTask resume];
}

@end
