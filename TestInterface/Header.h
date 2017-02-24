//
//  Header.h
//  EaseDemo
//
//  Created by 蒋月婷 on 16/12/21.
//  Copyright © 2016年 JYT. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import "UIButton+Category.h"
#define DOCUMENTPATH [NSHomeDirectory() stringByAppendingString:@"/Documents/"]
//判断设备
#define IS_IPHONE_4 (fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480) < DBL_EPSILON)

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IPHONE_6_Plus ([UIScreen mainScreen].scale == 3 )
#define IS_IPHONE_6 (fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )

//4.0 4.7 5.5尺寸放大系数
#define KSCALE ((IS_IPHONE_6 || IS_IPHONE_6_Plus)?(DEVICE_SCREEN_WIDTH/320.):1.0)

#define KFOURSCALE ((IS_IPHONE_6 || IS_IPHONE_6_Plus||IS_IPHONE_5)?KSCALE:0.8)

#define UICOLOR_FROM_RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kNavBarHeight (SYSTEM_VERSION>=7?64:44)


#define UIFont_Font(size) [UIFont systemFontOfSize:size]

#endif /* Header_h */
