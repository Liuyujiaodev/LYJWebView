//
//  ASEUtil.h
//  YLClient
//
//  Created by 刘玉娇 on 2018/9/6.
//  Copyright © 2018年 yunli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASEUtil : NSObject

+ (NSDictionary*_Nullable)decodeWithStr:(NSString*_Nullable)str;
+ (NSDictionary*)encodeDic:(NSDictionary*)dic;

+ (NSString*)AES256EncryptWithData:(NSData*)data;   //加密

+ (NSString *)AES256DecryptWithData:(NSData*)data;
@end
