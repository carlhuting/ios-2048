//
//  LTCard.m
//  ios-2048
//
//  Created by carl on 15/1/18.
//  Copyright (c) 2015年 lemontree. All rights reserved.
//

#import "LTCard.h"

@implementation LTCard

- (void)twotimes {
    self.score=self.score*2;
    UIButton *buton=self.view;
    [buton setTitle:@(self.score).stringValue forState:UIControlStateNormal];
}
@end
