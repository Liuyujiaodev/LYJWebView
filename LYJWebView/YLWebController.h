//
//  YLWebController.h
//  YLClient
//
//  Created by 刘玉娇 on 2018/11/14.
//  Copyright © 2018年 yunli. All rights reserved.
//

#import "LYJOwnWebController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLWebController : LYJOwnWebController

@property (nonatomic, copy) NSString* applyId;

@property (nonatomic, assign) BOOL toRootVC;
+ (void)setUserAgent;

@end

NS_ASSUME_NONNULL_END
