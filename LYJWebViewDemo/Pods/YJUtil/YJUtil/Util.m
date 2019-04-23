//
//  Util.m
//  XMShop
//
//  Created by 刘玉娇 on 16/2/25.
//  Copyright © 2016年 刘玉娇. All rights reserved.
//

#define APPWidth [UIScreen mainScreen].bounds.size.width
#define APPHeight [UIScreen mainScreen].bounds.size.height
#define Bundle_Identifier   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]

#import "Util.h"
#import "Reachability.h"
//#import <CommonCrypto/CommonDigest.h> //MD_5
#import <sys/utsname.h>
#import  <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "CommonCategory.h"
#import "Base64.h"
#import <CoreLocation/CoreLocation.h>

@implementation Util

+ (BOOL)isConnectionAvailable {
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    return isExistenceNetwork;
}

+(NSString *)getNetWorkStates {

    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = @"";
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}
+(NSString*)getcarrierName {
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry=[carrier carrierName];
    
    return currentCountry;
}

+ (float)getIOSVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}


+ (NSString*)getIDFA {
    if ([ASIdentifierManager sharedManager].advertisingTrackingEnabled) {
        NSString * adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        return adId;
    } else {
        return @"";
    }
}

+ (NSString *)getCurrentVersion {
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* version =[infoDict objectForKey:@"CFBundleShortVersionString"];
    
    return version;
}


#pragma mark
#pragma mark - 做URL的编码

+ (NSString *)stringByUrlEncoding:(NSString*)str {
    NSString* str1 = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  (__bridge CFStringRef)str,  NULL,  (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    return [str1 stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
}


#pragma mark
#pragma mark- 转化为url参数格式

+ (NSString*)getUrlEncodingStr:(NSDictionary*)dictionary {
    NSString* str = @"";
    NSArray* sortArray = [[dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger result = [a localizedCaseInsensitiveCompare:b];
        if (result != NSOrderedSame)
            return result;
        return [a localizedCaseInsensitiveCompare:b];
    }];
    
    for (int i = 0; i < sortArray.count; i++) {
        NSString* key = [sortArray objectAtIndex:i];
        NSString* value = [dictionary valueForKey:key];
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            if ([value isKindOfClass:[NSString class]]) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, [self stringByUrlEncoding:value]]];
            } else {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, value]];
            }
            if (i < [dictionary.allKeys count] - 1) {
                str = [str stringByAppendingString:@"&"];
            }
        }
    }
    return str;
}


#pragma mark
#pragma mark - 交换两个字符（后四位不变）

+ (NSString*)changeString:(NSString*)str {
    NSString* newStr = @"";
    NSString* subString = [str substringToIndex:(str.length-4)];
    NSString* subString2 = [str substringFromIndex:(str.length- 4)];
    for (int i = 0; i < subString.length/2; i++) {
        newStr = [newStr stringByAppendingString:[str substringWithRange:NSMakeRange(i*2+1, 1)]];
        newStr = [newStr stringByAppendingString:[str substringWithRange:NSMakeRange(i*2, 1)]];
    }
    
    newStr = [newStr stringByAppendingString:subString2];
    return newStr;
}


#pragma mark
#pragma mark - 将dictionary转化未json字符串

+ (NSString*)getJsonWith:(NSDictionary*)dic {
    NSString *json = @"";
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        if(!error) {
            json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    else
        NSLog(@"Not a valid JSON object: %@", dic);
    return json;
}


#pragma mark
#pragma mark - 拿到解码的字符串

+ (NSString*)getDencodingStr:(NSString*)str {
    NSString* newStr = [NSString stringWithBase64EncodedString:[self changeString:str]];
    return newStr;
}


#pragma mark
#pragma mark - 将拿到的data转化为dictionary ，是否需要解码

+ (NSDictionary*)dictionaryWithData:(NSData*)data verifySign:(BOOL)isNeedDencoding {
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (str != nil && ![str isEqualToString:@""]) {
        
        NSString* json = isNeedDencoding ? [self getDencodingStr:str] : str;
        NSError *error = nil;
        NSMutableDictionary* dic = [[NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSASCIIStringEncoding]
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&error] mutableCopy];
        return dic;
    } else
        return nil;
}

