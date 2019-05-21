//
//  DemoNGFaceIDNetwork.h
//  DemoMGFaceIDLiveDetect
//
//  Created by 聪颖不聪颖 on 2018/9/11.
//  Copyright © 2018年 Megvii. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FaceRequestSuccess)(NSInteger statusCode, NSDictionary* responseObject);
typedef void(^FaceRequestFailure)(NSInteger statusCode, NSError* error);
typedef void(^FaceORCSuccessResult)(NSDictionary* responseObject);
typedef void(^FaceORCFailureResult)(NSError* error);

@interface DemoMGFaceIDNetwork : NSObject

+ (DemoMGFaceIDNetwork *)singleton;

- (NSString *)getFaceIDSignStr;

- (void)getOCRResult:(NSString*)key secret:(NSString*)secret img:(UIImage*)img success:(FaceORCSuccessResult)success failure:(FaceORCFailureResult)failure;

- (void)queryDemoMGFaceIDAntiSpoofingBizTokenLiveConfig:(NSDictionary *)liveInfo key:(NSString*)key secret:(NSString*)secret success:(FaceRequestSuccess)successBlock failure:(FaceRequestFailure)failureBlock;

- (void)queryDemoMGFaceIDAntiSpoofingVerifyWithBizToken:(NSString *)bizTokenStr key:(NSString*)key secret:(NSString*)secret verify:(NSData *)megliveData success:(FaceRequestSuccess)successBlock failure:(FaceRequestFailure)failureBlock;

@end
