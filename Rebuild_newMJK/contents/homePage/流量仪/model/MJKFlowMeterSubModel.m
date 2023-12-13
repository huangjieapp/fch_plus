//
//  MJKFlowMeterSubModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/9.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowMeterSubModel.h"
#import "MJKFlowMeterSubSecondModel.h"

@implementation MJKFlowMeterSubModel
//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":MJKFlowMeterSubSecondModel.class}
	;
}
@end
