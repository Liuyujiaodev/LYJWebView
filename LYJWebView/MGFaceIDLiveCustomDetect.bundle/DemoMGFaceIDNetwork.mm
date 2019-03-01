//
//  DemoNGFaceIDNetwork.m
//  DemoMGFaceIDLiveDetect
//
//  Created by 聪颖不聪颖 on 2018/9/11.
//  Copyright © 2018年 Megvii. All rights reserved.
//

#import "DemoMGFaceIDNetwork.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <math.h>
#import <AFNetworking/AFNetworking.h>

#define kMGFaceIDNetworkHost @"https://api.megvii.com"
#define kMGFaceIDNetworkTimeout 30


@implementation DemoMGFaceIDNetwork

static DemoMGFaceIDNetwork* sing = nil;
static AFHTTPSessionManager* sessionManager = nil;
+ (DemoMGFaceIDNetwork *)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sing = [[DemoMGFaceIDNetwork alloc] init];
        sessionManager = [[AFHTTPSessionManager manager] init];
    });
    return sing;
}


- (void)queryDemoMGFaceIDAntiSpoofingBizTokenLiveConfig:(NSDictionary *)liveInfo key:(NSString*)key secret:(NSString*)secret success:(FaceRequestSuccess)successBlock failure:(FaceRequestFailure)failureBlock {
    [sessionManager.requestSerializer setValue:@"multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"sign" : [self getFaceIDSignStr:key secret:secret],
                                                                                    @"sign_version" : [self getFaceIDSignVersionStr]
                                                                                    }];
    [params addEntriesFromDictionary:liveInfo];
    [sessionManager POST:[NSString stringWithFormat:@"%@/faceid/v3/sdk/get_biz_token", kMGFaceIDNetworkHost]
              parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

}
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (successBlock) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                             successBlock([urlResponse statusCode], (NSDictionary *)responseObject);
                         });
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (failureBlock) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                             NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                            NSDictionary * body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                             failureBlock([urlResponse statusCode], error);
                         });
                     }
                 }];
}

- (void)queryDemoMGFaceIDAntiSpoofingVerifyWithBizToken:(NSString *)bizTokenStr key:(NSString*)key secret:(NSString*)secret verify:(NSData *)megliveData success:(FaceRequestSuccess)successBlock failure:(FaceRequestFailure)failureBlock {
    [sessionManager.requestSerializer setValue:@"multipart/form-data; charset=utf-8; boundary=__X_PAW_BOUNDARY__" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"sign" : [self getFaceIDSignStr:key secret:secret],
                                                                                    @"sign_version" : [self getFaceIDSignVersionStr],
                                                                                    @"biz_token" : bizTokenStr,
                                                                                    }];
    [sessionManager POST:[NSString stringWithFormat:@"%@/faceid/v3/sdk/verify", kMGFaceIDNetworkHost]
              parameters:params
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:megliveData name:@"meglive_data" fileName:@"meglive_data" mimeType:@"text/html"];
    }
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (successBlock) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                             successBlock([urlResponse statusCode], (NSDictionary *)responseObject);
                         });
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (failureBlock) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse *)task.response;
                             failureBlock([urlResponse statusCode], error);
                         });
                     }
                 }];
}



- (NSString *)getFaceIDSignStr:(NSString*)key secret:(NSString*)secret {
    int valid_durtion = 1000;
    long int current_time = [[NSDate date] timeIntervalSince1970];
    long int expire_time = current_time + valid_durtion;
    long random = abs(arc4random() % 100000000000);
    NSString* str = [NSString stringWithFormat:@"a=%@&b=%ld&c=%ld&d=%ld", key, expire_time, current_time, random];
    const char *cKey  = [secret cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [str cStringUsingEncoding:NSUTF8StringEncoding];
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSData* sign_raw_data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [[NSMutableData alloc] initWithData:HMAC];
    [data appendData:sign_raw_data];
    NSString* signStr = [data base64EncodedStringWithOptions:0];
    return signStr;
}

- (NSString *)getFaceIDSignVersionStr {
    return @"hmac_sha1";
}

@end
