//
//  NSString+Extern.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/6.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "NSString+Extern.h"
#import <sys/utsname.h>

@implementation NSString (Extern)
- (BOOL)isValidPhoneNumber {
	return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"1[34578][0-9]{9}"] evaluateWithObject:self];
}

- (BOOL)isValidTelNumber {
	return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(0[0-9]{2,3}\\-?)?([2-9][0-9]{6,7})$"] evaluateWithObject:self];
}

- (BOOL)isNoDot {
	return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"/,/g,''"] evaluateWithObject:self];
	
}

- (BOOL)isValid {
	NSString *emailRegex = @"[A-Z0-9a-z-]";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:self];
}

+ (NSString *)iphoneType {
	
	//需要导入头文件：#import <sys/utsname.h>
	
	struct utsname systemInfo;
	
	uname(&systemInfo);
	
	NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
	
	if([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
	
	if([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
	
	if([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
	
	if([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
	
	if([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
	
	if([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
	
	if([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
	
	if([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
	
	if([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
	
	if([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
	
	if([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
	
	if([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
	
	if([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
	
	if([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
	
	if([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
	
	if([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
	
	if([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
	
	if([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
	
	if([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
	
	if([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
	
	if([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
	
	if([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
	
	if([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
	
	if([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
	
	if([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
	
	if([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
	
	if([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
	
	if([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
	
	if([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
	
	if([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
	
	if([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
	
	if([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
	
	if([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
	
	if([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
	
	if([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
	
	if([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
	
	if([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
	
	if([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
	
	if([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
	
	if([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
	
	if([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
	
	if([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
	
	if([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
	
	if([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
	
	if([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
	
	if([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
	
	if([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
	
	if([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
	
	if([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
	
	if([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
	
	if([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
	
	if([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
	
	if([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
	
	if([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
	
	if([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
	
	if([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
	
	if([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
	
	if([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
	
	if([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
	
	if([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
	
	if([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
	
	if([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
	
	if([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
	
	if([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
	
	return platform;
	
}

+(BOOL)isEmpty:(NSString*)text{
if ([text isEqual:[NSNull null]]) {
return YES;
}
else if ([text isKindOfClass:[NSNull class]])
{
return YES;
}
else if (text == nil){
return YES;
}
return NO;
}

@end
