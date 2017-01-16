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
#import "HttpsManager.h"
#import "UserModel.h"
#import "HttpRequest.h"
#import "ListModel.h"
#import "UsersViewController.h"


@interface MainViewController ()
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (copy, nonatomic) NSDictionary *requestHeader;
@property (copy, nonatomic) NSDictionary *requestBody;
@property (copy, nonatomic) NSString *api;
@property (copy, nonatomic) NSString *method;
@property (copy, nonatomic) NSDictionary *result;
@property (copy, nonatomic) NSString *stausCode;
@property (copy, nonatomic) NSDictionary *resultData;

@property (nonatomic,strong)ListModel *allModel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"测试";

    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(onBtmClick:)];
    
    [self requestData];
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
     cell.nameLabel.text  = _dataSource[indexPath.row];
     cell.statusLabel.text = _stausCode;

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
- (void)requestData
{
    // 从本地文件中读取数据
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Untitled" ofType:@"json"]];
    
    // 解析 json 数据
    _resultData = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }

    ListModel *model = [ListModel modelWithDict:_resultData];
    self.allModel = model;
    NSLog(@"%@",self.allModel);

    NSArray *token = _resultData[@"Token"];
    for (NSDictionary *dict in token) {
        UserModel *tokenModel = [UserModel modelWithDict:dict];

        if (tokenModel.body != nil) {
            _requestBody  = [dict objectForKey:@"body"];
        }else{
            _requestBody = nil;
        }
        _api = [dict objectForKey:@"api"];
        NSString *url = [NSString stringWithFormat:@"%@%@",URLSTRING,_api];
        
        [HttpsManager httpPostRequest:url Parameters:_requestBody WithSuccess:^(id result) {
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            NSString *tokenString = [result objectForKey:@"access_token"];
            
                            [defaults setObject:[NSString stringWithFormat:@"Bearer %@",tokenString] forKey:@"token"];
                            [defaults synchronize];
                            NSLog(@"%@",result);
        } failure:^(NSError *error) {
                            if (error) {
                                NSLog(@"error:%@",error);
                            }
        } statusCode:^(NSInteger statusCode) {
            NSLog(@"statusCode: %ld",statusCode);
            _stausCode = [NSString stringWithFormat:@"%ld", statusCode];
            if ([_stausCode isEqualToString:@"200"]) {
                [self createTableView];

                for (NSString *key in _resultData) {
                    //        NSLog(@"%@--> %@",key,[result objectForKey:key]);
                    [_dataSource addObject:key];
                    
                }
                [self.tableView reloadData];
            }
        }];

    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString * className = [NSString stringWithFormat:@"%@ViewController", _dataSource[indexPath.row]];
//
//    //创建视图控制器的Class
//    //使用class间接使用类名，即使不加头文件，也能创建对象。
//    //编译器要求直接引用类名等标识符，必须拥有声明。
//    Class aVCClass = NSClassFromString(className);
//    //创建vc对象
//    UIViewController * vc = [[aVCClass alloc] init];
//    [vc performSelector:@selector(setDatArray:) withObject:[_resultData objectForKey:_dataSource[indexPath.row]]];
//    [vc performSelector:@selector(setTitle:) withObject:_dataSource[indexPath.row]];
    UsersViewController *vc = [[UsersViewController alloc]init];
    vc.datArray = [_resultData objectForKey:_dataSource[indexPath.row]];
    vc.title = _dataSource[indexPath.row];
    //推出vc
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
