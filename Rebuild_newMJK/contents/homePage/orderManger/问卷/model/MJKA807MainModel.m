//
//  MJKA809MainModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/8.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKA807MainModel.h"

#import "MJKA808PojoListModel.h"
#import "MJKA810PojoListModel.h"

@implementation MJKA807MainModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"a808PojoList" : @"MJKA808PojoListModel",
             @"a810PojoList" : @"MJKA810PojoListModel"
    };
}

@end
