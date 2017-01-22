//
//  DetailedViewController.m
//  TestInterface
//
//  Created by 蒋月婷 on 17/1/16.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import "DetailedViewController.h"

@interface DetailedViewController ()<UITextViewDelegate>

@end

@implementation DetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubview];
}

- (void)setUpSubview{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) ];
    textView.delegate = self;
    textView.contentInset = UIEdgeInsetsMake(10, 10, 0, 0);
    textView.showsHorizontalScrollIndicator = NO;
    textView.editable = NO;//不可编辑
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.dataDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *dicStr  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"dicStr:%@",dicStr);
    [textView setText:dicStr];
    textView.font = [UIFont systemFontOfSize:16.0f]; //指定字符串的大小

    [self.view addSubview:textView];
}

@end
