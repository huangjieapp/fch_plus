//
//  MJKHistoryModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKHistoryModel.h"
//#import "MJKHistorySubModel.h"
#import "CGCLogModel.h"

@implementation MJKHistoryModel
//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
    return @{@"content":CGCLogModel.class, @"list":CGCLogModel.class }
	;
	
}
@end
