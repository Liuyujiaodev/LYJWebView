//
//  MGFaceIDIDCardKernelConfig.h
//  MGFaceIDIDCardKernelKit
//
//  Created by Megvii on 2018/10/9.
//  Copyright © 2018 Megvii. All rights reserved.
//

#ifndef MGFaceIDIDCardKernelConfig_h
#define MGFaceIDIDCardKernelConfig_h

//  身份证质量检测结果类型
typedef enum : NSUInteger {
    MGFaceIDIDCardQualityFailedNONE = 0,              //  没有错误
    MGFaceIDIDCardQualityFailedNotIDCard,             //  没有检测到身份证
    MGFaceIDIDCardQualityFailedNotInBound,            //  身份证不在引导框内
    MGFaceIDIDCardQualityFailedNotClear,              //  身份证清晰度差
    MGFaceIDIDCardQualityFailedHaveHighlight,         //  身份证存在光斑
    MGFaceIDIDCardQualityFailedHaveShadow,            //  身份证存在阴影
    MGFaceIDIDCardQualityFailedNeedFront,             //  需要检测身份证人像面信息
    MGFaceIDIDCardQualityFailedNeedBack,              //  需要检测身份证国徽面信息
    MGFaceIDIDCardQualityFailedConvert,               //  需要摆正身份证
    MGFaceIDIDCardQualityFailedParameterError,        //  参数异常
    MGFaceIDIDCardQualityFailedUnknown       = 1000,  //  未知错误
} MGFaceIDIDCardQualityFailedType;

/**
 检测的身份证面类型，默认为MGFaceIDIDCardSideFront
 MGFaceIDIDCardSideFront  人像面
 MGFaceIDIDCardSideBack   国徽面
 */
typedef enum : NSUInteger {
    MGFaceIDIDCardSideFront,
    MGFaceIDIDCardSideBack,
} MGFaceIDIDCardSide;

/**
 检测的身份证类型，默认为MGFaceIDIDCardTypeNormal
 MGFaceIDIDCardTypeNormal   一般身份证
 MGFaceIDIDCardTypeMongol   蒙古文身份证
 */
typedef enum : NSUInteger {
    MGFaceIDIDCardTypeNormal,
    MGFaceIDIDCardTypeMongol,
} MGFaceIDIDCardType;

#endif /* MGFaceIDIDCardKernelConfig_h */
