//
//  MJKMarketModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKMarketModel.h"
#import "MJKMarketSubModel.h"

@implementation MJKMarketModel

//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":MJKMarketSubModel.class}
	;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"content" : @"MJKMarketSubModel"};
}
@end
