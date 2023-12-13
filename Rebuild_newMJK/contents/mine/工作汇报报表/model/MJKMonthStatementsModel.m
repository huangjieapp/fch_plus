//
//  MJKMonthStatementsModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/8.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKMonthStatementsModel.h"
#import "MJKMonthStatementsContentModel.h"

@implementation MJKMonthStatementsModel
+ (NSDictionary *)mj_objectClassInArray {
	return @{@"statusContent" : @"MJKMonthStatementsContentModel"};
}
@end
