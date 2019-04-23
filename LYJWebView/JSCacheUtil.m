//
//  JSCacheUtil.m
//  LYJWebViewDemo
//
//  Created by 娇 on 2019/4/23.
//  Copyright © 2019年 yunli. All rights reserved.
//

#import "JSCacheUtil.h"
#import "AFHTTPSessionManager.h"

#define kJS_PATH    @"jsFolder/js"
#define kCSS_PATH   @"jsFolder/css"

@implementation JSCacheUtil

+ (void)removeAllFile {
    NSArray* allFiles = [self allCacheFile];
    if (allFiles.count == 0) {
        return;
    }
    for (NSString* filePath in allFiles) {
        [self removeFileAtPathForDocument:filePath];
    }
}

+ (void)saveJSFile:(NSArray*)jsArray {
    [self download:jsArray folder:kJS_PATH];
}

+ (void)saveCSSFile:(NSArray*)cssArray {
    [self download:cssArray folder:kCSS_PATH];
}

+ (NSArray*)jsCacheFile {
   return [self allFileAtPath:[self jsFolderPath]];
}

+ (NSArray*)cssCacheFile {
    return [self allFileAtPath:[self cssFolderPath]];
}

+ (NSArray*)allCacheFile {
    return [[self jsCacheFile] arrayByAddingObjectsFromArray:[self cssCacheFile]];
}

+(NSArray*)cacheForUrl {
    NSArray* cacheArray = [self allCacheFile];
    NSMutableArray* cacheUrls = [NSMutableArray array];
    for (NSString* filePath in cacheArray) {
        NSURL* url = [NSURL fileURLWithPath:filePath];
        [cacheUrls addObject:url.lastPathComponent];
    }
    return cacheUrls;
}

+ (void)removeFileAtPathForDocument:(NSString *)filePath {
    NSError *error = nil;
    if (filePath) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"移除文件失败，错误信息：%@", error);
        }
        else {
            NSLog(@"成功移除文件");
        }
    }
    else {
        NSLog(@"文件不存在");
    }
}

+ (NSArray*)allFileAtPath:(NSString*)path {
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    return contents;
}

+ (NSString*)jsFolderPath {
    return [NSHomeDirectory() stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"/Documents/%@", kJS_PATH]];
}

+ (NSString*)cssFolderPath {
    return [NSHomeDirectory() stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"/Documents/%@", kCSS_PATH]];
}

+ (void)download:(NSArray*)urls folder:(NSString*)folder {
    for (NSString* url in urls) {
        AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        NSURLSessionDownloadTask *loadTask = [manger downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            //下载进度监听
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSString *fullPath = [self filePathForDocument:response.URL.lastPathComponent folerId:folder];
            [self removeFileAtPathForDocument:fullPath];
            return [NSURL fileURLWithPath:fullPath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        }];
        [loadTask resume];
    }
}

+ (NSString*)filePathForDocument:(NSString*)fileName folerId:(NSString*)folderId {
    NSString *archiveDirPath = [NSHomeDirectory() stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"/Documents/%@", folderId]];
    
    NSError* error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:archiveDirPath]) {
        
        if (![[NSFileManager defaultManager] createDirectoryAtPath:archiveDirPath
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory tmp/cachedModels directory error: %@", error);
            return nil;
        }
    }
    
    NSString *archivePath = [archiveDirPath stringByAppendingFormat:@"/%@", fileName];
    return archivePath;
}

@end
