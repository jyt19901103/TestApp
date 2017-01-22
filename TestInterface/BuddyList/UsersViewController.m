//
//  UsersViewController.m
//  EaseDemo
//
//  Created by 蒋月婷 on 17/1/5.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import "UsersViewController.h"
#import "UserModel.h"
#import "ListCell.h"
#import "UserModel.h"
#import "HttpRequest.h"
#import "DetailedViewController.h"

@interface UsersViewController ()
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (copy, nonatomic) NSDictionary *requestHeader;
@property (copy, nonatomic) NSDictionary *requestBody;
@property (copy, nonatomic) NSString *api;
@property (copy, nonatomic) NSString *method;
@property (copy, nonatomic) NSDictionary *result;
@property (copy, nonatomic) NSString *stausCode;
@property (strong, nonatomic) UserModel *model;
@property (strong, nonatomic) UIView *footerView;
@property (copy, nonatomic) NSString *url;

@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setUpSubviews];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(onBtmClick:)];
    
}

- (void)analysisData
{
}


- (void)createTableView
{

}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (ListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell *cell = [ListCell cellWithTableView:tableView];
    cell.userModel = _dataSource[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


- (void)onBtmClick:(UIButton *)button{
    if (_dataSource != nil) {
        [_dataSource removeAllObjects];
//        [_tableView removeFromSuperview];
    }
    [self analysisData];
//    [self createTableView];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailedViewController *dvc = [[DetailedViewController alloc]init];
    dvc.dataDict = [_dataSource[indexPath.row] result];
    
    //推出vc
    [self.navigationController pushViewController:dvc animated:YES];
    
}

@end
