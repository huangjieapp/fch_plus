//
//  ServiceOrderModel.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/31.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ServiceOrderModel.h"

@implementation ServiceOrderModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"content" : [ServiceOrderSubModel class]};
}

@end
