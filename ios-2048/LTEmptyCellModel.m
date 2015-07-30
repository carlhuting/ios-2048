//
//  LTEmptyCellModel.m
//  ios-2048
//
//  Created by carl on 15/1/18.
//  Copyright (c) 2015年 lemontree. All rights reserved.
//

#import "LTEmptyCellModel.h"

@implementation LTEmptyCellModel
{
    NSInteger capacity;
}

- (instancetype)initWithDimension:(NSInteger)dimension {
    self = [super init];
    if (self) {
        capacity = dimension * dimension;
        [self reset];
    }
    return self;
}
- (NSInteger)emptyCell {
    NSInteger index = (NSInteger)arc4random_uniform((u_int32_t)[emptyMatrix count]);
    NSNumber *emptyNumber = [emptyMatrix objectAtIndex:index];
    [self removeEmptyCell:emptyNumber.integerValue];
    return emptyNumber.integerValue;
}

- (void)removeEmptyCell:(NSInteger)cell {
    [emptyMatrix removeObject:@(cell)];
    LTLog(@"remove emptycell at %ld",(long)cell);
}

- (void)addEmptyCell:(NSInteger)cell {
    [emptyMatrix addObject:@(cell)];
     LTLog(@"add emptycell at %ld",(long)cell);
}

- (BOOL)isEmpty {
    return [emptyMatrix count] == 0;
}

- (void)reset {
    emptyMatrix = [[NSMutableArray alloc] initWithCapacity:capacity];
    for (NSInteger i = 0; i<capacity; i++) {
        [emptyMatrix addObject:@(i)];
    }
}

@end
