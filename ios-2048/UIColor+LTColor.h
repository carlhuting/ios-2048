//
//  UIColor+LTColor.h
//  ios-2048
//
//  Created by carl on 15/7/26.
//  Copyright (c) 2015年 lemontree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LTColor)
//颜色进制
+ (UIColor *)lt_colorWithHex:(uint)hex;
+ (UIColor *)lt_blank;
+ (UIColor *) lt_background2;
@end
