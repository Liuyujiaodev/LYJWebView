//
//  MGFaceIDIDCardDetectItem.h
//  MGFaceIDIDCardKit
//
//  Created by MegviiDev on 2018/12/28.
//  Copyright © 2018 Megvii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGFaceIDIDCardConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGFaceIDIDCardDetectQualityItem : NSObject

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
@property (nonatomic, assign) MGFaceIDIDCardDetectType idcardType;        //  身份证类型

@end

@interface MGFaceIDIDCardDetectResultItem : NSObject

/**
 采集到的完整图片
 */
@property (nonatomic, strong) UIImage* fullImage;

/**
 完整图片上的身份证范围
 */
@property (nonatomic, assign) CGRect idcardRect;

/**
 截取的身份证区域图片，该图片对身份证区域进行了扩大，扩大比例为15%
 */
@property (nonatomic, strong) UIImage* idcardImage;

/**
 完整图片上的人像范围，仅在[idcardPage == MGFaceIDIDCardShootPagePortrait]有意义
 */
@property (nonatomic, assign) CGRect idcardPortraitRect;

/**
 截取的人像区域图片，仅在[idcardPage == MGFaceIDIDCardShootPagePortrait]有意义
 */
@property (nonatomic, strong) UIImage* idcardPortraitImage;
@end

@interface MGFaceIDIDCardDetectItem : NSObject

/**
 身份证图像信息，详细信息请查看`MGFaceIDIDCardDetectResultItem`
 */
@property (nonatomic, strong) MGFaceIDIDCardDetectResultItem* idcardImageItem;

/**
 身份证拍摄面信息
 */
@property (nonatomic, assign) MGFaceIDIDCardShootPage idcardPage;

/**
 身份证检测详情信息
 */
@property (nonatomic, strong) MGFaceIDIDCardDetectQualityItem* idcardQuality;

@end

NS_ASSUME_NONNULL_END
