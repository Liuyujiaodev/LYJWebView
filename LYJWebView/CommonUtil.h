//
//  CommonUtil.h
//  YLClient
//
//  Created by 娇 on 2019/2/18.
//  Copyright © 2019年 yunli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonUtil : NSObject

//获取CPU
+ (NSString *)getHardParam;

//获取电池电量
+ (NSString*)getBatteryQuantity;

// 获得设备总内存
+ (NSString*)getTotalMemorySize;

//获取iIP地址
+ (NSString *)getIPAddress;

//获取手机类型
+ (NSString *)getDeviceType;

//获取系统版本号
+ (NSString*)getSystemVersion;

//手机存储总空间
+ (NSString*) totalDiskSpace;

//手机存储剩余空间
+ (NSString *) freeDiskSpaceInBytes;

//手机开机时间
+ (NSString *)getStartTime;
+ (NSString*)getScreenSize;
+ (NSString*)getiPhoneSize;

+ (BOOL)getBatteryStauts;

+ (NSDictionary*)Commondata;
@end

NS_ASSUME_NONNULL_END
