//
//  HttpRequestManager.h
//  TestInterface
//
//  Created by 杜洁鹏 on 13/02/2017.
//  Copyright © 2017 JYT. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface HttpRequestManager : AFHTTPSessionManager
+ (void)asyncHttpRequestWithUrl:(NSString *)aUrl
                         method:(NSString *)aMethod
                        headers:(NSDictionary *)aHeaders
                     parameters:(NSDictionary *)aParameters
                     completion:(void(^)(NSInteger httpCode, NSDictionary *response ))completion;
@end
