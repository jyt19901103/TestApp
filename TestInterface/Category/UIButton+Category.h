//
//  UIButton+Category.h
//  TestInterface
//
//  Created by 杜洁鹏 on 13/02/2017.
//  Copyright © 2017 JYT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Category)
+ (UIButton *)btnWithTitle:(NSString *)aTitle
                     color:(UIColor *)aColor
                  forState:(UIControlState)state
                    target:(nullable id)target
                    action:(SEL)action;
@end
