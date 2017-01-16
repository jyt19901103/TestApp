//
//  UsersViewController.m
//  EaseDemo
//
//  Created by 蒋月婷 on 17/1/5.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import "UsersViewController.h"
#import "HttpsManager.h"
#import "UserModel.h"
#import "ListCell.h"
#import "UserModel.h"
#import "HttpRequest.h"

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


@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setUpSubviews];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(onBtmClick:)];
    
}

- (void)analysisData:(NSArray *)data
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in self.datArray) {
            UserModel *requestmodel = [UserModel modelWithDict:dict];
            if (requestmodel.header == NULL) {
                requestmodel.header = nil;
            }
            if (requestmodel.body == NULL) {
                requestmodel.body = nil;
            }
            NSString *url = [NSString stringWithFormat:@"%@%@",URLSTRING,requestmodel.api];
            [HttpRequest httpRequest:url RequestType:requestmodel.method Header:requestmodel.header Parameters:requestmodel.body WithSuccess:^(id result) {
                NSLog(@"%@",result);
                
            } failure:^(NSError *error) {
                if (error) {
                    NSLog(@"error: %@",error);
                    }
            } statusCode:^(NSInteger statusCode) {
                NSLog(@"statusCode: %ld",statusCode);
                requestmodel.staus = [NSString stringWithFormat:@"%ld", statusCode];
                [self createTableView];
            }];
            [_dataSource addObject:requestmodel];
        }
        [_tableView reloadData];

    }
    [_tableView reloadData];

}


- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
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
//    cell.nameLabel.text  = _dataSource[indexPath.row];
//    cell.statusLabel.text = _stausCode;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
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
    }
    [self analysisData:self.datArray];
//    [self createTableView];
}
- (void)requestData{
    
    for (NSDictionary *dict in self.datArray) {
        UserModel *requestmodel = [UserModel modelWithDict:dict];
        if (requestmodel.header == NULL) {
            requestmodel.header = nil;
        }
        if (requestmodel.body == NULL) {
            requestmodel.body = nil;
        }
        NSString *url = [NSString stringWithFormat:@"%@%@",URLSTRING,requestmodel.api];
        [HttpRequest httpRequest:url RequestType:requestmodel.method Header:requestmodel.header Parameters:requestmodel.body WithSuccess:^(id result) {
            NSLog(@"%@",result);
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"error: %@",error);
            }
        }];
    }


}


@end
