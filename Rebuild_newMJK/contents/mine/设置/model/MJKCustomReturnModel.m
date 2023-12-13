//
//  MJKCustomReturnModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKCustomReturnModel.h"
#import "MJKCustomReturnSubModel.h"

@implementation MJKCustomReturnModel
//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
    return @{@"content":MJKCustomReturnSubModel.class, @"list":MJKCustomReturnSubModel.class}
	;
}
@end