+ (NSDictionary*)dictionaryWithStr:(NSString*)str {
    if (str != nil && ![str isEqualToString:@""]) {
        NSError *error = nil;
        NSMutableDictionary* dic = [[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSASCIIStringEncoding]
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&error] mutableCopy];
        return dic;
    } else
        return nil;
}

+ (BOOL)checkRequest:(NSDictionary*)dic {
    int status = [[dic objectForKey:@"status"] intValue];
    if (status == 0) {
        return YES;
    } else
        return NO;
}

#pragma mark
#pragma mark - 判断网络请求是否成功

+ (BOOL)isRequestOK:(NSDictionary*)dic {
    int status = [[dic objectForKey:@"status"] intValue];
    BOOL isRequestOk;
    if (status == 0) {
        isRequestOk = YES;
    } else {
        NSLog(@"\n******************\n status==0 \n******************");
        isRequestOk = NO;
    }
    BOOL isSignOk = [self checkSign:dic];
    if (isRequestOk && isSignOk) {
        return YES;
    }
    return NO;
}

+ (BOOL)isRequestOKWithOutSign:(NSDictionary *)dic {
    int status = [[dic objectForKey:@"status"] intValue];
    if (status == 0) {
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark device_type

+ (NSString *)getDeviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //--------------------iphone-----------------------
    if ([deviceString isEqualToString:@"i386"] || [deviceString isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"] || [deviceString isEqualToString:@"iPhone3,2"] || [deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"] || [deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"] || [deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"] || [deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";

    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iphone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iphone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";

    if ([deviceString isEqualToString:@"iPhone9,1"] || [deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"] || [deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"] || [deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"] || [deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";

    //--------------------ipod-----------------------
    if ([deviceString isEqualToString:@"iPod1,1"])    return @"iPod touch";
    if ([deviceString isEqualToString:@"iPod2,1"])    return @"iPod touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])    return @"iPod touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])    return @"iPod touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])    return @"iPod touch 5G";
    if ([deviceString isEqualToString:@"iPod7,1"])    return @"iPod touch 6G";

  
    //--------------------ipad-------------------------
    if ([deviceString isEqualToString:@"iPad1,1"])    return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"] || [deviceString isEqualToString:@"iPad2,2"] || [deviceString isEqualToString:@"iPad2,3"] || [deviceString isEqualToString:@"iPad2,4"])    return @"iPad 2";
  
    if ([deviceString isEqualToString:@"iPad3,1"] || [deviceString isEqualToString:@"iPad3,2"] || [deviceString isEqualToString:@"iPad3,3"])    return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"] || [deviceString isEqualToString:@"iPad3,5"] || [deviceString isEqualToString:@"iPad3,6"])    return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"] || [deviceString isEqualToString:@"iPad4,2"] || [deviceString isEqualToString:@"iPad4,3"])    return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"] || [deviceString isEqualToString:@"iPad5,4"])    return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,7"] || [deviceString isEqualToString:@"iPad6,8"])    return @"iPad Pro 12.9-inch";
    if ([deviceString isEqualToString:@"iPad6,3"] || [deviceString isEqualToString:@"iPad6,4"])    return @"iPad Pro iPad 9.7-inch";
    if ([deviceString isEqualToString:@"iPad6,11"] || [deviceString isEqualToString:@"iPad6,12"])    return @"iPad 5";
    if ([deviceString isEqualToString:@"iPad7,1"] || [deviceString isEqualToString:@"iPad7,2"])    return @"iPad Pro 12.9-inch 2";
    if ([deviceString isEqualToString:@"iPad7,3"] || [deviceString isEqualToString:@"iPad7,4"])    return @"iPad Pro 10.5-inch";

    //----------------iPad mini------------------------
    if ([deviceString isEqualToString:@"iPad2,5"] || [deviceString isEqualToString:@"iPad2,6"] || [deviceString isEqualToString:@"iPad2,7"])    return @"iPad mini";
    if ([deviceString isEqualToString:@"iPad4,4"] || [deviceString isEqualToString:@"iPad4,5"] || [deviceString isEqualToString:@"iPad4,6"])    return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"] || [deviceString isEqualToString:@"iPad4,8"] || [deviceString isEqualToString:@"iPad4,9"])    return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"] || [deviceString isEqualToString:@"iPad5,2"])    return @"iPad mini 4";

    if ([deviceString isEqualToString:@"iPad4,1"])    return @"ipad air";
    
    return @"iphone";
}


