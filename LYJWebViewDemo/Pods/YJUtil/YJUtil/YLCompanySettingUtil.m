//
//  YLCompanySettingUtil.m
//  YLClient
//
//  Created by 刘玉娇 on 2018/8/28.
//  Copyright © 2018年 yunli. All rights reserved.
//

#import "YLCompanySettingUtil.h"

@implementation YLCompanySettingUtil

+ (NSString*)getCompanyCid {
    NSString* path = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"privateCompanySetting" ofType:@"plist"];

    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString* bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary* companyDic = [dic objectForKey:bundleId];
    if (companyDic && companyDic.allKeys.count > 0) {
        return [companyDic objectForKey:@"cid"];
    }
    return nil;
}

+ (NSString*)getBaiduMap {
    NSString* path = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"privateCompanySetting" ofType:@"plist"];
    
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString* bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary* companyDic = [dic objectForKey:bundleId];
    if (companyDic && companyDic.allKeys.count > 0) {
        return [companyDic objectForKey:@"baiduMapKey"];
    }
    return @"KXcuraG678jTjfzmZlC9OfCDIAcrSNHX";
}

+(NSString*)getLoginBgImageStr {
    NSString* path = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"privateCompanySetting" ofType:@"plist"];
    
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString* bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary* companyDic = [dic objectForKey:bundleId];
    if (companyDic && companyDic.allKeys.count > 0) {
        return [companyDic objectForKey:@"loginBg"];
    }
    return @"default";
}
@end
