//
//  HttpsManager.m
//  TestInterface
//
//  Created by 蒋月婷 on 17/1/5.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import "HttpsManager.h"
#import "AFURLSessionManager.h"


@implementation HttpsManager
#pragma mark - 创建请求者
+ (AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    
    // 声明获取到的数据格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:@"Authorization"];

    return manager;
}

//get
+ (void)httpGetRequest:(NSString *)url  Parameters:(NSDictionary *)params WithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
    NSLog(@"url为   %@",url);

    AFHTTPSessionManager *manager = [self manager];

    [manager GET:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}

//post
+ (void)httpPostRequest:(NSString *)url  Parameters:(NSDictionary *)params WithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure statusCode:(void (^)(NSInteger statusCode))statusCode
{
    NSLog(@"url为   %@",url);
    AFHTTPSessionManager *manager = [self manager];

    [manager POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        statusCode(responses.statusCode);
        NSLog(@"1111111111111111:%ld",    responses.statusCode );

        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           if (failure) {
               failure(error);
           }
    }];
  
}
+ (void)httpPostTokenRequest:(NSString *)url  Parameters:(NSDictionary *)params WithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"url为   %@",url);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据

    [manager POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        
        NSLog(@"1111111111111111:%ld",    responses.statusCode );
        success(responseObject);
//        success(responses.statusCode);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
+ (void)httpDeleteRequest:(NSString *)url  Parameters:(NSDictionary *)params WithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"url为   %@",url);
    AFHTTPSessionManager *manager = [self manager];
    [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"1111111111111111:%@",    manager.responseSerializer.acceptableStatusCodes
              );
        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)httpPutRequest:(NSString *)url  Parameters:(NSDictionary *)params WithSuccess:(void (^)(id result))success failure:(void (^)(NSError *error))failure{
    NSLog(@"url为   %@",url);

    AFHTTPSessionManager *manager = [self manager];
    [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


- (void)AFNetworkStatus{
    
    //创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                
                break;
                
            default:
                break;
        }
        
    }] ;
}

/**
 * HTTP响应成功的函数
 *
 */
- (void)requestFinished:(NSData *)responseByte withStatusCode:(NSInteger)statusCode originalURL:(NSURL *)url{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

    NSError *error = nil;//[request error];
    if (!error) {
        if (statusCode == 200) {

            }
    }
}

@end
