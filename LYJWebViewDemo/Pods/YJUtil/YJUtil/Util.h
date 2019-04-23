//
//  Util.h
//  XMShop
//
//  Created by 刘玉娇 on 16/2/25.
//  Copyright © 2016年 刘玉娇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject
+ (NSString*)getRandomStr;

/**
 *  判断是否有网络连接
 *
 *  @return bool类型
 */
+ (BOOL)isConnectionAvailable;
/**
 *  获取网络类型
 *
 *  @return wifi/2g/3g/4g/无网络
 */
+(NSString *)getNetWorkStates;

/**
 *  获取运营商信息
 *
 *  @return 电信，移动，联通
 */

+(NSString*)getcarrierName;

/**
 *  获取操作系统版本
 *
 *  @return float类型
 */
+ (float)getIOSVersion;

/**
 *  获取idfa（用了该方法必须得在提交app store时，选上idfa选项，否则会被拒）
 *
 *  @return float类型
 */
+ (NSString*)getIDFA;

/**
 *  获取应用的版本号
 *
 *  @return string
 */
+ (NSString *)getCurrentVersion;


/**
 *  拿到加密后的json串
 *
 *  @param dictionary 上传的字典
 *
 *  @return json串
 */
+ (NSString*)getEncodingStr:(NSDictionary*)dictionary;


/**
 *  拿到解密后的字符串
 *
 *  @param str 解密前的字符串
 *
 *  @return nsstring类型
 */
+ (NSString*)getDencodingStr:(NSString*)str;

/**
 *  拿到json 串
 *
 *  @param dic 字典
 *
 *  @return json串
 */
+ (NSString*)getJsonWith:(NSDictionary*)dic;

/*
 *
 * param: isNeedVerifySign 是否需要签名 将拿到的data转化为dictionary
 */
/**
 *  通过返回的data拿到字典
 *
 *  @param data             sever返回的数据
 *  @param isNeedVerifySign 是否需要验证签名
 *
 *  @return 字典
 */
+ (NSDictionary*)dictionaryWithData:(NSData*)data verifySign:(BOOL)isNeedVerifySign;

+ (NSDictionary*)dictionaryWithStr:(NSString*)str;
+ (BOOL)checkSign:(NSDictionary*)dictionary;
+ (BOOL)checkRequest:(NSDictionary*)dic;

/**
 *  判断是否请求成功
 *
 *  @param dic
 *
 *  @return bool类型
 */
+ (BOOL)isRequestOK:(NSDictionary*)dic;

+ (BOOL)isRequestOKWithOutSign:(NSDictionary *)dic;

/**
 *  将小数转换成字符串，若非零，且小数后有非零数字，则保留两位；否则返回非零数字或者零
 *  @param num
 *  @return
 */
+ (NSString *)showFloat:(float)num;

/**
 *  格式化时间
 *
 *  @param timestamp 时间戳
 *
 *  @return 14：00PM这样的
 */
+ (NSString*)convertDateTime:(NSNumber*)timestamp;

/**
 *  格式化日期
 *
 *  @param timestamp 时间戳
 *
 *  @return 2014.08.09这样的
 */
+ (NSString*)convertDate:(NSNumber*)timestamp;

+ (NSString*)convertDate:(NSNumber*)timestamp formatString:(NSString*)format;
/**
 *  拿到设备的类型
 */
+ (NSString *)getDeviceType;

/**
 *  md5 签名
 *  @param input
 *  @return
 */
+ (NSString *)md5:(NSString *)input;

+ (NSString*)getUrlEncodingStr:(NSDictionary*)dictionary;

/**
 *  处理图片
 */
+ (UIImage *)handlePicWith:(UIImage *)image WithMaxSize:(CGSize)size andPercent:(CGFloat)percent;

+ (UIImage *)expendPicWith:(UIImage *)image withHeight:(CGFloat)height;

#pragma mark
#pragma mark - 计算字符串的大小

+ (CGSize)calculateStringSizeWithString:(NSString *)string andFontNum:(CGFloat)fontNum andSize:(CGSize)size;

+ (CGSize)calculateSingleStringSizeWithString:(NSString *)string andFont:(UIFont *)font;

