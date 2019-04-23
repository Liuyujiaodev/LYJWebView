//
//  JSCacheUtil.h
//  LYJWebViewDemo
//
//  Created by 娇 on 2019/4/23.
//  Copyright © 2019年 yunli. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSCacheUtil : NSObject

+ (void)removeAllFile;

+ (void)saveJSFile:(NSArray*)jsArray;

+ (void)saveCSSFile:(NSArray*)cssArray;

+ (NSArray*)jsCacheFile;

+ (NSArray*)cssCacheFile;

+ (NSArray*)allCacheFile;

+ (NSArray*)cacheForUrl;

+ (NSString*)jsFolderPath;

+ (NSString*)cssFolderPath;
@end

NS_ASSUME_NONNULL_END