#pragma mark
#pragma mark - 格式化数字如果为整数显示整数，不是整数显示两位小数

+ (NSString *)showFloat:(float)num {
    NSString *result = nil;
    NSMutableString *numStr = [NSMutableString stringWithFormat:@"%f", num];
    NSRange dotRange = [numStr rangeOfString:@"."];
    if (dotRange.length != 0) {
        result = [NSString stringWithFormat:@"%.2f", num];
    }
    return result;
}

#pragma mark
#pragma mark - 格式化时间

+ (NSString*)convertDateTime:(NSNumber*)timestamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp longValue]];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeString = [formatter stringFromDate:date];
    
    return timeString;
}

+ (NSString*)convertDate:(NSNumber*)timestamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp longValue]];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-M-d"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString*)convertDate:(NSNumber*)timestamp formatString:(NSString*)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];

    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp longValue]];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}



/**
 *  处理图片
 */

#pragma mark
#pragma mark - 压缩图片
+ (UIImage *)handlePicWith:(UIImage *)image WithMaxSize:(CGSize)size andPercent:(CGFloat)percent
{
    CGFloat width;
    CGFloat height;
    
    if (image.imageOrientation == 3 || image.imageOrientation == 2) {
        width = CGImageGetHeight(image.CGImage);
        height = CGImageGetWidth(image.CGImage);
    } else {
        width = CGImageGetWidth(image.CGImage);
        height = CGImageGetHeight(image.CGImage);
    }
    //    CGFloat scale = width/height;
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = 1;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    //    int xPos = (size.width - width)/2;
    //    int yPos = (size.height-height)/2;
    int xPos = 0;
    int yPos = 0;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(xPos, yPos, width+1, height+2)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    
    NSData *imageData = UIImageJPEGRepresentation(scaledImage, percent);
    
    return [UIImage imageWithData:imageData];
    
}

#pragma mark
#pragma mark - image定高，等比放大然后多余部分切掉

+ (UIImage *)expendPicWith:(UIImage *)image withHeight:(CGFloat)height
{
    CGFloat width = image.size.width/image.size.height*height;
    //    int xPos = (size.width - width)/2;
    //    int yPos = (size.height-height)/2;
    int xPos = 0;
    int yPos = 0;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(xPos, yPos, width, height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

#pragma mark
#pragma mark - 计算字符串的大小

+ (CGSize)calculateStringSizeWithString:(NSString *)string andFontNum:(CGFloat)fontNum andSize:(CGSize)size {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontNum]};
    
    CGSize retSize = [string boundingRectWithSize:size
                                          options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    
    
    return retSize;
}

+ (CGSize)calculateSingleStringSizeWithString:(NSString *)string andFont:(UIFont *)font {
    return [string sizeWithAttributes:@{NSFontAttributeName:font}];
}

+ (UIButton*)createButtonFrame: (CGRect)frame Target: target BgColor: (UIColor*)bgColor Title: (NSString*)title TitleColor: (UIColor*)titleColor BgImg: (UIImage*)bgImg action: (SEL)action font: (float)font Tag: (int)tag {
    
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage: bgImg forState: UIControlStateNormal];
    [button setTitleColor: titleColor forState: UIControlStateNormal];
    [button setTitle: title forState: UIControlStateNormal];
    [button addTarget: target action: action forControlEvents:UIControlEventTouchUpInside];
    //没有字体默认为0即可
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    button.tag = tag;
    
    if (!bgColor) {
        button.backgroundColor = [UIColor clearColor];
    } else {
        button.backgroundColor = bgColor;
    }
    
    return button;
}

