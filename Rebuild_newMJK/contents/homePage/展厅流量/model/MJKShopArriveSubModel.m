//
//  MJKShopArriveSubModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKShopArriveSubModel.h"
#import "MJKShopArriveContentModel.h"

@implementation MJKShopArriveSubModel
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":MJKShopArriveContentModel.class}
	;
}
@end
