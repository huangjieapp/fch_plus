//
//  MJKCustomReturnSubModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKCustomReturnSubModel.h"

#import "MJKPushDefaultListModel.h"

@implementation MJKCustomReturnSubModel
+ (NSDictionary *)mj_objectClassInArray {
	return @{@"defaultList" : @"MJKPushDefaultListModel"};
}
@end
