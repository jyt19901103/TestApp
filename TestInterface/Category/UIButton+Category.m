//
//  UIButton+Category.m
//  TestInterface
//
//  Created by 杜洁鹏 on 13/02/2017.
//  Copyright © 2017 JYT. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)
+ (UIButton *)btnWithTitle:(NSString *)aTitle
                     color:(UIColor *)aColor
                  forState:(UIControlState)state
                    target:(nullable id)target
                    action:(SEL)action {
    UIButton *ret = [UIButton buttonWithType:UIButtonTypeCustom];
    [ret setTitle:@"开始" forState:state];
    [ret setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [ret sizeToFit];
    [ret addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return ret;
}

@end
