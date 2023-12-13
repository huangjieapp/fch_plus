//
//  MJKCarSourceModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/16.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCarSourceModel.h"

#import "MJKCarSourceSubModel.h"

@implementation MJKCarSourceModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"content" : @"MJKCarSourceSubModel"};
}
@end
