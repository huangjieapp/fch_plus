//
//  CGCCustomDetailModel.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/1.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCCustomDetailModel.h"
#import "CGCCustomModel.h"


@implementation CGCCustomDetailModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"content" : [CGCCustomModel class]
             
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"content" : @"CGCCustomModel"};
}

@end
