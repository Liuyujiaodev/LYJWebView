//
//  YLUserDataManager.h
//  YLClient
//
//  Created by 刘玉娇 on 2018/1/23.
//  Copyright © 2018年 yunli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLUserDataManager : NSObject

+ (void)saveCuid:(NSString*)cuid;

+ (NSString*)getCuid;

+ (void)savePhone:(NSString*)phone;

+ (NSString*)getPhone;

+ (void)removeUserInfo;

@end
