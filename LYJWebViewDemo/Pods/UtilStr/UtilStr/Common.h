//
//  Common.h
//  YiMeiBusiness
//
//  Created by 刘玉娇 on 15/12/14.
//  Copyright © 2015年 Xiaolinxiaoli. All rights reserved.
//

// 自定义Log
#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...)
#endif

// 判断系统是否为iOS7
#define iSiOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 判断系统是否为iOS8
#define iSiOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

// 判断系统是否为iOS9
#define iSiOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)

#define iSiOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

#define iSiOS11 ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)

// 获得RGB颜色
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBAlphaColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define CURRENT_SYSTEM_VERSION       [[[UIDevice currentDevice] systemVersion] floatValue]

#define APP_VERSION                  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#define k_UI_DefaultFontName        @"FZLTHJW--GB1-0"

#define k_UI_FontDefault(x)      ([UIFont fontWithName:k_UI_DefaultFontName size:k_UI_Size(x)])


// 是否为4inch
#define IS_IPHONE_5 ([UIScreen mainScreen].bounds.size.height == 568)

#define IS_IPHONE_6 ([UIScreen mainScreen].bounds.size.height == 667.0)
#define IS_IPHONE_6P ([UIScreen mainScreen].bounds.size.height == 736.0)
// 屏幕宽高
#define APPWidth [UIScreen mainScreen].bounds.size.width
#define APPHeight [UIScreen mainScreen].bounds.size.height

#define APPControllerViewWidth     self.view.frame.size.width
#define APPControllerViewHeight    self.view.frame.size.height

#define APPViewWidth               self.frame.size.width
#define APPViewHeight              self.frame.size.height

#define APPTopBarOutsidHeight (APPControllerViewHeight - APP_STATUS_HEIGHT) //除去顶层topBar后的高

#define kDevice_Is_iPhoneX (([[UIApplication sharedApplication] statusBarFrame].size.height == 44.0f) ? (YES):(NO))

#define APP_STATUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define APP_NAV_BAR_HEIGHT 44

#define APP_STATUS_NAVBAR_HEIGHT (APP_STATUS_HEIGHT+APP_NAV_BAR_HEIGHT)
// 比例
#define APP_HScale APPWidth / 375

// 沙盒文件
#define UserDefaults [NSUserDefaults standardUserDefaults]

//APP版本号
#define APP_Version [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

#define APP_Name [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
// 设备ID
#define YMBCURRENT_DEVICE_ID [[UIDevice currentDevice] identifierForVendor].UUIDString

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kCOMMON_COLOR   RGBColor(244, 108, 40)
