//
//  TestTableViewController.m
//  TestInterface
//
//  Created by 杜洁鹏 on 13/02/2017.
//  Copyright © 2017 JYT. All rights reserved.
//

#import "TestTableViewController.h"
#import "Header.h"

@interface TestTableViewController ()

@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)rightBarButtonItem {
    UIButton *ret = [UIButton btnWithTitle:@"开始"
                                     color:[UIColor blackColor]
                                  forState:UIControlStateNormal
                                    target:self
                                    action:@selector(action)];
    return ret;
}

- (void)action {
    
}

@end
