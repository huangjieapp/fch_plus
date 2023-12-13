//
//  SetManagementModel.m
//  match
//
//  Created by huangjie on 2022/8/28.
//

#import "SetManagementModel.h"

@implementation SetManagementSubModel

@end

@implementation SetManagementModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"defaultList": @"SetManagementSubModel"};
}
@end
