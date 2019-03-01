//
//  YLUserDataManager.m
//  YLClient
//
//  Created by 刘玉娇 on 2018/1/23.
//  Copyright © 2018年 yunli. All rights reserved.
//

#define YL_STORE_PHONE      @"phone"
#define YL_STORE_USER_ID    @"cuid"

#import "YLUserDataManager.h"

@implementation YLUserDataManager

+ (void)saveCuid:(NSString*)cuid {
    [[NSUserDefaults standardUserDefaults] setObject:cuid forKey:YL_STORE_USER_ID];
}

+ (NSString*)getCuid {
    return [[NSUserDefaults standardUserDefaults] objectForKey:YL_STORE_USER_ID];
}

+ (void)savePhone:(NSString*)phone {
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:YL_STORE_PHONE];
}

+ (NSString*)getPhone {
    NSString* phone = [[NSUserDefaults standardUserDefaults] objectForKey:YL_STORE_PHONE];
    return phone;
}

+ (void)removeUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:YL_STORE_USER_ID];
}

@end
