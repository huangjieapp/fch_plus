//
//  CustomerDetailInfoModel.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/21.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CustomerDetailInfoModel.h"
#import "VideoAndImageModel.h"

@implementation CustomerDetailInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"fileList":@"VideoAndImageModel"};
}

//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
    
    return @{@"labelsList":CustomLabelModel.class,
             @"fileList":VideoAndImageModel.class
    }
    ;
    
}

@end