#pragma mark 创建Button
+ (UIButton*)createButtonFrame: (CGRect)frame Target: target BgColor: (UIColor*)bgColor Title: (NSString*)title TitleColor: (UIColor*)titleColor BgImg: (UIImage*)bgImg action: (SEL)action font: (float)font Tag: (int)tag;
//+ (UIButton*)createTouchButtonFrame: (CGRect)frame Target: target BgColor: (UIColor*)bgColor Title: (NSString*)title TitleColor: (UIColor*)titleColor BgImg: (UIImage*)bgImg Img: (UIImage*)img action: (SEL)action Tag: (int)tag;
#pragma mark 创建Label
+ (UILabel*)createLabelFrame: (CGRect)frame BgColor: (UIColor*)bgColor Text: (NSString*)text textColor: (UIColor*)textColor Font: (UIFont*)font TextAlignment: (NSTextAlignment)textAlignment Tag: (int)tag;
#pragma mark 创建UIImageView
+ (UIImageView*)createImageViewFrame: (CGRect)frame BgColor: (UIColor*)bgColor Img: (UIImage*)img Tag: (int)tag;
#pragma mark 颜色值 例如 #ffc6df 把#换成0xffc6df直接使用
+ (UIColor*)setColorWithInt: (int)newColor;
#pragma mark 以iPhone5为基础传PX值可以直接返回数值
+ (CGFloat)setWidthPX:(CGFloat)px;
+ (CGFloat)setHeightPX:(CGFloat)px;

//Document
+ (NSString*)filePathForDocument:(NSString*)fileName;
+ (NSString*)filePathForDocument:(NSString*)fileName folerId:(NSString*)folderId;

+ (void)removeFileAtPath:(NSString *)filePath;

+ (BOOL) persistModel:(id<NSCoding>)model withId:(NSString*)modelId;

+ (id<NSCoding>)cachedModelWithId:(NSString*)modelId;

+ (void)removeModelWithId:(NSString*)modelId;
+ (NSMutableArray*)localFile:(NSString*)folder;

+ (NSString*_Nullable)getRsaStr:(NSString*_Nullable)str;

+ (void)showAlertView:(UIViewController*_Nullable)vc title:(NSString*_Nullable)title message:(NSString*_Nullable)msg okAction:(NSString*_Nullable)ok cancelAction:(NSString*_Nullable)cancel okHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))okHandler cancelHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))cancelHandler;

+ (void)drawLinearGradient:(CGContextRef _Nullable )context
                      path:(CGPathRef _Nullable )path
                startColor:(CGColorRef _Nonnull )startColor
                  endColor:(CGColorRef _Nonnull )endColor;

+ (CAGradientLayer *_Nullable)setGradualChangingColor:(UIView *_Nullable)view fromColor:(UIColor*_Nullable)fromColor toColor:(UIColor *_Nullable)toColor;
+ (CAGradientLayer *_Nonnull)setHorizontalChangingColor:(UIView *_Nonnull)view fromColor:(UIColor*_Nullable)fromColor toColor:(UIColor *_Nullable)toColor;
+ (CAGradientLayer *_Nullable)setCorNerChangingColor:(UIView *_Nullable)view fromColor:(UIColor*_Nullable)fromColor toColor:(UIColor *_Nullable)toColor;

+ (NSMutableAttributedString*_Nonnull)attributeStrWithStr:(NSString*_Nullable)str withBeforFont:(UIFont*_Nonnull)font afterFont:(UIFont*_Nullable)afterFont;

+ (NSMutableAttributedString*_Nullable)attributeStrWithStr:(NSString*_Nullable)str;

+ (BOOL)isToday:(NSString*_Nonnull)timestamp;

+ (NSString*_Nullable)timeFormat:(NSString*_Nullable)timestamp;

+ (NSString*_Nullable)convertDate:(NSNumber*_Nullable)timestamp formatString:(NSString*_Nullable)format;

+ (UIFont*_Nullable)fontWithName:(NSString*_Nullable)name size:(CGFloat)fontSize;
+ (NSString*_Nullable)dateFormat:(NSString*_Nullable)timestamp;


+(NSString*_Nullable)getStringFromConfig:(NSString*_Nonnull)str;
+ (NSArray*_Nullable)jsonArrayWithStr:(NSString*_Nullable)str;
+ (NSString*_Nonnull)jsonStrWithArray:(NSArray*_Nonnull)array;

+ (void)getBtnAuthFromServer;
+ (BOOL)checkLocation;
+ (NSString*)getUrlSchemes;
@end
