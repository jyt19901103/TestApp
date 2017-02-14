//
//  JsonRWManager.h
//  TestInterface
//
//  Created by 杜洁鹏 on 13/02/2017.
//  Copyright © 2017 JYT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonRWManager : NSObject
+ (void)readJsonObjectsWithPath:(NSString *)aPath;
+ (void)writeJsonObjectsToPath:(NSString *)aPath;
@end
