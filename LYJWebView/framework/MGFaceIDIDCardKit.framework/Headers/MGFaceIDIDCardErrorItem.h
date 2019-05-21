//
//  MGFaceIDIDCardErrorItem.h
//  MGFaceIDIDCardKit
//
//  Created by MegviiDev on 2018/12/28.
//  Copyright © 2018 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGFaceIDIDCardConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGFaceIDIDCardErrorItem : NSObject

//  身份证检测错误类型
@property (nonatomic, assign) MGFaceIDIDCardErrorType errorType;
//  身份证检测错误信息
@property (nonatomic, strong) NSString* errorMessage;

- (instancetype)initWithErrorType:(MGFaceIDIDCardErrorType)error errorMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
