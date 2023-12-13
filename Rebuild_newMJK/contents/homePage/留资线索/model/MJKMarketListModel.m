//
//  MJKMarketListModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKMarketListModel.h"

@implementation MJKMarketListModel
//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":MJKDataDicModel.class, @"list":MJKDataDicModel.class}
	;
}

@end
