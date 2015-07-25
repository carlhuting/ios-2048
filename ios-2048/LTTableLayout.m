//
//  LTTableLayout.m
//  ios-2048
//
//  Created by carl on 15/1/19.
//  Copyright (c) 2015年 lemontree. All rights reserved.
//

#import "LTTableLayout.h"
#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface LTTableLayout ()

@property (nonatomic, strong)NSMutableArray *cells;

@end

@implementation LTTableLayout

- (void)buildBoard {
    NSUInteger rows = 4;
    NSMutableArray *colarry = [[NSMutableArray alloc] initWithCapacity:rows];
    for (NSInteger row = 0; row < rows; row++) {
        NSMutableArray *rowary=[[NSMutableArray alloc] initWithCapacity:rows];
        for (NSInteger column = 0; column<rows; column++) {
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor purpleColor];
            [self.cells addObject:view];
            [rowary addObject:view];
        }
        [colarry addObject:[self viewRow:rowary]];
    }
    [self viewColumn:colarry];
}

- (UIView *)viewRow:(NSArray *)cells  {
    
    UIView * rowView = [UIView new];
    UIView *leftview = rowView;
    for (UIView *view in cells) {
        [rowView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            if (leftview == rowView) {
                make.leading.equalTo(leftview.mas_leading);
            }
            else {
                make.leading.equalTo(leftview.mas_trailing);
            }
            make.bottom.equalTo(@0);
            // make.width.equalTo(rowView).dividedBy([cells count]);
            if (leftview!=rowView) {
                make.width.equalTo(leftview.mas_width);
            }
        }];
        leftview = view;
    }
    
    UIView *rightest=[cells lastObject];
    [rightest mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@0);
    }];
    return rowView;
}

- (UIView *)viewColumn:(NSArray *)cells  {
    UIView * rowView = nil; ////self.gamePanel;
    UIView *leftview = rowView;
    
    for (UIView *view in cells) {
        [rowView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@0);
            if (leftview == rowView) {
                make.top.equalTo(leftview.mas_top);
            }
            else {
                make.top.equalTo(leftview.mas_bottom);
            }
            make.leading.equalTo(@0);
            // make.height.equalTo(rowView).dividedBy([cells count]);
            if (leftview!=rowView) {
                make.height.equalTo(leftview.mas_height);
            }
        }];
        leftview = view;
    }
    
    UIView *rightest = [cells lastObject];
    [rightest mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
    }];
    return rowView;
}

@end
