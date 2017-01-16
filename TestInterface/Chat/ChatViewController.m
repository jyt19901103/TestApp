//
//  ChatViewController.m
//  EaseDemo
//
//  Created by 蒋月婷 on 17/1/5.
//  Copyright © 2017年 JYT. All rights reserved.
//

#import "ChatViewController.h"
#import "HttpsManager.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(onBtmClick:)];
    
  //  [self setUpSubviews];
}
- (void)setUpSubviews{
    NSArray * array = @[@"发文本消息", @"发图片消息", @"发视频消息", @"发语音消息",@"发CMD消息",@"ForceNotification",@"发推送消息",@"发IgnoreNotification",@"获取聊天历史",@"获取某段时间的聊天记录",@"获取离线信息数",@"获取离线信息状态"];
    
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(10 , 5 + i * 45, SCREENWIDTH - 20 , 40)];
        button.tag = 200 + i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor blackColor];
        
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)onClick:(UIButton *)button
{
    switch (button.tag - 100) {
            
        case 100:
            //发送文本消息
            [self sendTextMessage];
            break;
            
        case 101:
            //
            [self sendImageMessage];
            break;
            
        case 102:
            //
            [self sendVideoMessage];
            break;
            
        case 103:
            //
            [self sendAudioMessage];
            break;
            
        case 4:
            [self sendCMDMessage];
            break;
            
        case 5:
            [self sendTextMessageForceNotification];
            break;
            
        case 6:
            [self sendTextMessagePushTitle];
            break;
        case 7:
            [self sendTextMessagePushTitle];
            break;
            
        case 8:
            [self sendTextMessageIgnoreNotification];
            break;
            
        case 9:
            [self getUserChatHistory];
            break;
            
        case 10:
            [self getUserChatTimestamp];
            break;
            
        case 11:
            [self getOfflineMessageCount];//查询某条离线消息
            break;
            
        case 12:
            [self checkOfflineMessageStatus];
            break;
            
        default:
            
            break;
            
    }
}

