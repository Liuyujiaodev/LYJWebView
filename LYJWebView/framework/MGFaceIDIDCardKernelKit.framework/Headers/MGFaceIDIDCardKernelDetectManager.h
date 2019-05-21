//
//  MGFaceIDIDCardKernelDetectManager.h
//  MGFaceIDIDCardKernelKit
//
//  Created by Megvii on 2018/10/9.
//  Copyright © 2018 Megvii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGFaceIDIDCardKernelConfigItem.h"
#import "MGFaceIDIDCardKernelDetectItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGFaceIDIDCardKernelDetectManager : NSObject

/**
 初始化身份证质量检测管理器

 @param modelData 模型资源
 @param configItem 检测配置
 @return 管理器对象
 */
- (instancetype)initWithIDCardModel:(NSData *)modelData detectConfig:(MGFaceIDIDCardKernelConfigItem *)configItem NS_DESIGNATED_INITIALIZER;

/**
 检测图片

 @param detectImage 需要检测的图片
 @param idcardSide 期望的身份证面
 @return 检测结果
 */
- (MGFaceIDIDCardKernelDetectItem *)detectIDCardWithImage:(UIImage *)detectImage idcardSide:(MGFaceIDIDCardSide)idcardSide;

/**
 检测指定身份证区域的图片
 
 @param detectImage 需要检测的图片
 @param idcardSide 期望的身份证面
 @param ROI 指定身份证ROI区域
 @return 检测结果
 */
- (MGFaceIDIDCardKernelDetectItem *)detectIDCardWithImage:(UIImage *)detectImage idcardSide:(MGFaceIDIDCardSide)idcardSide screenROI:(CGRect)ROI;

/**
 获取SDK版本号信息
 
 @return SDK版本号
 */
+ (NSString *)getSDKVersion;


/**
 获取SDK构建版本信息
 
 @return SDK构建版本信息
 */
+ (NSString *)getSDKBuild;

@end

NS_ASSUME_NONNULL_END
