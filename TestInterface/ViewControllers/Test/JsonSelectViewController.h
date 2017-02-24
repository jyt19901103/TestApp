//
//  JsonSelectViewController.h
//  TestInterface
//
//  Created by 杜洁鹏 on 14/02/2017.
//  Copyright © 2017 JYT. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol JsonSelectDelegate <NSObject>

-(void)didSelectedFilePath:(NSString *)aPath;

@end

@interface JsonSelectViewController : BaseTableViewController
@property (nonatomic, assign) id<JsonSelectDelegate> delegate;
@end
