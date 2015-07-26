//
//  UIColor+LTColor.m
//  ios-2048
//
//  Created by carl on 15/7/26.
//  Copyright (c) 2015年 lemontree. All rights reserved.
//

#import "UIColor+LTColor.h"

@implementation UIColor (LTColor)

//颜色进制
+ (UIColor *)lt_colorWithHex:(uint)hex {
    if (hex <= 0xffffff) {
        hex = 0xff000000 | hex;
    }
    int red, green, blue, alpha;
    blue = hex & 0x000000FF;
    green = ((hex & 0x0000FF00) >> 8);
    red = ((hex & 0x00FF0000) >> 16);
    alpha = ((hex & 0xFF000000) >> 24);
    
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha/255.f];
}

+ (UIColor *)lt_blank {
    return [UIColor lt_colorWithHex:0xCDC1B5];
}

+ (UIColor *)lt_background2 {
    return [UIColor lt_colorWithHex:0xBBADA1];
}

@end