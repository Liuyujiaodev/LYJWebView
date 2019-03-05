//
//  CommonUtil.m
//  YLClient
//
//  Created by 娇 on 2019/2/18.
//  Copyright © 2019年 yunli. All rights reserved.
//

#import "CommonUtil.h"
#include <mach/mach_host.h>
#import <sys/utsname.h>
#include <sys/sysctl.h>
#include <sys/param.h>
#import <mach/mach.h>
#include <sys/mount.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#import <UIKit/UIKit.h>

#define YMBCURRENT_DEVICE_ID [[UIDevice currentDevice] identifierForVendor].UUIDString

@implementation CommonUtil

+ (NSString *)getHardParam  // 返回CPU类型
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
   
    NSArray* ARM1176JZArray = @[@"iPhone1,1", @"iPhone1,2", @"iPod1,1", @"iPod2,1"];
    if ([ARM1176JZArray containsObject:deviceString]) {
        return @"ARM1176JZ(F)-S v1.0";
    }
    
    NSArray* CortexA8Array = @[@"iPhone2,1", @"iPod3,1", @"iPad1,1", @"iPhone3,1", @"iPhone3,2", @"iPhone3,3", @"iPod4,1"];
    if ([CortexA8Array containsObject:deviceString]) {
        return @"ARM Cortex-A8";
    }
    
    NSArray* CortexA9Array = @[@"iPad2,1", @"iPad2,2", @"iPad2,3", @"iPhone4,1", @"iPad 3,1", @"iPad 3,2", @"iPad 3,3", @"iPhone5,1", @"iPhone5,2", @"iPod5,1", @"iPad3,4", @"iPad3,5", @"iPad3,6", @"iPad2,5", @"iPad2,6", @"iPad2,7", @"iPhone5,3", @"iPhone5,4"];
    if ([CortexA9Array containsObject:deviceString]) {
        return @"ARM Cortex-A9";
    }
    
    NSArray* CycloneArray = @[@"iPhone6,1", @"iPhone6,2", @"iPhone6,3", @"iPad4,1", @"iPad4,2", @"iPad4,3", @"iPad4,4", @"iPad4,5", @"iPad4,6", @"iPad4,7", @"iPad4,8", @"iPad4,9"];
    if ([CycloneArray containsObject:deviceString]) {
        return @"Cyclone";
    }
    NSArray* TyphoonArray = @[@"iPhone7,2", @"iPhone7,1", @"iPad5,3", @"iPad5,4",@"iPod7,1", @"iPad5,1", @"iPad5,2"];
    if ([TyphoonArray containsObject:deviceString]) {
        return @"Typhoon";
    }
    
    NSArray* TwisterArray = @[@"iPad6,7", @"iPad6,8", @"iPhone8,1", @"iPhone8,2", @"iPhone8,3", @"iPhone8,4", @"iPad6,3", @"iPad6,4", @"iPad6,11", @"iPad6,12"];
    if ([TwisterArray containsObject:deviceString]) {
        return @"Twister";
    }
    NSArray* HZArray = @[@"iPhone9,1", @"iPhone9,2", @"iPhone9,3", @"iPhone9,4", @"iPhone9,5", @"iPhone9,6", @"iPad7,4"];
    if ([HZArray containsObject:deviceString]) {
        return @"Hurricane (x2) + Zephyr (x2)";
    }
    
    NSArray* MMArray = @[@"iPhone10,1", @"iPhone10,2", @"iPhone10,3", @"iPhone10,4", @"iPhone10,5", @"iPhone10,6"];
    if ([MMArray containsObject:deviceString]) {
        return @"Monsoon (x2) + Mistral (x4)";
    }
    
    NSArray* VTArray = @[@"iPhone11,1", @"iPhone11,3", @"iPhone11,5", @"iPad8,1", @"iPad8,2", @"iPad8,5", @"iPad8,6", @"iPhone11,8", @"iPhone11,2", @"iPhone11,6"];
    if ([VTArray containsObject:deviceString]) {
        return @"Vortex (x4) + Tempest (x4)";
    }
    return @"Unknow";
//    NSString *cpu = [[NSString alloc] init];
//    size_t size;
//    cpu_type_t type;
//    cpu_subtype_t subtype;
//    size = sizeof(type);
//    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
//
//    size = sizeof(subtype);
//    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
//
//    // values for cputype and cpusubtype defined in mach/machine.h
//    if (type == CPU_TYPE_X86)
//    {
////        [cpu appendString:@"x86 "];
//        cpu = @"X86";
//        // check for subtype ...
//
//    } else if (type == CPU_TYPE_ARM)
//    {
//        cpu = @"ARM";
////        [cpu appendString:@"ARM"];
////        [cpu appendFormat:@",Type:%d",subtype];
//    } else if (type == CPU_TYPE_ARM64) {
//        cpu = @"ARM64";
//    } else if (type == CPU_TYPE_ARM64_32) {
//        cpu = @"ARM64_32";
//    } else if (type == CPU_TYPE_MC88000) {
//        cpu = @"MC88000";
//    } else if (type == CPU_TYPE_SPARC) {
//        cpu = @"SPARC";
//    } else if (type == CPU_TYPE_I860) {
//        cpu = @"I860";
//    }

