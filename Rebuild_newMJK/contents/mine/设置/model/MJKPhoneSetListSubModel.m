//
//  MJKPhoneSetListSubModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/14.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKPhoneSetListSubModel.h"
#import "MJKPhoneSetListSaleModel.h"

@implementation MJKPhoneSetListSubModel
//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"array":MJKPhoneSetListSaleModel.class}
	;
}
@end
