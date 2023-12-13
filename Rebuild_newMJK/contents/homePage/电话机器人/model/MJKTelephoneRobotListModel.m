//
//  MJKTelephoneRobotListModel.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/28.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTelephoneRobotListModel.h"
#import "MJKTelephoneRobotModel.h"

@implementation MJKTelephoneRobotListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"content" : @"MJKTelephoneRobotModel"};
}
@end
