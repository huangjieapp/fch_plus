//
//  CGCIntegarlListModel.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/6/19.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "CGCIntegarlListModel.h"
#import "SingleIntegarModel.h"

@implementation CGCIntegarlListModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [SingleIntegarModel class]
             
             };
}

@end
