//
//  CustomerDetailPathModel.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/22.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CustomerDetailPathModel.h"

@implementation CustomerDetailPathModel

+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
    
    return @{@"content":CustomerDetailPathDetailModel.class, @"list" :CustomerDetailPathDetailModel.class};
    
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":@"CustomerDetailPathDetailModel",@"list":@"CustomerDetailPathDetailModel"};
}

@end
