//
//  HttpRequestManager.m
//  TestInterface
//
//  Created by 杜洁鹏 on 13/02/2017.
//  Copyright © 2017 JYT. All rights reserved.
//

#import "HttpRequestManager.h"
#define TIMEOUT 3

@implementation HttpRequestManager
+ (void)asyncHttpRequestWithUrl:(NSString *)aUrl
                         method:(NSString *)aMethod
                        headers:(NSDictionary *)aHeaders
                     parameters:(NSDictionary *)aParameters
                     completion:(void(^)(NSInteger httpCode, NSDictionary *response ))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HttpRequestManager *manager = [HttpRequestManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        for (NSString *key in [aHeaders allKeys]) {
            [manager.requestSerializer
             setValue:[aHeaders valueForKey:key]
             forHTTPHeaderField:key];
        }
        
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:aMethod
                                                                          URLString:aUrl
                                                                         parameters:aParameters
                                                                              error:nil];
        [request setTimeoutInterval:TIMEOUT];
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request
                                                    completionHandler:
                                          ^(NSURLResponse *response, id responseObject, NSError *error)
                                          {
                                              NSHTTPURLResponse * responses = (NSHTTPURLResponse *)response;
                                              if (completion) {
                                                  completion(responses.statusCode, responseObject);
                                              }
                                          }];
        [dataTask resume];
    });
}
@end
