//
//  MJKFlowMeterModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/9.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowMeterModel.h"
#import "MJKFlowMeterSubModel.h"

@implementation MJKFlowMeterModel
//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":MJKFlowMeterSubModel.class}
	;
}
@end
