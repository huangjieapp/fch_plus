//
//  CGCExpandLabelModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/15.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "CGCExpandLabelModel.h"

#import "CGCExpandLabeSublModel.h"

@implementation CGCExpandLabelModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"labelId" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"content" : @"CGCExpandLabeSublModel"};
}
@end
