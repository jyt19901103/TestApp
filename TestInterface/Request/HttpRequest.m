//
//  HttpRequest.m
//  TestInterface
//
//  Created by 蒋月婷 on 17/1/5.
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
    
    AFHTTPSessionManager *manager = [self manager];
    for (NSString *key in [headers allKeys]) {
        [manager.requestSerializer setValue:[headers valueForKey:key] forHTTPHeaderField:key];
    }
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:type
                                                                      URLString:url
                                                                     parameters:params
                                                                          error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSURLResponse *response, id responseObject, NSError *error) {
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
+ (void)uploadFile:(NSString *)url
            Header:(NSDictionary *)headers
       WithSuccess:(void (^)(id result))success
           failure:(void (^)(NSError *error))failure
        statusCode:(void (^)(NSInteger statusCode))statusCode{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
    
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传文件
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        formatter.dateFormat            = @"yyyyMMddHHmmss";
        //        NSString *str                         = [formatter stringFromDate:[NSDate date]];
        NSString *fileName               = [NSString stringWithFormat:@"%@", image];
        
        //imageData 是要上传文件的二进制数据
        //name 是服务器的参数
        //filename 是上传服务器的名字
        //mimeType 是上传文件的类型。
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (success) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            statusCode(responses.statusCode);
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败");
        if (error) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            statusCode(responses.statusCode);
            NSLog(@"上传失败");
            failure(error);
        }
    }];
    
    
    
}

+ (void)httpOtherRequest:(NSString *)url
             RequestType:(NSString *)type
                  Header:(NSDictionary *)headers
              Parameters:(NSDictionary *)params
             WithSuccess:(void (^)(id result))success
                 failure:(void (^)(NSError *error))failure
              statusCode:(void (^)(NSInteger statusCode))statusCode{
    //    NSLog(@"url为   %@",url);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    for (NSString *key in [headers allKeys]) {
        [manager.requestSerializer setValue:[headers valueForKey:key] forHTTPHeaderField:key];
    }
    [manager POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (success) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            statusCode(responses.statusCode);
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            statusCode(responses.statusCode);
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
