//
//  MGFaceIDIDCardKernelDetectItem.h
//  MGFaceIDIDCardKernelKit
//
//  Created by Megvii on 2018/10/9.
//  Copyright © 2018 Megvii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGFaceIDIDCardKernelConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGFaceIDIDCardKernelQualityItem : NSObject

@property (nonatomic, assign) CGFloat idcardCredibilityF;   //  身份证可信度，范围[0, 1]
@property (nonatomic, assign) CGFloat inIDCardBoundF;       //  身份证在引导框内，范围[0, 1]
@property (nonatomic, assign) CGFloat idcardClarityF;       //  身份证清晰度，范围[0, 1]
@property (nonatomic, assign) BOOL hasShadow;               //  是否存在阴影
@property (nonatomic, assign) NSInteger shadowCount;        //  阴影数量
@property (nonatomic, strong) NSArray<NSValue *>* shadowList;       //  阴影位置，NSValue(CGRect)
@property (nonatomic, assign) BOOL hasHighlight;            //  是否存在光斑
@property (nonatomic, assign) NSInteger highlightCount;     //  光斑数量
@property (nonatomic, strong) NSArray<NSValue *>* highlightList;    //  光斑位置，NSValue(CGRect)
//  图片亮度，范围[0, 1]，仅在[failedType == MegFaceIDIDCardQualityFailedNONE]有意义
@property (nonatomic, assign) CGFloat brightnessF;          //  照片亮度
@property (nonatomic, assign) MGFaceIDIDCardSide idcardSide;        //  身份证面类型
@property (nonatomic, assign) MGFaceIDIDCardType idcardType;        //  身份证类型

@end

@interface MGFaceIDIDCardKernelDetectItem : NSObject


/**
 身份证质量检测结果类型，详情请查看 MGFaceIDIDCardQualityFailedType
 */
@property (nonatomic, assign) MGFaceIDIDCardQualityFailedType failedType;

/**
 当前帧身份证检测详情信息
 */
@property (nonatomic, strong) MGFaceIDIDCardKernelQualityItem* idcardQuality;

/**
 检测的完整图片
 */
@property (nonatomic, strong) UIImage* fullImage;

/**
 完整图片上的身份证范围, 仅在[failedType == MegFaceIDIDCardQualityFailedNONE]有意义
 */
@property (nonatomic, assign) CGRect idcardRect;

/**
 截取的身份证范围区域图片
 */
@property (nonatomic, strong) UIImage* idcardImage;

/**
 完整图片上的人像范围，仅在[failedType == MegFaceIDIDCardQualityFailedNONE && idcardQuality.idcardSide == MGFaceIDIDCardSideFront]有意义
 */
@property (nonatomic, assign) CGRect idcardPortraitRect;

/**
 截取的人像区域图片
 */
@property (nonatomic, strong) UIImage* idcardPortraitImage;

@end

NS_ASSUME_NONNULL_END
