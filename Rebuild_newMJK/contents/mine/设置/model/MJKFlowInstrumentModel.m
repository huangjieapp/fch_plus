//
//  MJKFlowInstrumentModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowInstrumentModel.h"
#import "MJKFlowInstrumentSubModel.h"

@implementation MJKFlowInstrumentModel
//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":MJKFlowInstrumentSubModel.class}
	;
}
@end
