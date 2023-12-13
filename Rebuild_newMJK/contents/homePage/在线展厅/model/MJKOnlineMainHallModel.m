//
//  MJKOnlineMainHallModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/19.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKOnlineMainHallModel.h"
#import "MJKOnlineMainHallSubModel.h"

@implementation MJKOnlineMainHallModel
//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":MJKOnlineMainHallSubModel.class}
	;
}
@end
