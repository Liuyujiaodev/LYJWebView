//
//  ASEUtil.m
//  YLClient
//
//  Created by 刘玉娇 on 2018/9/6.
//  Copyright © 2018年 yunli. All rights reserved.
//

#define Key      @"2a47ef0a9287518d253ec0c16a9efa47"
#define IV       @"91305fbf367df8e4"

#import "ASEUtil.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "Base64.h"

@implementation ASEUtil


+ (NSDictionary*_Nullable)decodeWithStr:(NSString*_Nullable)str {
    //    str = @"AyCCGxwcU9e9Js24U8nsXjI1jnpM13tSMmWobjOnoSRoOFQvGUFbp0/8Daqq7L3hzaEcwSZX7xXXkatUMbmSOp5oe+yPPEDfvWSg+l/kyUW2LY+qrf2ygEyD8aARGltMJcR9ymVF9Csza86Xu4hkAg==";
    
    NSData* data = [str base64DecodedData];
    NSString* jsonStr = [ASEUtil AES256DecryptWithData:data];
    NSError* error = nil;
    NSDictionary* dic = [[NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error] mutableCopy];
    return dic;
}

+ (NSDictionary*)encodeDic:(NSDictionary*)dic {
    NSError *parseError = nil;
    //前端先把数据格式化成json
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *base64Str = [ASEUtil AES256EncryptWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary* finalDic = [NSDictionary dictionaryWithObject:base64Str forKey:@"requestAesData"];
    return finalDic;
}

+ (NSString*)AES256EncryptWithData:(NSData*)data {
    return [self AES256DecryptWithKey:Key data:data withIV:IV opertion:kCCEncrypt];
}

+ (NSString *)AES256DecryptWithData:(NSData*)data {
    return [self AES256DecryptWithKey:Key data:data withIV:IV opertion:kCCDecrypt];
}

+ (NSString *)AES256DecryptWithKey:(NSString *)key data:(NSData*)data withIV:(NSString *)gIv opertion:(CCOperation)operation {
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES256,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess){
        NSLog(@"Success");
        
        NSData* data = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        NSString* str;
        if (operation == kCCEncrypt) {
            str = [data base64EncodedString];
        } else {
            str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    
        return str;
        
    }else{
        NSLog(@"Error");
    }
    
    free(buffer);
    
    return nil;
}

@end
