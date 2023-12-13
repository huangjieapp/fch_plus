//
//  CGCOrderModel.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/7.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCOrderModel.h"
#import "CGCOrderDetailModel.h"


@implementation CGCOrderModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [CGCOrderDetailModel class]
             
             };
}

@end
