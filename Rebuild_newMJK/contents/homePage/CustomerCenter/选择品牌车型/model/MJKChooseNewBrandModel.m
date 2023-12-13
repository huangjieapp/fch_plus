//
//  MJKChooseBrandModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/12/31.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKChooseNewBrandModel.h"
#import "MJKChooseNewBrandSubModel.h"

@implementation MJKChooseNewBrandModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : @"MJKChooseNewBrandSubModel"};
}
@end
