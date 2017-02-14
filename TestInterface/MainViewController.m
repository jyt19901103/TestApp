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
{
    dispatch_queue_t _serialQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"测试rest接口";

    self.navigationItem.backBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
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
    NSDictionary *dnsDict = _resultData[@"Dns"];
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
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            for (NSDictionary *dict in array) {
                NSString *resturl = dict[@"domain"] ;
                NSLog(@"resturl:%@",resturl);
                _app_name = _resultData[@"app_name"];
                _org_name = _resultData[@"org_name"];
                NSString *urlStr = [NSString stringWithFormat:@"https://%@/%@/%@/",resturl,_org_name,_app_name];
                [defaults setObject:urlStr forKey:@"URLSTRING"];
                [defaults synchronize];
            }
            
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

    NSDictionary *tokenDict = _resultData[@"Token"];
    _restModel = [UserModel modelWithDict:tokenDict];

    _url = [NSString stringWithFormat:@"%@%@",URLSTRING,_restModel.api];
    NSLog(@"1111111111111111%@",_url);
    
    __weak typeof(self) weakSelf = self;
    [HttpRequest httpOtherRequest:_url  RequestType:_restModel.method Header:_restModel.header Parameters:_restModel.body WithSuccess:^(id result) {
        __strong MainViewController *strSelf = self;
        NSString *tokenString = [result objectForKey:@"access_token"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat:@"Bearer %@",tokenString] forKey:@"token"];
        [defaults synchronize];
        strSelf.restModel.result = result;
        [strSelf.dataSource addObject:strSelf.restModel];
        [strSelf.tableView reloadData];
        //
        
        dispatch_async([strSelf serialQueue], ^{//把block中的任务放入串行队列中执行，这是第一个任务
            [weakSelf requestUsersData:_resultData[@"Users"]];

        });
        
        dispatch_async([strSelf serialQueue], ^{
            [weakSelf requestUsersData:_resultData[@"Chat"]];
            
        });
        
        dispatch_async([strSelf serialQueue], ^{
            [weakSelf requestUsersData:_resultData[@"ChatGroup"]];
            
        });
        dispatch_async([strSelf serialQueue], ^{
            [weakSelf requestUsersData:_resultData[@"ChatRoom"]];
            
        });

    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    } statusCode:^(NSInteger statusCode) {
        _restModel.staus = [NSString stringWithFormat:@"%ld", statusCode];
    }];
}

- (void)requestUsersData:(NSArray *)userArray{
  //  dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    for (NSDictionary *dict in userArray) {
        UserModel *listModel = [UserModel modelWithDict:dict];

        if ([listModel.name isEqualToString:@"根据时间条件拉取历史消息"]){
            NSString *str = [listModel.api stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            _url = [NSString stringWithFormat:@"%@%@",URLSTRING,str];
        }
       else if ([listModel.api rangeOfString:@"%1$s"].location !=NSNotFound) {
            
            _url = [NSString stringWithFormat:@"%@%@",URLSTRING,[listModel.api stringByReplacingOccurrencesOfString:@"%1$s" withString:GroupId]];
        }
       else if ([listModel.api rangeOfString:@"%2$s"].location !=NSNotFound) {
            
            _url = [NSString stringWithFormat:@"%@%@",URLSTRING,[listModel.api stringByReplacingOccurrencesOfString:@"%2$s" withString:ChatRoomId]];
        }
        else{
            _url = [NSString stringWithFormat:@"%@%@",URLSTRING,listModel.api];
        }
        NSLog(@"=============%@",_url);

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
        
//        dispatch_sync(concurrentQueue, ^{
        //_url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
            [HttpRequest httpRequest:_url RequestType:listModel.method Header:_requestHeader Parameters:_requestBody WithSuccess:^(id result) {
                listModel.result = result;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                if ([listModel.name isEqualToString:@"获取所有群组"]) {
                    
                    for (NSDictionary *dict in result[@"data"]) {
                        // NSLog(@"======%@",dict);
                        NSString *groupid = dict[@"groupid"] ;
                        [defaults setObject:groupid forKey:@"GroupId"];
                        [defaults synchronize];
                    }
                }
                
                if ([listModel.name isEqualToString:@"获取APP下所有聊天室"]) {
                    
                    for (NSDictionary *dict in result[@"data"]) {
                        NSLog(@"%@",dict);
                        NSString *chatRoomId = dict[@"id"];
                        [defaults setObject:chatRoomId forKey:@"ChatRoomId"];
                        [defaults synchronize];
                    }
                }
            } failure:^(NSError *error) {
                if (error) {
                    NSLog(@"error: %@",error);
                    listModel.error = error;
                }
            } statusCode:^(NSInteger statusCode) {
                listModel.staus = [NSString stringWithFormat:@"%ld", statusCode];
                
              //  dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    
             //   });
                
            }];
            [_dataSource addObject:listModel];
            
      //  });

    }
    
    [self.tableView reloadData];
}
- (dispatch_queue_t)serialQueue
{
    if (!_serialQueue) {
        _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);//创建串行队列
    }
    return _serialQueue;
}

@end
