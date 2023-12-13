//
//  CustomerPCModel.m
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import "CustomerPCModel.h"

@implementation CustomerPCSubModel

@end

@implementation CustomerPCModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"children": [CustomerPCSubModel class],
             @"child": [CustomerPCModel class]
    };
}
@end
