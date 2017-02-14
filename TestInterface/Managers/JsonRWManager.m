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
    NSData *appkeysData = [NSData dataWithContentsOfFile:aPath];
    NSString *receiveStr = [[NSString alloc] initWithData:appkeysData encoding:NSUTF8StringEncoding];
    receiveStr = [receiveStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *jsonData = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *ret  = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&err];
}

+ (void)writeJsonObjectsToPath:(NSString *)aPath{

}

@end
