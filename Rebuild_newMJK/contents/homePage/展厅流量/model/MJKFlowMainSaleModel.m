//
//  MJKFlowMainSaleModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/8.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowMainSaleModel.h"

@implementation MJKFlowMainSaleModel
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":MJKFlowSalesModel.class,@"data":MJKFlowSalesModel.class}
	;
}
@end
