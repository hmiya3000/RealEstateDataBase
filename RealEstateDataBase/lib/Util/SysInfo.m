//
//  SysInfo.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/11/08.
//  Copyright © 2015年 Beetre. All rights reserved.
//

#import "SysInfo.h"
#include <sys/utsname.h>
#import  <UIKit/UIKit.h>

@implementation SysInfo

/****************************************************************
 * 指定した列の行番号を設定する
 ****************************************************************/
+(NSString*)systemVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 CDMA";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5(GSM)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5(GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C(GSM)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5C(GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S(GSM)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S(GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6";    //?
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 WiFi";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 GSM";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 CDMA";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 CDMAS";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini Wifi";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini (Wi-Fi + Cellular)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini (Wi-Fi + Cellular MM)";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 WiFi";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 CDMA";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 GSM";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 Wifi";
    if ([platform isEqualToString:@"i386"])      return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"Simulator";
    return @"Unknown";
}
/****************************************************************/
+ (NSString *)iOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}
/****************************************************************/
@end
/****************************************************************/


