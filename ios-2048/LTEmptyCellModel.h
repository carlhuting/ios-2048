//
//  LTEmptyCellModel.h
//  ios-2048
//
//  Created by carl on 15/1/18.
//  Copyright (c) 2015年 lemontree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTEmptyCellModel : NSObject {
    @private
    NSMutableArray *emptyMatrix;
}
- (instancetype)initWithDimension:(NSInteger)dimension;
- (NSInteger)emptyCell;
- (void)addEmptyCell:(NSInteger)cell;
- (void)removeEmptyCell:(NSInteger)cell;
- (BOOL)isEmpty;
@end