//    return cpu;
//    size_t size;
//    sysctlbyname("hw.cputype", NULL, &size, NULL, 0);
//    char *machine = malloc(size);
//    sysctlbyname("hw.cputype", machine, &size, NULL, 0);
//    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
//    free(machine);
//    return [self sysInfo:HW_CPU_FREQ];
}

+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;// retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {// Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {// Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memoryfreeifaddrs(interfaces);
    return address;
    
}
 
+ (NSString*)getBatteryQuantity
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    float batteryLevel = [[UIDevice currentDevice] batteryLevel];
    [UIDevice currentDevice].batteryMonitoringEnabled = NO;
    return [NSString stringWithFormat:@"%d", (int)(batteryLevel*100)];
}

+ (BOOL)getBatteryStauts
{
    UIDevice *Device = [UIDevice currentDevice];
    // Set battery monitoring on
    Device.batteryMonitoringEnabled = YES;
    
    // Check the battery state
    if ([Device batteryState] == UIDeviceBatteryStateCharging || [Device batteryState] == UIDeviceBatteryStateFull) {
        // Device is charging
        return YES;
    } else {
        // Device is not charging
        return NO;
    }

}


// 获得设备总内存
+ (NSString*)getTotalMemorySize
{
    long total1 =  [NSProcessInfo processInfo].physicalMemory/1024/1024/1024;
    return [NSString stringWithFormat:@"%ldG",total1];
}

+ (long long)getAvailableMemorySize
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
}

//https://www.theiphonewiki.com/wiki/Models
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
    if ([deviceString isEqualToString:@"iPhone11,8"])    return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,6"])    return @"iPhone XS Max";
    
    
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
    if ([deviceString isEqualToString:@"iPad7,5"] || [deviceString isEqualToString:@"iPad7,6"]) return @"iPad (6th generation)";
    if ([deviceString isEqualToString:@"iPad8,1"] || [deviceString isEqualToString:@"iPad8,2"] || [deviceString isEqualToString:@"iPad8,3"] || [deviceString isEqualToString:@"iPad8,4"]) return @"iPad Pro (11-inch)";
    if ([deviceString isEqualToString:@"iPad8,5"] || [deviceString isEqualToString:@"iPad8,6"] || [deviceString isEqualToString:@"iPad8,7"] || [deviceString isEqualToString:@"iPad8,8"]) return @"iPad Pro (12.9-inch) (3rd generation)";
    //----------------iPad mini------------------------
    if ([deviceString isEqualToString:@"iPad2,5"] || [deviceString isEqualToString:@"iPad2,6"] || [deviceString isEqualToString:@"iPad2,7"])    return @"iPad mini";
    if ([deviceString isEqualToString:@"iPad4,4"] || [deviceString isEqualToString:@"iPad4,5"] || [deviceString isEqualToString:@"iPad4,6"])    return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"] || [deviceString isEqualToString:@"iPad4,8"] || [deviceString isEqualToString:@"iPad4,9"])    return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"] || [deviceString isEqualToString:@"iPad5,2"])    return @"iPad mini 4";
    
    if ([deviceString isEqualToString:@"iPad4,1"])    return @"ipad air";
    
    return @"iphone";
}

+(NSString*)getSystemVersion {
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    return phoneVersion;
}

//获取手机剩余空间
+ (NSString *) freeDiskSpaceInBytes{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0) {
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
        
    }
    return [NSString stringWithFormat:@"%0.2fG" ,(double)freespace/1024/1024/1024];
}