+ (UIButton*)createTouchButtonFrame: (CGRect)frame Target: target BgColor: (UIColor*)bgColor Title: (NSString*)title TitleColor: (UIColor*)titleColor BgImg: (UIImage*)bgImg Img: (UIImage*)img action: (SEL)action Tag: (int)tag {
    
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage: bgImg forState: UIControlStateNormal];
    [button setBackgroundImage: img forState: UIControlStateHighlighted];
    [button setTitleColor: titleColor forState: UIControlStateNormal];
    [button setTitle: title forState: UIControlStateNormal];
    [button addTarget: target action: action forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    if (!bgColor) {
        button.backgroundColor = [UIColor clearColor];
    } else {
        button.backgroundColor = bgColor;
    }
    
    return button;
}

+ (UILabel*)createLabelFrame: (CGRect)frame BgColor: (UIColor*)bgColor Text: (NSString*)text textColor: (UIColor*)textColor Font: (UIFont*)font TextAlignment: (NSTextAlignment)textAlignment Tag: (int)tag {
    
    UILabel *label = [[UILabel alloc] initWithFrame: frame];
    label.textAlignment = textAlignment;
    
    if (!bgColor) {
        label.backgroundColor = [UIColor clearColor];
    } else {
        label.backgroundColor = bgColor;
    }
    
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    label.tag = tag;
    
    return label;
}

+ (UIImageView*)createImageViewFrame: (CGRect)frame BgColor: (UIColor*)bgColor Img: (UIImage*)img Tag: (int)tag {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: frame];
    if (!bgColor) {
        imageView.backgroundColor = [UIColor clearColor];
    } else {
        imageView.backgroundColor = bgColor;
    }
    
    imageView.image = img;
    
    return imageView;
}

+ (UIColor*)setColorWithInt: (int)newColor {
    int r = (newColor >> 16) & 0xff;
    int g = (newColor >> 8) & 0xff;
    int b = newColor & 0xff;
    int a = (newColor >> 24) & 0xff;
    if (a == 0) {
        a = 0xff;
    }
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

//以iPhone5为基础
+ (CGFloat)setWidthPX:(CGFloat)px{
    
    return (px/2*APPWidth)/320;
    
}
+ (CGFloat)setHeightPX:(CGFloat)px{
    
    return (px/2*APPHeight)/568;
}

+ (NSString*)filePathForDocument:(NSString*)fileName {
    return [self filePathForDocument:fileName folerId:@"Information"];
}
+ (NSString*)filePathForDocument:(NSString*)fileName folerId:(NSString*)folderId {
    NSString *archiveDirPath = [NSHomeDirectory() stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"/Documents/%@", folderId]];
    
    NSError* error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:archiveDirPath]) {
        
        if (![[NSFileManager defaultManager] createDirectoryAtPath:archiveDirPath
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory tmp/cachedModels directory error: %@", error);
            return nil;
        }
    }
    
    NSString *archivePath = [archiveDirPath stringByAppendingFormat:@"/%@", fileName];
    return archivePath;
}

+ (void)removeFileAtPathForDocument:(NSString *)filePath {
    NSError *error = nil;
    if ([self filePathForDocument: filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:[self filePathForDocument:filePath] error:&error];
        
        if (error) {
            NSLog(@"移除文件失败，错误信息：%@", error);
        }
        else {
            NSLog(@"成功移除文件");
        }
    }
    else {
        NSLog(@"文件不存在");
    }
}

#pragma mark
#pragma mark - 写入

