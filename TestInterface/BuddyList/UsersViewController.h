//
//  UsersViewController.h
//  EaseDemo
//
//  Created by 蒋月婷 on 17/1/5.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface UsersViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (copy, nonatomic) NSArray *datArray;
@property (copy, nonatomic) NSString *titleName;

@end
