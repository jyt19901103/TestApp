//
//  JsonRWManager.m
//  TestInterface
//
//  Created by 杜洁鹏 on 13/02/2017.
//  Copyright © 2017 JYT. All rights reserved.
//

#import "JsonRWManager.h"

@implementation JsonRWManager



+ (void)readJsonObjectsWithPath:(NSString *)aPath{
    NSString *path = aPath;
    if (!path) {
        path = [NSHomeDirectory() stringByAppendingString:@"/test.json"];
    }
    
    NSData *appkeysData = [NSData dataWithContentsOfFile:path];
    NSString *receiveStr = [[NSString alloc] initWithData:appkeysData encoding:NSUTF8StringEncoding];
    receiveStr = [receiveStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *jsonData = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *ret  = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&err];
}

+ (void)writhJsonObjectsToPath:(NSString *)aPath{

}

@end
