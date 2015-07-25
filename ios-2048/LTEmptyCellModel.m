//
//  LTEmptyCellModel.m
//  ios-2048
//
//  Created by carl on 15/1/18.
//  Copyright (c) 2015年 lemontree. All rights reserved.
//

#import "LTEmptyCellModel.h"

@implementation LTEmptyCellModel

- (instancetype)initWithDimension:(NSInteger)dimension {
    self = [super init];
    if (self) {
        emptyMatrix = [[NSMutableArray alloc] initWithCapacity:dimension*dimension];
        for (NSUInteger i=0; i<16; i++) {
            [emptyMatrix addObject:@(i)];
        }
    }
    return self;
}
- (NSInteger)emptyCell {
    NSUInteger index = (NSUInteger)arc4random_uniform((u_int32_t)[emptyMatrix count]);
    NSNumber *emptyNumber = [emptyMatrix objectAtIndex:index];
    [emptyMatrix removeObjectAtIndex:index];
    return emptyNumber.intValue;
}

- (void)removeEmptyCell:(NSInteger)cell {
    for (NSInteger i=0; i<[emptyMatrix count]; i++) {
        if (cell == [emptyMatrix[i] intValue]) {
            [emptyMatrix removeObjectAtIndex:i];
            NSLog(@"remove emptycell at %d",cell);
            return;
        }
    }
}

- (void)addEmptyCell:(NSInteger)cell {
    [emptyMatrix addObject:@(cell)];
}

- (BOOL)isEmpty {
    return [emptyMatrix count] == 0;
}

@end
