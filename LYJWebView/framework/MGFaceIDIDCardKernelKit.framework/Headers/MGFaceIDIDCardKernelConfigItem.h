//
//  MGFaceIDIDCardKernelConfigItem.h
//  MGFaceIDIDCardKernelKit
//
//  Created by Megvii on 2018/10/9.
//  Copyright © 2018 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGFaceIDIDCardKernelConfigItem : NSObject

/**
 身份证可信度阈值  默认值 0.5 阈值范围（0 - 1.0），值越大，身份证可信度越高
 */
@property (nonatomic, assign) float isIDCard;

/**
 引导框内阈值  默认值 0.5 阈值范围（0 - 1.0），值越大，在引导框内的可信度越高
 */
@property (nonatomic, assign) float inBound;

/**
 证件清晰度阈值  默认值 0.5 阈值范围（0 - 1.0），值越大，清晰度越高
 */
@property (nonatomic, assign) float clear;

/**
 是否忽略光斑  默认值false，不忽略
 */
@property (nonatomic, assign) BOOL isIgnoreHighlight;

/**
 是否忽略阴影  默认值false，不忽略
 */
@property (nonatomic, assign) BOOL isIgnoreShadow;

@end

NS_ASSUME_NONNULL_END
