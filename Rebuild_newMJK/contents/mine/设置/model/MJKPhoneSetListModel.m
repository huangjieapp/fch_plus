//
//  MJKPhoneSetListModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/14.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKPhoneSetListModel.h"
#import "MJKPhoneSetListSubModel.h"

@implementation MJKPhoneSetListModel
//数组 里面是 哪个model的类
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
	
	return @{@"content":MJKPhoneSetListSubModel.class}
	;
}
@end
