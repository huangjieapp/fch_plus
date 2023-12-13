//
//  CGCVerificationDetailModel.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/7/17.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "CGCVerificationDetailModel.h"

@implementation CGCVerificationDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"sid" : @"id"
             };
}

- (void)setProduct_price:(NSString *)product_price{
    
    if (product_price.length==0) {
        product_price=@"0";
    }
    _product_price=product_price;
    
}

- (void)setProduct_name:(NSString *)product_name{
    
    if (product_name.length==0) {
        product_name=@" ";
    }
    _product_name=product_name;
    
}
- (void)setProduct_remark:(NSString *)product_remark{
    
    if (product_remark.length==0) {
        product_remark=@" ";
    }
    _product_remark=product_remark;
    
}

- (void)setTake_code:(NSString *)take_code{
    
    if (take_code.length==0) {
        take_code=@"0";
    }
    _take_code=take_code;
    
}
- (void)setProduct_point:(NSString *)product_point{
    
    if (product_point.length==0) {
        product_point=@"0";
    }
    _product_point=product_point;
    
}

@end