+ (NSString*) totalDiskSpace {
//    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
//    NSNumber *maxber = [fattributes objectForKey:NSFileSystemSize];
//    long long maxspace = [maxber longLongValue];
//
//    NSString * sizeStr = [NSString stringWithFormat:@"%0.2fG",(double)maxspace/1024/1024/1024];
    
    //总大小
    struct statfs buf;
    long long totalspace;
    totalspace = 0;
    if(statfs("/private/var", &buf) >= 0){
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    NSString * sizeStr = [NSString stringWithFormat:@"%0.2fG",(double)totalspace/1024/1024/1024];
    return sizeStr;
}

+(NSString *)getStartTime {
    NSProcessInfo *info = [NSProcessInfo processInfo];
    NSDate *now = [NSDate date];
    NSTimeInterval interval = [now timeIntervalSince1970];
    double timeStamp = interval - info.systemUptime;
    
    return [NSString stringWithFormat:@"%ld", (long)timeStamp];
}

+ (NSString*)getScreenSize {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat screenX = [[UIScreen mainScreen] bounds].size.width * scale;
    CGFloat screenY = [[UIScreen mainScreen] bounds].size.height * scale;
    return [NSString stringWithFormat:@"%d * %d", (int)screenX, (int)screenY];
}

+ (float)sysInfo:(uint)typeSpecifier{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    
    return (NSUInteger) results * 1.0;
}

+(NSString*)getiPhoneSize {
    NSString* size = @"Unkonw";
    NSString* deviceStr = [self getDeviceType];
    if ([deviceStr isEqualToString:@"iPhone 4"] || [deviceStr isEqualToString:@"iPhone 4S"]) return @"3.5inch";
    
    if ([deviceStr isEqualToString:@"iPhone 5"] || [deviceStr isEqualToString:@"iPhone 5c"] || [deviceStr isEqualToString:@"iPhone 5s"] || [deviceStr isEqualToString:@"iPhone SE"]) return @"4inch";
    
    if ([deviceStr isEqualToString:@"iphone 6"] || [deviceStr isEqualToString:@"iPhone 6s"] || [deviceStr isEqualToString:@"iPhone 7"] || [deviceStr isEqualToString:@"iPhone 8"]) return @"4.7inch";
    
    if ([deviceStr isEqualToString:@"iphone 6 Plus"] || [deviceStr isEqualToString:@"iPhone 6s Plus"] || [deviceStr isEqualToString:@"iPhone 7 Plus"] || [deviceStr isEqualToString:@"iPhone 8 Plus"]) return @"5.5inch";
    
    if ([deviceStr isEqualToString:@"iPhone X"] || [deviceStr isEqualToString:@"iPhone XS"]) return @"5.8inch";
    
    if ([deviceStr isEqualToString:@"iPhone XR"]) return @"6.1inch";
    if ([deviceStr isEqualToString:@"iPhone XS Max"]) return @"6.5inch";
    
    //--------------------ipad-------------------------
    if ([deviceStr isEqualToString:@"iPad"] || [deviceStr isEqualToString:@"iPad 2"] || [deviceStr isEqualToString:@"iPad 3"] || [deviceStr isEqualToString:@"iPad 4"] || [deviceStr isEqualToString:@"iPad Air"] || [deviceStr isEqualToString:@"iPad Air 2"] || [deviceStr isEqualToString:@"iPad Pro iPad 9.7-inch"] || [deviceStr isEqualToString:@"iPad 5"] || [deviceStr isEqualToString:@"iPad (6th generation)"] || [deviceStr isEqualToString:@"ipad air"]) return @"9.7inch";
    
    if ([deviceStr isEqualToString:@"iPad Pro 12.9-inch"] || [deviceStr isEqualToString:@"iPad Pro 12.9-inch 2"] || [deviceStr isEqualToString:@"iPad Pro (12.9-inch) (3rd generation)"]) return @"12.9inch";
    
    if ([deviceStr isEqualToString:@"iPad Pro 10.5-inch"]) return @"10.5inch";
    if ([deviceStr isEqualToString:@"iPad Pro (11-inch)"]) return @"11inch";
    
    if ([deviceStr isEqualToString:@"iPad mini"] || [deviceStr isEqualToString:@"iPad mini 2"] || [deviceStr isEqualToString:@"iPad mini 3"] || [deviceStr isEqualToString:@"iPad mini 4"]) return @"7.9inch";
    
    return size;
}

+ (NSDictionary*)Commondata {
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[self getHardParam] forKey:@"cpu"];
    [params setObject:[self getiPhoneSize] forKey:@"screenSize"];
    [params setObject:[self getScreenSize] forKey:@"resolutionRatio"];
    [params setObject:[NSNumber numberWithInt:[self getBatteryQuantity].intValue] forKey:@"batteryQuantity"];
    [params setObject:[self getBatteryStauts] ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0] forKey:@"batteryStatus"];
    [params setObject:YMBCURRENT_DEVICE_ID forKey:@"imei"];
    [params setObject:[self getDeviceType] forKey:@"deviceType"];
    [params setObject:[self getSystemVersion] forKey:@"systemVersion"];
    [params setObject:[self totalDiskSpace] forKey:@"deviceStorage"];
    [params setObject:[self freeDiskSpaceInBytes] forKey:@"surplusStorage"];
    [params setObject:[self getTotalMemorySize] forKey:@"memorySize"];
    [params setObject:[self getIPAddress] forKey:@"ipAddress"];
    [params setObject:@"iPhone" forKey:@"deviceBrand"];
    [params setObject:[self getStartTime] forKey:@"startTime"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"cuid"]) {
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"cuid"] forKey:@"cuid"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"address"]) {
        NSDictionary* dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
        [params setObject:[dic objectForKey:@"longitude"] forKey:@"longitude"];
        [params setObject:[dic objectForKey:@"latitude"] forKey:@"latitude"];
        [params setObject:[dic objectForKey:@"address"] forKey:@"address"];
        
    }
    return params;
}
@end


