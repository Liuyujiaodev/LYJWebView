//
//  YLUtil.m
//  YLZhiNengYun
//
//  Created by 刘玉娇 on 2017/10/16.
//  Copyright © 2017年 yunli. All rights reserved.
//

#import "YLUtil.h"

@implementation YLUtil

+ (BOOL)isLogin {
    
    if ([YLUserDataManager getCuid] != nil && ![[YLUserDataManager getCuid] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}


@end

