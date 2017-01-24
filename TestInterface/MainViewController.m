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
@property (strong, nonatomic) UserModel *restModel;

    
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
//    [self requestData];
    [self requestRestData];
    
}
- (void)requestRestData{
    // 从本地文件中读取数据
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rest" ofType:@"json"]];
    // 解析 json 数据
    _resultData = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    
    _app_name = _resultData[@"app_name"];
    _org_name = _resultData[@"org_name"];
    NSDictionary *dnsDict = _resultData[@"DNS"];
    _restModel = [UserModel modelWithDict:dnsDict];
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    _url = _restModel.api;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    [manager GET:_url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject) {
            _restModel.result = responseObject;
            NSDictionary *restDict = responseObject[@"rest"];
            NSArray *array = restDict[@"hosts"];
#warning todo 从从获取拼接url地址
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            
////            for (NSDictionary *dict in array) {
//                NSString *resturl = dict[@"domain"];
//                _app_name = _resultData[@"app_name"];
//                _org_name = _resultData[@"org_name"];
//                NSString *urlStr = [NSString stringWithFormat:@"https://%@/%@/%@/",resturl,_org_name,_app_name];
//                [defaults setObject:urlStr forKey:@"URLSTRING"];
//                [defaults synchronize];
//            }
            
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            _restModel.staus = [NSString stringWithFormat:@"%ld", responses.statusCode] ;
            [self createTableView];
            [_dataSource addObject:_restModel];
            [self requestTokenData];
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (error) {
            NSLog(@"%@",error);
            
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            _restModel.staus = [NSString stringWithFormat:@"%ld", responses.statusCode] ;
        }
    }];
    [_tableView reloadData];
}

- (void)requestTokenData{
    _app_name = _resultData[@"app_name"];
    _org_name = _resultData[@"org_name"];
    _rest_url = _resultData[@"rest_url"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@/",_rest_url,_org_name,_app_name];
    [defaults setObject:urlStr forKey:@"URLSTRING"];
    [defaults synchronize];
    
    
    NSDictionary *tokenDict = _resultData[@"Token"];
    _restModel = [UserModel modelWithDict:tokenDict];
    if (_restModel.body != nil) {
        _requestBody  = [tokenDict objectForKey:@"body"];
    }else{
        _requestBody = nil;
    }
    
    if (_restModel.header != nil) {
        _requestHeader  = [tokenDict objectForKey:@"header"];
    }else{
        _requestHeader = nil;
    }
    _url = [NSString stringWithFormat:@"%@%@",URLSTRING,_restModel.api];
    [HttpRequest httpOtherRequest:_url  RequestType:_restModel.method Header:_restModel.header Parameters:_restModel.body WithSuccess:^(id result) {
        NSString *tokenString = [result objectForKey:@"access_token"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat:@"Bearer %@",tokenString] forKey:@"token"];
        [defaults synchronize];
        _restModel.result = result;
        [_dataSource addObject:_restModel];
        [_tableView reloadData];
        // 创建队列
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        // 创建3个操作
        NSOperation *a = [NSBlockOperation blockOperationWithBlock:^{
            [self requestUsersData];
        }];
        NSOperation *b = [NSBlockOperation blockOperationWithBlock:^{
            [self requestAfterData];
        }];
        [b addDependency:a];
        [queue addOperation:a];
        [queue addOperation:b];


    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    } statusCode:^(NSInteger statusCode) {
        _restModel.staus = [NSString stringWithFormat:@"%ld", statusCode];
    }];
}
- (void)requestUsersData{
    NSArray *userArray = _resultData[@"Users"];
    for (NSDictionary *dict in userArray) {
        UserModel *listModel = [UserModel modelWithDict:dict];

        if ([listModel.name isEqualToString:@"根据时间条件拉取历史消息"]){
            NSString *str = [listModel.api stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            _url = [NSString stringWithFormat:@"%@%@",URLSTRING,str];
        }
        else{
            _url = [NSString stringWithFormat:@"%@%@",URLSTRING,listModel.api];
        }
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
        [_dataSource addObject:listModel];

    }
    
    [self.tableView reloadData];
}
- (void)requestAfterData{
    NSArray *userArray = _resultData[@"After"];
    for (NSDictionary *dict in userArray) {
        UserModel *listModel = [UserModel modelWithDict:dict];
        

        _url = [NSString stringWithFormat:@"%@%@",URLSTRING,listModel.api];
        
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
        [_dataSource addObject:listModel];
        
    }
    
    [self.tableView reloadData];
}
@end
