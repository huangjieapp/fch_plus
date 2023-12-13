//
//  VerificationModel.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/14.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "VerificationModel.h"

#import "PointorderModel.h"


@implementation VerificationModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"pointorder" : [PointorderModel class]
             
             };
}

@end
