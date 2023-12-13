//
//  NSString+Extern.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/6.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extern)
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidTelNumber;
- (BOOL)isValid;//只能输入字母
+ (NSString *)iphoneType;//手机型号
@end
