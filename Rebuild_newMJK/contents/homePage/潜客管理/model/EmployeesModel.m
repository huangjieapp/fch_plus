//
//  EmployeesModel.m
//  match
//
//  Created by huangjie on 2022/8/23.
//

#import "EmployeesModel.h"

@implementation EmployeesSubModel

@end

@implementation EmployeesModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"userList": [EmployeesSubModel class]};
}
@end
