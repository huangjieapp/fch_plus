//
//  MJKCustomerSeaModel.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/12.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKCustomerSeaModel.h"
#import "MJKCustomerSeaSubModel.h"

@implementation MJKCustomerSeaModel
+(NSDictionary *)mj_objectClassInArray {
	return @{@"content" : @"MJKCustomerSeaSubModel"};
}
@end
