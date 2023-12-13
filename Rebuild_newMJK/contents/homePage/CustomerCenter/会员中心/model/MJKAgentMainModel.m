//
//  MJKAgentMainModel.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/30.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKAgentMainModel.h"
#import "MJKAgentListModel.h"

@implementation MJKAgentMainModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [MJKAgentListModel class]
             
             };
}
@end
