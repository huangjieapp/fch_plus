//
//  MJKAdditionalInfoModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/9/29.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKAdditionalInfoModel.h"

@implementation MJKAdditionalInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"C_C_ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"children": @"MJKAdditionalInfoModel"};
}
@end
