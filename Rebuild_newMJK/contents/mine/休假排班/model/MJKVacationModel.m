//
//  MJKVacationModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/7.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKVacationModel.h"
#import "MJKVacationContentModel.h"

@implementation MJKVacationModel
+(NSDictionary *)mj_objectClassInArray {
	return @{@"content" : @"MJKVacationContentModel"};
}
@end
