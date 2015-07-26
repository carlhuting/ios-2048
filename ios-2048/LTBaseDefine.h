//
//  LTBaseDefine.h
//  ios-2048
//
//  Created by carl on 15/7/26.
//  Copyright (c) 2015年 lemontree. All rights reserved.
//

#ifdef DEBUG
#define LTLog(s, ...)                                                                                                 \
NSLog(@"<%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,                       \
[NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define LTLog(s, ...)
#endif
