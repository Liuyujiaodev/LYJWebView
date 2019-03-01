//
//  YLContactPhoneUtil.h
//  YLClient
//
//  Created by 刘玉娇 on 2018/1/25.
//  Copyright © 2018年 yunli. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^sendContactSuccess)(NSArray*);
typedef void (^sendContactFailure)();

typedef NS_ENUM(NSInteger, YLAuthUtilStatus) {
    YLAuthUtilStatusAuthed = 0,
    YLAuthUtilStatusDefined = 1,
    YLAuthUtilStatusNotDetermined = 2
};

typedef NS_ENUM(NSInteger, YLAuthLocationStatus) {
    YLAuthLocationStatusAuthed = 0,
    YLAuthLocationStatusDefined = 1,
    YLAuthLocationStatusNotDetermined = 2
};

@interface YWAuthUtil : NSObject

+ (BOOL)isGetContactAuth;
+ (void)reqeustAuth:(void (^)(BOOL granted))completionHandler;
+ (YLAuthUtilStatus)getContactStatus;
+ (void)sendContactSuccess:(sendContactSuccess)success failure:(sendContactFailure)failure;
+ (void)requestLocationAuth;
+ (YLAuthLocationStatus)getLocationStatus;

+(void)isNetDefine:(void (^)(BOOL granted))complete;

+ (NSString *)getDeviceType;
@end
