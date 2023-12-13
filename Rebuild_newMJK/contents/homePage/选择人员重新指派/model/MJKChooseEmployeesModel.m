//
//  MJKChooseEmployeesModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/5.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKChooseEmployeesModel.h"
#import "MJKChooseEmployeesSubModel.h"
#import "MJKPKGroupPeopleModel.h"

@implementation MJKChooseEmployeesModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"userList" : @"MJKChooseEmployeesSubModel", @"userList" : @"MJKPKGroupPeopleModel"};
}
@end
