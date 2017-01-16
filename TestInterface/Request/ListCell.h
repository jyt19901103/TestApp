//
//  ListCell.h
//  TestInterface
//
//  Created by 蒋月婷 on 17/1/10.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@interface ListCell : UITableViewCell


@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *statusLabel;

@property (nonatomic , strong) UserModel *userModel;
+ (ListCell*)cellWithTableView :(UITableView *)tableView;
@end