NSString* getArchivePathForId(NSString* modelId) {
    NSString *archiveDirPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/cachedModels/"];
    
    NSError* error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:archiveDirPath]) {
        
        if (![[NSFileManager defaultManager] createDirectoryAtPath:archiveDirPath
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory tmp/cachedModels directory error: %@", error);
            return nil;
        }
    }
    
    NSString *archivePath = [archiveDirPath stringByAppendingFormat:@"/%@", modelId];
    return archivePath;
}

+ (BOOL) persistModel:(id<NSCoding>)model withId:(NSString*)modelId {//写入
    if (modelId)
        return [NSKeyedArchiver archiveRootObject:model toFile:getArchivePathForId(modelId)];
    else
        return NO;
}

#pragma mark
#pragma mark - 读取

+ (id<NSCoding>)cachedModelWithId:(NSString*)modelId {//读取
    if (modelId)
        return [NSKeyedUnarchiver unarchiveObjectWithFile:getArchivePathForId(modelId)];
    else
        return nil;
}

+ (void)removeModelWithId:(NSString*)modelId {//删除
    
    NSError *error = nil;
    if (getArchivePathForId(modelId)) {
        [[NSFileManager defaultManager] removeItemAtPath:getArchivePathForId(modelId) error:&error];
        
        if (error) {
            NSLog(@"移除文件失败，错误信息：%@", error);
        }
        else {
            NSLog(@"成功移除文件");
        }
    }
    else {
        NSLog(@"文件不存在");
    }
}

+(NSMutableArray *)localFile:(NSString*)folder {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:folder];
    NSString *fileName;
    NSMutableArray *R = [NSMutableArray array];
    
    while (fileName = [dirEnum nextObject]) {
        [R addObject:fileName];
    }
    return R;
}

+ (void)showAlertView:(UIViewController*)vc title:(NSString*)title message:(NSString*)msg okAction:(NSString*)ok cancelAction:(NSString*)cancel okHandler:(void (^ __nullable)(UIAlertAction *action))okHandler cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    if (ok && ![ok isEmptyStr]) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok style:UIAlertActionStyleDefault handler:okHandler];
        [alertController addAction:okAction];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:cancelHandler];
    [alertController addAction:cancelAction];
    [vc presentViewController:alertController animated:YES completion:nil];
    
}

+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor*)fromColor toColor:(UIColor *)toColor{
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}

+ (CAGradientLayer *)setHorizontalChangingColor:(UIView *)view fromColor:(UIColor*)fromColor toColor:(UIColor *)toColor{
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    //(0,0)(0,0)不渐变   (0,0)(0,1)竖直上到下 (0,0)(1,0)左到右 (0,0)(1,1)左上到右下
    //(1,0)(0,0)水平从左到右 (1,0)(0,1)右上到左下 (1,0)(1,0)无 (1,0)(1,1)上到下
    //(0,1)(0,0)下到上  (0,1)(0,1)无 (0,1)(1,0)左下到右上 (0,1)(1,1)左到右
    //(1,1)(0,0)左上到右下  (1,1)(0,1) (1,1)(1,0) (1,1)(1,1)
    gradientLayer.startPoint = CGPointMake(1, 0);
    gradientLayer.endPoint = CGPointMake(0, 0);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}

+ (CAGradientLayer *)setCorNerChangingColor:(UIView *)view fromColor:(UIColor*)fromColor toColor:(UIColor *)toColor{
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    //(0,0)(0,0)不渐变   (0,0)(0,1)竖直上到下 (0,0)(1,0)左到右 (0,0)(1,1)左上到右下
    //(1,0)(0,0)水平从左到右 (1,0)(0,1)右上到左下 (1,0)(1,0)无 (1,0)(1,1)上到下
    //(0,1)(0,0)下到上  (0,1)(0,1)无 (0,1)(1,0)左下到右上 (0,1)(1,1)左到右
    //(1,1)(0,0)左上到右下  (1,1)(0,1) (1,1)(1,0) (1,1)(1,1)
    gradientLayer.startPoint = CGPointMake(1, 1);
    gradientLayer.endPoint = CGPointMake(0, 0);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}

