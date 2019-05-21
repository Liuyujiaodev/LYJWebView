//
//  MGFaceIDIDCardConfigItem.h
//  MGFaceIDIDCardKit
//
//  Created by MegviiDev on 2018/12/28.
//  Copyright © 2018 Megvii. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGFaceIDIDCardConfigItem : NSObject

/**
 是否为身份证阈值   默认值 0.5 （0 - 1.0）
 */
@property (nonatomic, assign) float isIDCard;

/**
 是否在引导框内阈值 默认值 0.5 （0 - 1.0）
 */
@property (nonatomic, assign) float inBound;

/**
 证件清晰度阈值  默认值 0.5 （0 - 1.0）
 */
@property (nonatomic, assign) float clear;

/**
 是否忽略光斑 默认值false
 */
@property (nonatomic, assign) BOOL isIgnoreHighlight;

/**
 是否忽略阴影 默认值false
 */
@property (nonatomic, assign) BOOL isIgnoreShadow;

@end

NS_ASSUME_NONNULL_END
