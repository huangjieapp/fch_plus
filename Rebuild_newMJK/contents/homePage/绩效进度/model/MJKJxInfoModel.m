//
//  MJKJxInfoModel.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/10.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKJxInfoModel.h"

@implementation MJKJxInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"C_ID": @"id"};
}

+(NSDictionary *)mj_objectClassInArray {
    return @{@"children": @"MJKJxInfoModel"};
}
@end
