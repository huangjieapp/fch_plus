//
//  MJKShopArriveModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKShopArriveModel.h"
#import "MJKShopArriveSubModel.h"

@implementation MJKShopArriveModel
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":MJKShopArriveSubModel.class}
	;
}
@end
