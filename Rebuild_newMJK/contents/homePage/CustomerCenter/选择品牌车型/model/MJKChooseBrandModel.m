//
//  MJKChooseBrandModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/12/31.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKChooseBrandModel.h"
#import "MJKChooseBrandSubModel.h"

@implementation MJKChooseBrandModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"array" : @"MJKChooseBrandSubModel",@"list" : @"MJKChooseBrandSubModel"};
}
@end
