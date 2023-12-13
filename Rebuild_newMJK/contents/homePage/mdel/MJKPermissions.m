//
//  MJKPermissions.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKPermissions.h"

@implementation MJKPermissions
+ (BOOL)getPermissions:(NSString *)str {
    NSArray *arr = [NewUserSession instance].appcode;
    if (![arr containsObject:str]) {
        return NO;
    }
    return YES;
}
@end
