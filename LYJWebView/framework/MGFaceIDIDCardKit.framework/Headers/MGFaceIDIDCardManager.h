//
//  MGFaceIDIDCardManager.h
//  MGFaceIDIDCardKit
//
//  Created by MegviiDev on 2018/12/28.
//  Copyright © 2018 Megvii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGFaceIDIDCardErrorItem.h"
#import "MGFaceIDIDCardConfig.h"
#import "MGFaceIDIDCardConfigItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGFaceIDIDCardManager : NSObject

- (instancetype)init DEPRECATED_ATTRIBUTE;

/**
 初始化FaceID自助接入身份证检测
 @param error 错误类型
 @return 初始化对象
 */

- (instancetype _Nullable)initMGFaceIDIDCardManagerWithExtraData:(NSDictionary *__nullable)extraDict error:(MGFaceIDIDCardErrorItem *__nullable*__nullable)error;

/**
 开始身份证检测
 
 @param detectVC 启动检测的当前页面
 @param screenOrientation 设备拍摄横竖屏模式
 @param shootPage 身份证拍摄页面
 @param configItem 检测阈值设置
 @param block 检测结果
 */

- (void)startMGFaceIDIDCardDetect:(UIViewController *__nonnull)detectVC
                screenOrientation:(MGFaceIDIDCardScreenOrientation)screenOrientation
                        shootPage:(MGFaceIDIDCardShootPage)shootPage
                     detectConfig:(MGFaceIDIDCardConfigItem *__nullable)configItem
                         callback:(FaceIDIDCardDetectResultBlock __nullable)block;

/**
 获取SDK版本号信息
 
 @return SDK版本号
 */
+ (NSString *_Nonnull)getSDKVersion;

/**
 获取SDK构建信息
 
 @return SDK构建号
 */
+ (NSString *_Nonnull)getSDKBuild;

@end

NS_ASSUME_NONNULL_END
