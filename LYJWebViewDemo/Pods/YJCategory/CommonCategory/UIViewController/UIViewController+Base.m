//
//  UIViewController+Base.m
//  YLClient
//
//  Created by 刘玉娇 on 2018/11/7.
//  Copyright © 2018年 yunli. All rights reserved.
//

#import "UIViewController+Base.h"

#define Bundle_Identifier   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]

@implementation UIViewController (Base)

- (void)pushToVC:(NSString*)vc withParamters:(NSDictionary*)params {
    NSString *url = [NSString stringWithFormat:@"%@://push/%@",[self getUrlSchemes], vc];
    if (params) {
        url = [url stringByAppendingString:@"?"];
        for (NSString* key in params.allKeys) {
            id value = [params objectForKey:key];
            url = [url stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,[self stringByUrlEncoding:value]]];
            if (![key isEqualToString:params.allKeys.lastObject]) {
                url = [url stringByAppendingString:@"&"];
            }
        }
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)pushToVC:(NSString*)vc {
    [self pushToVC:vc withParamters:nil];
}

- (NSString *)stringByUrlEncoding:(NSString*)str {
    NSString* str1 = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  (__bridge CFStringRef)str,  NULL,  (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    return [str1 stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
}

- (NSString*)getUrlSchemes {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSDictionary *bundleUrltypes = [infoDic objectForKey:@"CFBundleURLTypes"];
    NSString* urlSchemes;
    for (NSDictionary* types in bundleUrltypes) {
        if ([[types objectForKey:@"CFBundleURLName"] isEqualToString:Bundle_Identifier]) {
            NSArray* allUrlSchemes = (NSArray*)[types objectForKey:@"CFBundleURLSchemes"];
            if (allUrlSchemes.count > 0) {
                urlSchemes = [allUrlSchemes objectAtIndex:0];
                return urlSchemes;
            }
        }
    }
    return nil;
}
@end
