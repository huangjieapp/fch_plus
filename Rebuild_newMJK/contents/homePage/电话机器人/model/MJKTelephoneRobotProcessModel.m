//
//  MJKTelephoneRobotProcessModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTelephoneRobotProcessModel.h"

#import "MJKTelephoneRobotProcessSubModel.h"

@implementation MJKTelephoneRobotProcessModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data" : @"MJKTelephoneRobotProcessSubModel"};
}
@end
