//
//  MJKReimbursementCategoryModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/19.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKReimbursementCategoryModel.h"

@implementation MJKReimbursementCategoryModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"objectId" : @"id"};
}
@end
