//
//  MGFaceIDIDCardConfig.h
//  MGFaceIDIDCardKit
//
//  Created by MegviiDev on 2018/12/28.
//  Copyright © 2018 Megvii. All rights reserved.
//

#ifndef MGFaceIDIDCardConfig_h
#define MGFaceIDIDCardConfig_h

@class MGFaceIDIDCardDetectItem;
@class MGFaceIDIDCardErrorItem;

//  身份证检测错误类型
typedef enum : NSUInteger {
    MGFaceIDIDCardErrorNone,                            //  没有错误
    MGFaceIDIDCardErrorUserCancel ,                     //  用户取消
    MGFaceIDIDCardErrorDeviceNotSupport,                //  手机没有打开摄像头或者硬件不支持
    MGFaceIDIDCardErrorNoCameraPermission,              //  没有打开相机的权限，请开启权限后重试
    MGFaceIDIDCardErrorIllegalParameter,                //  传入参数不合法
    MGFaceIDIDCardErrorNotModel,                        //  未找到指定的模型资源
    MGFaceIDIDCardErrorAuthenticationFail,              //  鉴权失败
    MGFaceIDIDCardErrorInitFailed,                      //  SDK 初始化失败
    MGFaceIDIDCardErrorNoIDCardBothSide,                //  没有采集到身份证双面信息
    MGFaceIDIDCardErrorNoIDCardFrontSideSingle,         //  没有采集到身份证人像面信息
    MGFaceIDIDCardErrorNoIDCardBackSideSingle,          //  没有采集到身份证国徽面信息
    MGFaceIDIDCardErrorUnknown,                         //  未知错误，错误原因查看error_message信息
} MGFaceIDIDCardErrorType;

/**
 拍摄模式，默认为MGFaceIDIDCardScreenOrientationVertical
 *  MGFaceIDIDCardScreenOrientationVertical    竖屏模式
 *  MGFaceIDIDCardScreenOrientationLandscape   横屏模式
 */
typedef enum : NSUInteger {
    MGFaceIDIDCardScreenOrientationVertical,
    MGFaceIDIDCardScreenOrientationLandscape,
} MGFaceIDIDCardScreenOrientation;

/**
 拍摄页面，默认为MGFaceIDIDCardShootPagePortrait
 *  MGFaceIDIDCardShootPagePortrait            人像面
 *  MGFaceIDIDCardShootPageNationalEmblem      国徽面
 */
typedef enum : NSUInteger {
    MGFaceIDIDCardShootPagePortrait,
    MGFaceIDIDCardShootPageNationalEmblem,
} MGFaceIDIDCardShootPage;

/**
 检测的身份证类型，默认为MGFaceIDIDCardDetectTypeNormal
 MGFaceIDIDCardDetectTypeNormal   一般身份证
 MGFaceIDIDCardDetectTypeMongol   蒙古文身份证
 */
typedef enum : NSUInteger {
    MGFaceIDIDCardDetectTypeNormal,
    MGFaceIDIDCardDetectTypeMongol,
} MGFaceIDIDCardDetectType;

typedef void(^FaceIDIDCardDetectResultBlock)(MGFaceIDIDCardErrorItem* errorItem, MGFaceIDIDCardDetectItem* detectItem, NSDictionary* extraOutDataDict);

#endif /* MGFaceIDIDCardConfig_h */
