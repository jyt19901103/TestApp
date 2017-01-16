//
//  ListCell.m
//  TestInterface
//
//  Created by 蒋月婷 on 17/1/10.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import "ListCell.h"
#import "UserModel.h"

@implementation ListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (ListCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"ListCell";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
}

- (void)setUserModel:(UserModel *)userModel{
    _userModel = userModel;
    _nameLabel.text = [NSString stringWithFormat:@"%@",userModel.name];
    _statusLabel.text = [NSString stringWithFormat:@"%@",userModel.staus];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 220, 20)];
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH - 90, 10, 60, 20)];
        _statusLabel.textAlignment = NSTextAlignmentRight;

        [self addSubview:_nameLabel];
        [self addSubview:_statusLabel];
    }
    return self;
}
@end