+ (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

+ (NSMutableAttributedString*)attributeStrWithStr:(NSString*)str withBeforFont:(UIFont*)font afterFont:(UIFont*)afterFont {
    if (str) {
        NSMutableAttributedString* attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [str length]-1)];
        [attributeStr addAttribute:NSFontAttributeName value:afterFont range:NSMakeRange([str length]-1, 1)];
        return attributeStr;
    }
    return nil;
}

+ (BOOL)isToday:(NSString*)timestamp {
    NSString* time = [Util convertDate:[NSNumber numberWithLong:timestamp.longLongValue] formatString:@"yyyy-MM-dd" ];
    NSString* today = [self getCurrentDate];
    if ([time isEqualToString:today]) {
        return YES;
    }
    return NO;
}

+ (NSString *)getCurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

+ (NSString*)timeFormat:(NSString*)timestamp {
    NSInteger intevalTime = [[NSDate date] timeIntervalSince1970] - [timestamp longLongValue];
    NSInteger hours = intevalTime / 60 / 60;
    if (hours >= 24) {
        return [NSString stringWithFormat:@"%ld天", hours / 24];
    } else if (hours > 0) {
        return [NSString stringWithFormat:@"%ld小时", hours];
    } else {
        return [NSString stringWithFormat:@"%ld分钟", intevalTime/60];
    }
}

+ (NSString*)dateFormat:(NSString*)timestamp {
    NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *yesterday = [formatter stringFromDate:yesterdayDate];
    NSString* dateStr = [Util convertDate:[NSNumber numberWithLong:timestamp.longLongValue] formatString:@"yyyy-MM-dd"];
    
    NSDate *tomorrowData = [NSDate dateWithTimeIntervalSinceNow:+(24*60*60)];
    NSString* tomorrow = [formatter stringFromDate:tomorrowData];
    
    if ([dateStr isEqualToString:[self getCurrentDate]]) {
        return @"今天";
    } else if ([dateStr isEqualToString:yesterday]) {
        return @"昨天";
    } else if ([dateStr isEqualToString:tomorrow]) {
        return @"明天";
    } else {
        return [Util convertDate:[NSNumber numberWithLong:[timestamp longLongValue]] formatString:@"yyyy-MM-dd"];
    }
}

+ (NSArray*)jsonArrayWithStr:(NSString*)str {
    NSError* error = nil;
    NSMutableArray* array = [NSMutableArray array];
    id object = [[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                                 options:NSJSONReadingAllowFragments
                                                   error:&error] mutableCopy];
    if ([object isKindOfClass:[NSArray class]]) {
        [array addObjectsFromArray:object];
    } else if ([object isKindOfClass:[NSString class]]){
        [array addObject:object];
    }
    return array;
}

+ (NSString*)jsonStrWithArray:(NSArray*)array {
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


+(NSString*)getStringFromConfig:(NSString*)str {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"CommonStrConfig" ofType:@"plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:path];
    return [dic stringWithKey:str];
}

+ (UIFont*)fontWithName:(NSString*)name size:(CGFloat)fontSize {
    UIFont* font = [UIFont fontWithName:name size:fontSize];
    if (font) {
        return font;
    } else {
        return [UIFont systemFontOfSize:fontSize];
    }
}

+ (void)getBtnAuthFromServer {
    //    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    //    [params setObject:[YLUserDataManager getAid] forKey:@"aid"];
    //    [[YLHttpRequest sharedInstance] sendRequest:YL_API_GET_BTN_AUTH params:params success:^(NSDictionary *dic) {
    //        [[NSUserDefaults standardUserDefaults] setObject:[dic arrayWithKey:@"data"] forKey:kBUTTON_AUTH];
    //    } requestFailure:^(NSDictionary *dic) {
    //
    //    } failure:^(NSError *error) {
    //
    //    }];
}


+ (BOOL)checkLocation {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString*)getUrlSchemes {
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
