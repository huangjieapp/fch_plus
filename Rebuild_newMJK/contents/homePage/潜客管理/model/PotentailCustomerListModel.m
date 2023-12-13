//
//  PotentailCustomerListModel.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "PotentailCustomerListModel.h"

@implementation PotentailCustomerListModel

//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
    
    return @{@"content":PotentailCustomerListDetailModel.class}
    ;
    
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"content": @"PotentailCustomerListDetailModel"};
}




@end
