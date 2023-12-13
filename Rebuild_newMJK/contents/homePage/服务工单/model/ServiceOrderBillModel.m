//
//  ServiceOrderBillModel.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/11/2.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ServiceOrderBillModel.h"

@implementation ServiceOrderBillModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pjContent" : [ProductInfoModel class],
             @"qtContent" : [ProductInfoModel class]};
}

@end
