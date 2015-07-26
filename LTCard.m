//
//  LTCard.m
//  iOS-2048
//
//  Created by carl on 15/1/18.
//  Copyright (c) 2015年 lemontree. All rights reserved.
//

#import "LTCard.h"

@implementation LTCard


- (void)setScore:(NSInteger)score {
    _score = score;
    UIButton *buton = (UIButton *)self.view;
    [buton setTitle:@(self.score).stringValue forState:UIControlStateNormal];
    buton.titleLabel.font=[UIFont boldSystemFontOfSize:30];
    switch (score) {
        case 2:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xEEE4DB];
            break;
        case 4:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xEDE0C9];
            break;
        case 8:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xF1B17D];
            break;
        case 16:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xF39568];
            break;
        case 32:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xF47C63];
            break;
        case 64:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xF45F42];
            break;
        case 128:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xECCE78];
            break;
        case 256:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xECCB69];
            break;
        case 1024:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xECC75A];
            break;
        case 2048:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xECC478];
            break;
        case 4096:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xECC15A];
            break;
        case 8192:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xECA75A];
            break;
        case 16284:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xECA45A];
            break;
        case 32768:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xECA15A];
            break;
        case 65536:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xEC775A];            break;
        default:
            buton.backgroundColor = [UIColor lt_colorWithHex:0xEC715A];
            break;
    }
}

- (NSInteger)twice {
    self.score=self.score * 2;
    return self.score;
}
@end
