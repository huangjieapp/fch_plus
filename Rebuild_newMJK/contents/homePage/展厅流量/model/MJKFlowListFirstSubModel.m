//
//  MJKFlowListFirstSubModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/7.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowListFirstSubModel.h"

@implementation MJKFlowListFirstSubModel
//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":MJKFlowListSecondSubModel.class}
	;
}
@end
