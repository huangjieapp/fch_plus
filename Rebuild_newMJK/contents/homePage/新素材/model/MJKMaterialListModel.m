//
//  MJKMaterialListModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/9/16.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import "MJKMaterialListModel.h"

@implementation MJKMaterialListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"cid" : @"id"};
}

@end
