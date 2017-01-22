//
//  MainViewController.m
//  EaseDemo
//
//  Created by 蒋月婷 on 16/12/21.
//  Copyright © 2016年 JYT. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"
#import "Header.h"
#import "UserModel.h"
#import "ListCell.h"
#import "HttpRequest.h"
#import "DetailedViewController.h"


@interface MainViewController ()
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (copy, nonatomic) NSDictionary *requestHeader;
@property (copy, nonatomic) NSDictionary *requestBody;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *method;
@property (copy, nonatomic) NSDictionary *result;
@property (copy, nonatomic) NSString *stausCode;
@property (copy, nonatomic) NSDictionary *resultData;


@property (copy, nonatomic) NSString *org_name;
@property (copy, nonatomic) NSString *app_name;
@property (copy, nonatomic) NSString *rest_url;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"测试rest接口";

    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(onBtmClick:)];
    
}

- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT -60)];

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
- (void)requestData
{
    // 从本地文件中读取数据
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Untitled" ofType:@"json"]];
    // 解析 json 数据
    _resultData = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];

    _app_name = _resultData[@"app_name"];
    _org_name = _resultData[@"org_name"];
    _rest_url = _resultData[@"rest_url"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/",_rest_url,_org_name,_app_name];
    [defaults setObject:urlStr forKey:@"URLSTRING"];
    [defaults synchronize];
    
    NSArray *token = _resultData[@"Token"];
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    [self analysisData:token];
}
- (void)analysisData:(NSArray *)data{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    for (NSDictionary *dict in data) {
        UserModel *listModel = [UserModel modelWithDict:dict];
        
        if (listModel.body != nil) {
            _requestBody  = [dict objectForKey:@"body"];
        }else{
            _requestBody = nil;
        }
        
        if (listModel.header != nil) {
            _requestHeader  = [dict objectForKey:@"header"];
        }else{
            _requestHeader = nil;
        }
        
        if ([listModel.name isEqualToString:@"获取DNS列表"]) {
            _url = listModel.api;
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
            manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
            [manager GET:_url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                if (responseObject) {
                    listModel.result = responseObject;
                    NSDictionary *restDict = responseObject[@"rest"];
                    NSArray *array = restDict[@"hosts"];
                    
                    NSLog(@"restDict : %@",restDict);
                    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                    listModel.staus = [NSString stringWithFormat:@"%ld", responses.statusCode] ;
                    [self createTableView];
                }
                
                [self.tableView reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                if (error) {
                    NSLog(@"%@",error);
                    
                    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                    listModel.staus = [NSString stringWithFormat:@"%ld", responses.statusCode] ;
                }
            }];
        }else if ([listModel.name isEqualToString:@"根据时间条件拉取历史消息"]){
            NSString *str = [listModel.api stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            _url = [NSString stringWithFormat:@"%@%@",URLSTRING,str];
        }
        else{
            _url = [NSString stringWithFormat:@"%@%@",URLSTRING,listModel.api];
        }

        
        if ([listModel.upload isEqualToString:@"pic"]) {
            [HttpRequest uploadFile:_url Header:_requestHeader WithSuccess:^(id result) {
                listModel.result = result;

            } failure:^(NSError *error) {
                if (error) {
                    NSLog(@"error:%@",error);
                }
            } statusCode:^(NSInteger statusCode) {
                listModel.staus = [NSString stringWithFormat:@"%ld", statusCode];

            }];
        }
        
        if ([listModel.name isEqualToString:@"获取用户token"] ) {
            [HttpRequest httpOtherRequest:_url  RequestType:listModel.method Header:_requestHeader Parameters:_requestBody WithSuccess:^(id result) {
                NSString *tokenString = [result objectForKey:@"access_token"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[NSString stringWithFormat:@"Bearer %@",tokenString] forKey:@"token"];
                [defaults synchronize];
                listModel.result = result;
            } failure:^(NSError *error) {
                if (error) {
                    NSLog(@"error:%@",error);
                }
            } statusCode:^(NSInteger statusCode) {
                listModel.staus = [NSString stringWithFormat:@"%ld", statusCode];
                [self createTableView];
            }];

        }else{
            [HttpRequest httpRequest:_url RequestType:listModel.method Header:_requestHeader Parameters:_requestBody WithSuccess:^(id result) {
                listModel.result = result;
            } failure:^(NSError *error) {
                if (error) {
                    NSLog(@"error: %@",error);
                    listModel.error = error;
                }
            } statusCode:^(NSInteger statusCode) {
                listModel.staus = [NSString stringWithFormat:@"%ld", statusCode];
                [self.tableView reloadData];

            }];
//            [_dataSource addObject:listModel];
        }
        [_dataSource addObject:listModel];

        [self.tableView reloadData];
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailedViewController *dvc = [[DetailedViewController alloc]init];
    dvc.dataDict = [_dataSource[indexPath.row] result];
        //推出vc
    [self.navigationController pushViewController:dvc animated:YES];
}


- (void)onBtmClick:(UIButton *)button{
    if (_dataSource != nil) {
        [_dataSource removeAllObjects];
    }
    [self requestData];
}
@end
