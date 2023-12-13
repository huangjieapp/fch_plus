//
//  ServiceTaskModel.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/27.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ServiceTaskModel.h"


@implementation ServiceTaskModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"content" : [ServiceTaskSubModel class]};
}


@end