-(void)sendTextMessage{
    NSDictionary *param = @{ @"target_type":@"users",
                             @"target":@[@"u3",@"u4"],
                             @"msg":@{
                                     @"type":@"txt",
                                     @"msg":@"message from rest"
                                     },
                             @"from":@"rest"
                             };

    [HttpsManager httpPostRequest:MessagesURL Parameters:param WithSuccess:^(id result) {
        NSLog(@"result :%@",result);
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        
    }];
    
}
- (void)sendImageMessage{
    NSDictionary *param = @{ @"target_type":@"users",
        @"target":@[@"u3",@"u4"],
        @"msg":@{
            @"type":@"img",
            @"url":@"https://a1.easemob.com/easemob-demo/chatdemoui/chatfiles/c8ae5ad0-a5a7-11e6-b991-65e029430485",
            @"filename":@"lorex.jpg",
            @"secret":@"yK5a2qWnEeaRcJUaVNstNOVVTjuqBVyib-rF7Vw1xSVn28X4",
            @"size":@{
                @"width":@"480",
                @"height":@"480"
            }
        },
        @"from":@"rest"

                             };
    [HttpsManager httpGetRequest:GetUsersURL Parameters:param WithSuccess:^(id result) {
        NSLog(@"GetUserResult :%@",result);
        
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        
    }];
}
- (void)sendVideoMessage{
    NSDictionary *param = @{ @"target_type":@"users",
                             @"target":@[@"u3",@"u4"],
                             @"msg":@{
                                 @"type":@"video",
                                 @"url":@"https://a1.easemob.com/easemob-demo/chatdemoui/chatfiles/9887d140-a649-11e6-b383-4541f7075ce8",
                                 @"filename":@"111.mp4",
                                 @"length": @"5",
                                 @"secret":@"mIfRSqZJEeaei5tHtLW4f-e_Zh4N_-DOwtX4nFIOvUitGtHJ",
                                 @"thumb": @"https://a1.easemob.com/easemob-demo/chatdemoui/chatfiles/f6a5a3a0-a64a-11e6-8a7b-51138be95708",
                                 @"thumb_secret": @"9qWjqqZKEeaeHwuBpYinrXmDsuAtOTQ2Ad8JW34Gtdj5XrnD",
                                 @"file_length":@"8699"
                             },
                             @"from":@"rest"
                             };
    [HttpsManager httpDeleteRequest:MessagesURL Parameters:param WithSuccess:^(id result) {
        NSLog(@"deleteUserResult :%@",result);
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}
- (void)sendAudioMessage{
    NSDictionary *param = @{ @"target_type":@"users",
                             @"target":@[@"mcs1",@"mcs2"],
                             @"msg":@{
                                 @"type":@"audio",
                                 @"url":@"https://a1.easemob.com/easemob-demo/chatdemoui/chatfiles/76635950-a5a8-11e6-9387-3f2d3a91e533",
                                 @"filename":@"audio sample.amr",
                                 @"secret":@"dmNZWqWoEeaDymsQPaQ9I3Wcs05uXfMWGn0KuRdR87wqko70",
                                 @"size":@{
                                     @"width":@"480",
                                     @"height":@"480"
                                 }
                             },
                             @"from":@"rest"
                             };
    [HttpsManager httpPutRequest:PUTPasswordURL Parameters:param WithSuccess:^(id result) {
        NSLog(@"PUTPasswordURL :%@",result);
        
    } failure:^(NSError *error) {
        NSLog(@"PUTPasswordURL :%@",error);
        
    }];
}
- (void)sendCMDMessage{
    NSDictionary *param = @{ @"target_type":@"users",
        @"target":@[@"u3",@"u4"],
        @"msg":@{
            @"type":@"txt",
            @"msg":@"这是一条cmd消息"
        },
        @"from":@"rest"
    };
    [HttpsManager httpPutRequest:MessagesURL Parameters:param WithSuccess:^(id result) {
        NSLog(@"sendCMDMessage :%@",result);
        
    } failure:^(NSError *error) {
        NSLog(@"sendCMDMessage :%@",error);
    }];
}
- (void)sendTextMessageForceNotification{
    NSDictionary *param = @{@"target_type" : @"users",
        @"target" : @[@"u3"],
        @"msg" : @{@"type" : @"txt",@"msg" : @"hello from rest"},
        @"from" : @"admin",
                            @"ext" : @{@"em_force_notification":@"true"} };
    [HttpsManager httpPostRequest:MessagesURL Parameters:param WithSuccess:^(id result) {
        NSLog(@"result :%@",result);
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        
    }];
}
- (void)sendTextMessagePushTitle{
    NSDictionary *param = @{@"target_type":@"users",
        @"target":@[@"u3"],
        @"msg" :
        @{@"type":@"txt",@"msg":@"hello"},
        @"from":@"test2",
        @"ext":@{@"em_apns_ext":@{@"em_push_title":@"北京市海淀区中关村南大街2号数码大厦A座20层环信即时通讯云"}
        }
    };
    [HttpsManager httpGetRequest:MessagesURL Parameters:param WithSuccess:^(id result) {
        NSLog(@"PushTitle :%@",result);
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        
    }];
}
- (void)sendTextMessageIgnoreNotification{
    NSDictionary *param = @{
                            @"target_type":@"users",
                            @"target":@[
                                      @"mcs1"
                                      ],
                            @"msg":@{
                                @"type":@"txt",
                                @"msg":@"hello from rest"
                            },
                            @"from":@"rest",
                            @"ext":@{
                                @"em_ignore_notification":@"true"
                                   }
                            };
    
    [HttpsManager httpGetRequest:MessagesURL Parameters:param WithSuccess:^(id result) {
        NSLog(@"GetUserResult :%@",result);
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        
    }];
}
- (void)getUserChatHistory{
    [HttpsManager httpGetRequest:CheckOnlineStatusURL Parameters:nil WithSuccess:^(id result) {
        NSLog(@"GetUserResult :%@",result);
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        
    }];
}
- (void)getUserChatTimestamp{
    [HttpsManager httpGetRequest:OFFLineMsgCountURL Parameters:nil WithSuccess:^(id result) {
        NSLog(@"GetUserResult :%@",result);
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        
    }];
}
- (void)getOfflineMessageCount{
    [HttpsManager httpPostRequest:DeactivateUserURL Parameters:nil WithSuccess:^(id result) {
        NSLog(@"GetUserResult :%@",result);
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        
    }];
}
- (void)checkOfflineMessageStatus{
    [HttpsManager httpPostRequest:DeactivateUserURL Parameters:nil WithSuccess:^(id result) {
        NSLog(@"GetUserResult :%@",result);
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        
    }];
}


@end
