//
//  LTCard.h
//  ios-2048
//
//  Created by carl on 15/1/18.
//  Copyright (c) 2015年 lemontree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LTCard : NSObject

@property (nonatomic) NSInteger score;
@property (nonatomic, strong) UIView* view;

- (void)twotimes;

@end
