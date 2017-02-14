//
//  PlistRWManager.m
//  TestInterface
//
//  Created by 杜洁鹏 on 14/02/2017.
//  Copyright © 2017 JYT. All rights reserved.
//

#import "PlistRWManager.h"

@implementation PlistRWManager

+ (void)writeDicToPlist:(NSDictionary *)dic {

}

+ (NSDictionary *)readDicFromPlist {
    return nil;
}

+ (instancetype)sharedInstance {
    static PlistRWManager *pm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pm = [[PlistRWManager alloc] init];
    });
    
    return pm;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}
@end
