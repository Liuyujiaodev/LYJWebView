//
//  YLContactPhoneUtil.m
//  YLClient
//
//  Created by 刘玉娇 on 2018/1/25.
//  Copyright © 2018年 yunli. All rights reserved.
//

#import "YWAuthUtil.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <CoreTelephony/CTCellularData.h>
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define iSiOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)

@implementation YWAuthUtil

#pragma mark -
#pragma mark 拿到本地通讯录

+ (BOOL)isGetContactAuth {
    if (iSiOS9) {
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            return NO;
        }
        return YES;
    } else {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            return NO;
        }
        return YES;
    }
}

+ (void)reqeustAuth:(void (^)(BOOL granted))completionHandler{
    if (iSiOS9) {
        CNContactStore* store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            completionHandler(granted);
        }];
    } else {
        ABAddressBookRef bookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
            completionHandler(granted);
        });
    }
}

+ (YLAuthUtilStatus)getContactStatus {
    if (iSiOS9) {
        CNContactStore* store = [[CNContactStore alloc] init];
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusRestricted || [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusDenied) {
            return YLAuthUtilStatusDefined;
        } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
            return YLAuthUtilStatusAuthed;
        } else {
            return YLAuthUtilStatusNotDetermined;
        }
    } else {
        __block BOOL authorizedToAccess = NO;
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            return YLAuthUtilStatusAuthed;
        } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            return YLAuthUtilStatusNotDetermined;
        }
        else  {
            return YLAuthUtilStatusDefined;
        }
    }
}

+ (void)sendContactSuccess:(sendContactSuccess)success failure:(sendContactFailure)failure {
    NSMutableArray* localContactItems = [NSMutableArray array];

    if (iSiOS9) {
        CNContactStore* store = [[CNContactStore alloc] init];
        CNContactFetchRequest * request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]];
        [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            NSString* firstName = contact.givenName;
            NSString* lastName = contact.familyName;
            NSArray* phoneNumbers = contact.phoneNumbers;
            for (CNLabeledValue *labeledValue in phoneNumbers) {
                // 2.1.获取电话号码的KEY
                NSString *tag = [self tagStr:labeledValue.label];
                // 2.2.获取电话号码
                CNPhoneNumber *mobile = labeledValue.value;
                NSString *phoneNumber = mobile.stringValue;
                
                NSString* name = [NSString stringWithFormat:@"%@%@", lastName, firstName];
                
                NSDictionary* itemDic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"displayName", phoneNumber, @"iphone", tag, @"tagLabel", nil];
                [localContactItems addObject:itemDic];
            }
        }];
    } else {
        ABAddressBookRef bookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        CFArrayRef allContactsRef = ABAddressBookCopyArrayOfAllPeople(bookRef);
        for (int i = 0; i < CFArrayGetCount(allContactsRef); i++) {
            ABRecordRef contact = CFArrayGetValueAtIndex(allContactsRef, i);
            
            CFTypeRef firstNameRef = ABRecordCopyValue(contact, kABPersonFirstNameProperty);
            CFTypeRef lastNameRef = ABRecordCopyValue(contact, kABPersonLastNameProperty);
            CFTypeRef companyRef = ABRecordCopyValue(contact, kABPersonOrganizationProperty);
            
            NSString* firstName = (firstNameRef == nil) ? @"" : (__bridge NSString*)firstNameRef;
            NSString* lastName = (lastNameRef == nil) ? @"" : (__bridge NSString*)lastNameRef;
            NSString* companyName = (companyRef == nil) ? @"" :(__bridge NSString*)companyRef;
            
            ABMutableMultiValueRef multIPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            multIPhone = ABRecordCopyValue(contact, kABPersonPhoneProperty);
            
            NSMutableSet* iphones = [NSMutableSet set];
            for (int j = 0; j < ABMultiValueGetCount(multIPhone); j++) {
                CFStringRef numberRef = ABMultiValueCopyValueAtIndex(multIPhone, j);
                CFStringRef label = ABMultiValueCopyLabelAtIndex(multIPhone, j);
                
                NSString *moblie = [NSString stringWithFormat:@"%@", numberRef];
                NSString *tagLabel = [NSString stringWithFormat:@"%@", label];

                [iphones addObject:[NSDictionary dictionaryWithObjectsAndKeys:moblie,@"phone",tagLabel,@"tagLabel", nil]];
            }
            
            if ([iphones count] == 0)
                continue;
            
            for (NSDictionary* iphoneDic in iphones) {
                NSString* iphone = [iphoneDic objectForKey:@"phone"];
                NSString* tag = [self tagStr:[iphoneDic objectForKey:@"tagLabel"]];

                NSString* phoneNumber = [[[iphone stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" (" withString:@""] stringByReplacingOccurrencesOfString:@") " withString:@""];
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
                
                NSString* name = [NSString stringWithFormat:@"%@%@", lastName, firstName];
                if ([name isEqualToString:@""]) {
                    if ([companyName isEqualToString:@""]) {
                        name = phoneNumber;
                    } else if (![companyName isEqualToString:@""]) {
                        name = companyName;
                    }
                }
                NSDictionary* itemDic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"displayName", phoneNumber, @"iphone", tag, @"tagLabel", nil];
                [localContactItems addObject:itemDic];
            }
        }
    }
    success(localContactItems);
}

+(NSString*)tagStr:(NSString*)tag {
    if ([tag containsString:@"HomeFAX"]) {
        return @"家庭传真";
    }
    
    if ([tag containsString:@"WorkFAX"]) {
        return @"工作传真";
    }

    if ([tag containsString:@"Work"]) {
        return @"工作";
    }
    
    if ([tag containsString:@"Home"]) {
        return @"家庭";
    }
    
    if ([tag containsString:@"iPhone"]) {
        return @"iPhone";
    }
    if ([tag containsString:@"Mobile"]) {
        return @"手机";
    }
    
    if ([tag containsString:@"Main"]) {
        return @"主要";
    }

    if ([tag containsString:@"Pager"]) {
        return @"传呼机";
    }
    if ([tag containsString:@"Other"]) {
        return @"其他";
    }
    
    return @"其他";
}

#pragma mark - 定位权限
//-------定位权限----------------
+ (void)requestLocationAuth {
    CLLocationManager* locationMag = [[CLLocationManager alloc] init];
    [locationMag requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
}

+ (YLAuthLocationStatus)getLocationStatus {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        return YLAuthLocationStatusNotDetermined;
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return YLAuthLocationStatusDefined;

    } else {
        return YLAuthLocationStatusAuthed;
    }
}

+(void)isNetDefine:(void (^)(BOOL granted))complete {
    if (@available(iOS 9.0, *)) {
        CTCellularData *cellularData = [[CTCellularData alloc] init];
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
            if (state == kCTCellularDataRestricted) {
                complete(YES);
            } else {
                complete(NO);
            }
        };
    }
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
@end
