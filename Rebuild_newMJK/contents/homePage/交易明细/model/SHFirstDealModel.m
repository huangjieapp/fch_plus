//
//  SHFirstDealModel.m
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/15.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import "SHFirstDealModel.h"

@implementation SHFirstDealModel

//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
    
    return @{@"content":SHFirstDealSubModel.class}
    ;
    
}




@end
